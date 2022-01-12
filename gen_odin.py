#-------------------------------------------------------------------------------
#   Read output of gen_json.py and generate Zig language bindings.
#
#   Zig coding style:
#   - types are PascalCase
#   - functions are camelCase
#   - otherwise snake_case
#-------------------------------------------------------------------------------
import gen_ir
import json, re, os, shutil

module_names = {
    'sg_':      'gfx',
    'sapp_':    'app',
    'stm_':     'time',
    'saudio_':  'audio',
    'sgl_':     'gl',
    'sdtx_':    'debugtext',
    'sshape_':  'shape',
}

c_source_paths = {
    'sg_':      './src/sokol/c/sokol_gfx.c',
    'sapp_':    './src/sokol/c/sokol_app.c',
    'stm_':     './src/sokol/c/sokol_time.c',
    'saudio_':  './src/sokol/c/sokol_audio.c',
    'sgl_':     './src/sokol/c/sokol_gl.c',
    'sdtx_':    './src/sokol/c/sokol_debugtext.c',
    'sshape_':  './src/sokol/c/sokol_shape.c',
}

name_ignores = [
    'sdtx_printf',
    'sdtx_vprintf',
    'sg_install_trace_hooks',
    'sg_trace_hooks',
    ''
]

func_ptr_arg_names = {
    'event_cb': ['e'],
    'fail_cb': ['msg'],
    'init_userdata_cb': ['user_data'],
    'frame_userdata_cb': ['user_data'],
    'cleanup_userdata_cb': ['user_data'],
    'event_userdata_cb': ['e', 'user_data'],
    'fail_userdata_cb': ['msg', 'user_data'],
}

name_overrides = {
    'sgl_error':    'sgl_get_error',   # 'error' is reserved in Zig
    'sgl_deg':      'sgl_as_degrees',
    'sgl_rad':      'sgl_as_radians',
    'context': 'ctx'
}

# NOTE: syntax for function results: "func_name.RESULT"
type_overrides = {
    'sg_context_desc.color_format':         'int',
    'sg_context_desc.depth_format':         'int',
    'sg_apply_uniforms.ub_index':           'uint32_t',
    'sg_draw.base_element':                 'uint32_t',
    'sg_draw.num_elements':                 'uint32_t',
    'sg_draw.num_instances':                'uint32_t',
    'sshape_element_range_t.base_element':  'uint32_t',
    'sshape_element_range_t.num_elements':  'uint32_t',
    'sdtx_font.font_index':                 'uint32_t',
    'sapp_keycode.': 'Key_Code',
    'sapp_mousebutton.': 'Mouse_Button',
}

# use the const for array initialization
array_num_const_overrides = {
    'sapp_event.touches':                   'MAX_TOUCHPOINTS'
}

prim_types = {
    'int':          'c.int',
    'bool':         'bool',
    'char':         'u8',
    'int8_t':       'i8',
    'uint8_t':      'u8',
    'int16_t':      'i16',
    'uint16_t':     'u16',
    'int32_t':      'i32',
    'uint32_t':     'u32',
    'int64_t':      'i64',
    'uint64_t':     'u64',
    'float':        'f32',
    'double':       'f64',
    'uintptr_t':    'uint',
    'intptr_t':     'int',
    'size_t':       'int'
}

prim_defaults = {
    'int':          '0',
    'bool':         'false',
    'int8_t':       '0',
    'uint8_t':      '0',
    'int16_t':      '0',
    'uint16_t':     '0',
    'int32_t':      '0',
    'uint32_t':     '0',
    'int64_t':      '0',
    'uint64_t':     '0',
    'float':        '0.0',
    'double':       '0.0',
    'uintptr_t':    '0',
    'intptr_t':     '0',
    'size_t':       '0'
}

struct_types = []
enum_types = []
enum_items = {}
out_lines = ''

def reset_globals():
    global struct_types
    global enum_types
    global enum_items
    global out_lines
    struct_types = []
    enum_types = []
    enum_items = {}
    out_lines = ''

re_1d_array = re.compile("^(?:const )?\w*\s\*?\[\d*\]$")
re_2d_array = re.compile("^(?:const )?\w*\s\*?\[\d*\]\[\d*\]$")

def l(s):
    global out_lines
    out_lines += s + '\n'

def as_zig_prim_type(s):
    return prim_types[s]

# prefix_bla_blub(_t) => (dep.)BlaBlub
def as_zig_struct_type(s, prefix):
    parts = s.lower().split('_')
    outp = '' if s.startswith(prefix) else f'{parts[0]}.'
    for part in parts[1:]:
        if (part != 't'):
            outp += part.capitalize()
    return outp

# prefix_bla_blub(_t) => (dep.)BlaBlub
# def as_zig_enum_type(s, prefix):
#     parts = s.lower().split('_')
#     outp = '' if s.startswith(prefix) else f'{parts[0]}.'
#     for part in parts[1:]:
#         if (part != 't'):
#             outp += part.capitalize()
#     return outp

def as_odin_enum_type(s, prefix):
    parts = s.split('_')
    if not s.startswith(prefix):
        return f'{parts[0].capitalize()}.'
    outp = [] 
    for part in parts[1:]:
        if (part != 't'):
            outp.append(part.capitalize())
    return '_'.join(outp)


def check_array_num_const_override(func_or_struct_name, field_or_arg_name, orig_type):
    s = f"{func_or_struct_name}.{field_or_arg_name}"
    if s in array_num_const_overrides:
        return [array_num_const_overrides[s]]
    else:
        return orig_type

def check_type_override(func_or_struct_name, field_or_arg_name, orig_type):
    s = f"{func_or_struct_name}.{field_or_arg_name}"
    # print(s)
    if s in type_overrides:
        return type_overrides[s]
    else:
        return orig_type

def check_name_override(name):
    if name in name_overrides:
        return name_overrides[name]
    else:
        return name

def check_name_ignore(name):
    return name in name_ignores

# PREFIX_BLA_BLUB to bla_blub
def as_snake_case(s, prefix):
    outp = s.lower()
    if outp.startswith(prefix):
        outp = outp[len(prefix):]
    return outp

# 
def as_snake_case_upper(s, prefix):
    outp = s.upper()
    if outp.startswith(prefix.upper()):
        outp = outp[len(prefix):]
    return outp

# prefix_bla_blub => blaBlub
def as_camel_case(s):
    parts = s.lower().split('_')[1:]
    outp = parts[0]
    for part in parts[1:]:
        outp += part.capitalize()
    return outp

# PREFIX_ENUM_BLA => Bla, _PREFIX_ENUM_BLA => Bla
def as_enum_item_name(s):
    outp = s
    if outp.startswith('_'):
        outp = outp[1:]
    parts = outp.split('_')[2:]
    outp = '_'.join(parts)
    if outp[0].isdigit():
        outp = 'NUM_' + outp
    return outp

def enum_default_item(enum_name):
    return enum_items[enum_name][0]

def is_prim_type(s):
    return s in prim_types

def is_struct_type(s):
    return s in struct_types

def is_enum_type(s):
    return s in enum_types

def is_string_ptr(s):
    return s == "const char *"

def is_const_void_ptr(s):
    return s == "const void *"

def is_void_ptr(s):
    return s == "void *"

def is_const_prim_ptr(s):
    for prim_type in prim_types:
        if s == f"const {prim_type} *":
            return True
    return False

def is_prim_ptr(s):
    for prim_type in prim_types:
        if s == f"{prim_type} *":
            return True
    return False

def is_const_struct_ptr(s):
    for struct_type in struct_types:
        if s == f"const {struct_type} *":
            return True
    return False

def is_func_ptr(s):
    return '(*)' in s

def is_1d_array_type(s):
    return re_1d_array.match(s)

def is_2d_array_type(s):
    return re_2d_array.match(s)

def type_default_value(s):
    return prim_defaults[s]

def extract_array_type(s):
    return s[:s.index('[')].strip()

def extract_array_nums(s):
    return s[s.index('['):].replace('[', ' ').replace(']', ' ').split()

def extract_ptr_type(s):
    tokens = s.split()
    if tokens[0] == 'const':
        return tokens[1]
    else:
        return tokens[0]

def as_extern_c_arg_type(arg_type, prefix):
    if arg_type == "void":
        return "void"
    elif is_prim_type(arg_type):
        return as_zig_prim_type(arg_type)
    elif is_struct_type(arg_type):
        return as_zig_struct_type(arg_type, prefix)
    elif is_enum_type(arg_type):
        return as_odin_enum_type(arg_type, prefix)
    elif is_void_ptr(arg_type) or is_const_void_ptr(arg_type):
        return "rawptr"
    elif is_string_ptr(arg_type):
        return "cstring"
    elif is_const_struct_ptr(arg_type):
        return f"^{as_zig_struct_type(extract_ptr_type(arg_type), prefix)}"
    elif is_prim_ptr(arg_type):
        return f"^{as_zig_prim_type(extract_ptr_type(arg_type))}"
    elif is_const_prim_ptr(arg_type):
        return f"^{as_zig_prim_type(extract_ptr_type(arg_type))}"
    else:
        return '??? (as_extern_c_arg_type)'

def as_zig_arg_type(arg_prefix, arg_type, prefix):
    # NOTE: if arg_prefix is None, the result is used as return value
    pre = "" if arg_prefix is None else arg_prefix
    if arg_type == "void":
        if arg_prefix is None:
            return "void"
        else:
            return ""
    elif is_prim_type(arg_type):
        return pre + as_zig_prim_type(arg_type)
    elif is_struct_type(arg_type):
        return pre + as_zig_struct_type(arg_type, prefix)
    elif is_enum_type(arg_type):
        return pre + as_odin_enum_type(arg_type, prefix)
    elif is_void_ptr(arg_type):
        return pre + "rawptr"
    elif is_const_void_ptr(arg_type):
        return pre + "rawptr"
    elif is_string_ptr(arg_type):
        return pre + "cstring"
    elif is_const_struct_ptr(arg_type):
        # not a bug, pass const structs by value
        return pre + f"{as_zig_struct_type(extract_ptr_type(arg_type), prefix)}"
    elif is_prim_ptr(arg_type):
        return pre + f"^{as_zig_prim_type(extract_ptr_type(arg_type))}"
    elif is_const_prim_ptr(arg_type):
        return pre + f"^{as_zig_prim_type(extract_ptr_type(arg_type))}"
    else:
        return arg_prefix + "??? (as_zig_arg_type)"

# get C-style arguments of a function pointer as string
def funcptr_args_c(field_type, prefix):
    tokens = field_type[field_type.index('(*)')+4:-1].split(',')
    s = ""
    for token in tokens:
        arg_type = token.strip()
        if s != "":
            s += ", "
        c_arg = as_extern_c_arg_type(arg_type, prefix)
        print(c_arg)
        if (c_arg == "void"):
            return ""
        else:
            s += c_arg
    return s

def funcptr_named_args(field_type, prefix, field_names):
    tokens = field_type[field_type.index('(*)')+4:-1].split(',')
    s = ""
    named = len(field_names) > 0
    for idx, token in enumerate(tokens):
        arg_type = token.strip()
        if s != "":
            s += ", "

        if named:
            c_arg = as_extern_c_arg_type(arg_type, prefix)
            s += f"{field_names[idx]}: {c_arg}"
        else:
            return ""
 
    return s

# get C-style result of a function pointer as string
def funcptr_res_c(field_type):
    res_type = field_type[:field_type.index('(*)')].strip()
    if res_type == 'void':
        return ''
    elif is_const_void_ptr(res_type):
        return ' -> rawptr'
    else:
        return '???'

def funcdecl_args_c(decl, prefix):
    s = ""
    func_name = decl['name']
    for param_decl in decl['params']:
        if s != "":
            s += ", "
        param_name = param_decl['name']
        param_type = check_type_override(func_name, param_name, param_decl['type'])
        s += as_extern_c_arg_type(param_type, prefix)
    return s

def funcdecl_args_zig(decl, prefix):
    s = ""
    func_name = decl['name']
    for param_decl in decl['params']:
        if s != "":
            s += ", "
        param_name = param_decl['name']
        param_type = check_type_override(func_name, param_name, param_decl['type'])
        s += f"{as_zig_arg_type(f'{param_name}: ', param_type, prefix)}"
    return s

def funcdecl_result_c(decl, prefix):
    func_name = decl['name']
    decl_type = decl['type']
    result_type = check_type_override(func_name, 'RESULT', decl_type[:decl_type.index('(')].strip())
    return as_extern_c_arg_type(result_type, prefix)

def funcdecl_result_zig(decl, prefix):
    func_name = decl['name']
    decl_type = decl['type']
    result_type = check_type_override(func_name, 'RESULT', decl_type[:decl_type.index('(')].strip())
    zig_res_type = as_zig_arg_type(None, result_type, prefix)
    if zig_res_type == "":
        zig_res_type = "void"
    return zig_res_type

def gen_struct(decl, prefix, use_raw_name=False):
    struct_name = decl['name']
    zig_type = struct_name if use_raw_name else as_zig_struct_type(struct_name, prefix)
    l(f"{zig_type} :: struct {{")
    for field in decl['fields']:
        field_name = field['name']
        field_type = field['type']
        field_name = check_name_override(field_name)
        field_type = check_type_override(struct_name, field_name, field_type)
        if is_prim_type(field_type):
            l(f"    {field_name}: {as_zig_prim_type(field_type)},")
        elif is_struct_type(field_type):
            l(f"    {field_name}: {as_zig_struct_type(field_type, prefix)},")
        elif is_enum_type(field_type):
            l(f"    {field_name}: {as_odin_enum_type(field_type, prefix)},")
        elif is_string_ptr(field_type):
            l(f"    {field_name}: cstring,")
        elif is_const_void_ptr(field_type):
            l(f"    {field_name}: rawptr,")
        elif is_void_ptr(field_type):
            l(f"    {field_name}: rawptr,")
        elif is_const_prim_ptr(field_type):
            l(f"    {field_name}: ?[*]const {as_zig_prim_type(extract_ptr_type(field_type))} = null,")
        elif is_func_ptr(field_type):
            field_names = func_ptr_arg_names.get(field_name, [])
            l(f"    {field_name}: proc \"c\" ({funcptr_named_args(field_type, prefix, field_names)}){funcptr_res_c(field_type)},")
        elif is_1d_array_type(field_type):
            array_type = extract_array_type(field_type)
            array_nums = extract_array_nums(field_type)
            array_nums = check_array_num_const_override(struct_name, field_name, array_nums)
            if is_prim_type(array_type) or is_struct_type(array_type):
                if is_prim_type(array_type):
                    zig_type = as_zig_prim_type(array_type)
                    def_val = type_default_value(array_type)
                elif is_struct_type(array_type):
                    zig_type = as_zig_struct_type(array_type, prefix)
                    def_val = '.{}'
                elif is_enum_type(array_type):
                    zig_type = as_odin_enum_type(array_type, prefix)
                    def_val = '.{}'
                else:
                    zig_type = '??? (array type)'
                    def_val = '???'
                array_num = array_nums[0]

                t0 = f"[{array_num}]{zig_type}"
                t0_slice = f"[]const {zig_type}"
                t1 = f"[_]{zig_type}"
                l(f"    {field_name}: {t0},")
            elif is_const_void_ptr(array_type):
                l(f"    {field_name}: [{array_nums[0]}]rawptr,")
            else:
                l(f"//    FIXME: ??? array {field_name}: {field_type} => {array_type} [{array_nums[0]}]")
        elif is_2d_array_type(field_type):
            array_type = extract_array_type(field_type)
            array_nums = extract_array_nums(field_type)
            if is_prim_type(array_type):
                zig_type = as_zig_prim_type(array_type)
                def_val = type_default_value(array_type)
            elif is_struct_type(array_type):
                zig_type = as_zig_struct_type(array_type, prefix)
                def_val = ".{ }"
            else:
                zig_type = "???"
                def_val = "???"
            t0 = f"[{array_nums[0]}][{array_nums[1]}]{zig_type}"
            l(f"    {field_name}: {t0},")
        else:
            l(f"// FIXME: {field_name}: {field_type};")
    l("}")

def gen_consts(decl, prefix):
    for item in decl['items']:
        l(f"{as_snake_case_upper(item['name'], prefix)} :: {item['value']}")

def gen_enum(decl, prefix):
    enum_type = as_odin_enum_type(decl['name'], prefix)
    print(decl['name'])
    enum_type = check_type_override(decl['name'], '', enum_type)
    l(f"{enum_type} :: enum i32 {{")
    for item in decl['items']:
        item_name = as_enum_item_name(item['name'])
        if item_name != "FORCE_U32":
            if item_name == "DEFAULT" or item_name == "NUM":
                l(f"    _{item_name},")
            else:   
                if 'value' in item:
                    l(f"    {item_name} = {item['value']},")
                else:
                    l(f"    {item_name},")      
    l("}")

def gen_func_c(decl, prefix):
    l(f"pub extern fn {decl['name']}({funcdecl_args_c(decl, prefix)}) {funcdecl_result_c(decl, prefix)};")

def gen_func_zig(decl, prefix):
    c_func_name = decl['name']
    zig_func_name = as_camel_case(check_name_override(decl['name']))
    zig_res_type = funcdecl_result_zig(decl, prefix)
    l(f"{zig_func_name} :: proc({funcdecl_args_zig(decl, prefix)}) {zig_res_type} {{")
    if zig_res_type != 'void':
        s = f"    return {c_func_name}("
    else:
        s = f"    {c_func_name}("
    for i, param_decl in enumerate(decl['params']):
        if i > 0:
            s += ", "
        arg_name = param_decl['name']
        arg_type = param_decl['type']
        if is_const_struct_ptr(arg_type):
            s += f"&{arg_name}"
        elif is_string_ptr(arg_type):
            s += f"@ptrCast([*c]const u8,{arg_name})"
        else:
            s += arg_name
    s += ");"
    l(s)
    l("}")

def gen_func_odin(decl, prefix):
    odin_func_name = check_name_override(decl['name'])[len(prefix):]
    odin_res_type = funcdecl_result_zig(decl, prefix)
    if odin_res_type != 'void':
        l(f"    {odin_func_name} :: proc({funcdecl_args_zig(decl, prefix)}) -> {odin_res_type} ---")
    else:
        l(f"    {odin_func_name} :: proc({funcdecl_args_zig(decl, prefix)}) ---")

def pre_parse(inp):
    global struct_types
    global enum_types
    for decl in inp['decls']:
        kind = decl['kind']
        if kind == 'struct':
            struct_types.append(decl['name'])
        elif kind == 'enum':
            enum_name = decl['name']
            enum_types.append(enum_name)
            enum_items[enum_name] = []
            for item in decl['items']:
                enum_items[enum_name].append(as_enum_item_name(item['name']))

def gen_imports(inp, dep_prefixes):
    for dep_prefix in dep_prefixes:
        dep_module_name = module_names[dep_prefix]
        l(f'const {dep_prefix[:-1]} = @import("{dep_module_name}.zig");')
        l('')

def gen_helpers(inp):
    if inp['prefix'] in ['sg_', 'sdtx_', 'sshape_']:
        l('// helper function to convert "anything" to a Range struct')

    if inp['prefix'] == 'sdtx_':
        l('// std.fmt compatible Writer')

def gen_bit_sets(inp):
    if inp['prefix'] == 'sapp_':
        l('Modifier :: enum u32 {')
        l('    SHIFT = 0,')
        l('    CTRL  = 1,')
        l('    ALT   = 2,')
        l('    SUPER = 3,')
        l('    LMB = 8,')
        l('    RMB = 9,')
        l('    MMB = 10,')
        l('}')
        l('Modifier_Set :: distinct bit_set[Modifier; u32]')

def gen_foreign_import(inp):
    if inp['prefix'] == 'sapp_':
        l('when ODIN_OS == "windows" {')
        l('    when ODIN_DEBUG == true {')
        l('        foreign import sapp_lib "../lib/sokol_appd.lib"')
        l('    } else {')
        l('        foreign import sapp_lib "../lib/sokol_app.lib"')
        l('    }')
        l('} else when ODIN_OS == "darwin" {')
        l('    foreign import sapp_lib "../lib/sokol_app_metal.a"')
        l('}')
    if inp['prefix'] == 'stm_':
        l('when ODIN_OS == "windows" do foreign import stm_lib "../lib/sokol_time.lib"')
        l('else when ODIN_OS == "darwin" do foreign import stm_lib "../lib/sokol_time.a"')
    if inp['prefix'] == 'sg_':
        l('when ODIN_OS == "windows" {')
        l('    when ODIN_DEBUG == true {')
        l('        foreign import sg_lib "../lib/sokol_gfxd.lib"')
        l('    } else {')
        l('        foreign import sg_lib "../lib/sokol_gfx.lib"')
        l('    }')
        l('} else when ODIN_OS == "darwin" {')
        l('    foreign import sg_lib "../lib/sokol_gfx_metal.a"')
        l('}')
def gen_module(inp, dep_prefixes, module_name):
    l('// machine generated, do not edit')
    l('')
    l(f'package {module_name}')
    l('')
    gen_foreign_import(inp)
    l('')
    l('import "core:c"')
    l('')
    gen_imports(inp, dep_prefixes)
    gen_helpers(inp)
    pre_parse(inp)
    prefix = inp['prefix']
    grouped_decl = { 'consts': [], 'func' :[], 'struct': [], 'enum': []}
    for decl in inp['decls']:
        if not decl['is_dep']:
            kind = decl['kind']
            if kind == 'consts':
                grouped_decl[kind].append(decl)
            elif not check_name_ignore(decl['name']):
                if kind == 'struct':
                    grouped_decl[kind].append(decl)
                elif kind == 'enum':
                    grouped_decl[kind].append(decl)
                elif kind == 'func':
                    grouped_decl[kind].append(decl)

    l('')
    l('// Constants')  
    for decl in grouped_decl['consts']:
        gen_consts(decl, prefix)
        l('')

    l('// Bit Sets')
    l('')
    gen_bit_sets(inp)
    l('')

    l('// Enums')
    l('')
    for decl in grouped_decl['enum']:
        gen_enum(decl, prefix)
        l('')

    l('// Structs')
    l('')    
    for decl in grouped_decl['struct']:
        gen_struct(decl, prefix)
        l('')

    l('// Procedures')
    l('')  
    l('@(default_calling_convention="c")')
    l(f'@(link_prefix="{prefix}")')
    l(f'foreign {prefix}lib {{')
    for decl in grouped_decl['func']:
        gen_func_odin(decl, prefix)
    l('}') 

def prepare():
    print('Generating odin bindings:')
    if not os.path.isdir('./src/sokol'):
        os.makedirs('./src/sokol')
    if not os.path.isdir('./src/sokol/c'):
        os.makedirs('./src/sokol/c')

def gen(c_header_path, c_prefix, dep_c_prefixes):
    module_name = module_names[c_prefix]
    c_source_path = c_source_paths[c_prefix]
    print(f'  {c_header_path} => {module_name}')
    reset_globals()
    shutil.copyfile(c_header_path, f'./src/sokol/c/{os.path.basename(c_header_path)}')
    ir = gen_ir.gen(c_header_path, c_source_path, module_name, c_prefix, dep_c_prefixes)
    gen_module(ir, dep_c_prefixes, module_name)
    output_path = f"./src/sokol/{ir['module']}/{ir['module']}.odin"
    print(output_path)
    with open(output_path, 'w', newline='\n') as f_outp:
        f_outp.write(out_lines)

tasks = [
    [ './sokol_gfx.h',            'sg_',       [] ],
    [ './sokol_app.h',            'sapp_',     [] ],
    [ './sokol_time.h',           'stm_',      [] ],
    # [ '../sokol_audio.h',          'saudio_',   [] ],
    # [ '../util/sokol_gl.h',        'sgl_',      ['sg_'] ],
    # [ '../util/sokol_debugtext.h', 'sdtx_',     ['sg_'] ],
    # [ '../util/sokol_shape.h',     'sshape_',   ['sg_'] ],
]

prepare()
for task in tasks:
    c_header_path = task[0]
    main_prefix = task[1]
    dep_prefixes = task[2]
    gen(c_header_path, main_prefix, dep_prefixes)