// machine generated, do not edit

package gfx

when ODIN_OS == "windows" {
    when ODIN_DEBUG == true {
        foreign import sg_lib "../lib/sokol_gfxd.lib"
    } else {
        foreign import sg_lib "../lib/sokol_gfx.lib"
    }
} else when ODIN_OS == "darwin" {
    foreign import sg_lib "../lib/sokol_gfx_metal.a"
}

import "core:c"

// helper function to convert "anything" to a Range struct

// Constants
INVALID_ID :: 0
NUM_SHADER_STAGES :: 2
NUM_INFLIGHT_FRAMES :: 2
MAX_COLOR_ATTACHMENTS :: 4
MAX_SHADERSTAGE_BUFFERS :: 8
MAX_SHADERSTAGE_IMAGES :: 12
MAX_SHADERSTAGE_UBS :: 4
MAX_UB_MEMBERS :: 16
MAX_VERTEX_ATTRIBUTES :: 16
MAX_MIPMAPS :: 16
MAX_TEXTUREARRAY_LAYERS :: 128

// Bit Sets


// Enums

Backend :: enum i32 {
    GLCORE33,
    GLES2,
    GLES3,
    D3D11,
    METAL_IOS,
    METAL_MACOS,
    METAL_SIMULATOR,
    WGPU,
    DUMMY,
}

Pixel_Format :: enum i32 {
    _DEFAULT,
    NONE,
    R8,
    R8SN,
    R8UI,
    R8SI,
    R16,
    R16SN,
    R16UI,
    R16SI,
    R16F,
    RG8,
    RG8SN,
    RG8UI,
    RG8SI,
    R32UI,
    R32SI,
    R32F,
    RG16,
    RG16SN,
    RG16UI,
    RG16SI,
    RG16F,
    RGBA8,
    RGBA8SN,
    RGBA8UI,
    RGBA8SI,
    BGRA8,
    RGB10A2,
    RG11B10F,
    RG32UI,
    RG32SI,
    RG32F,
    RGBA16,
    RGBA16SN,
    RGBA16UI,
    RGBA16SI,
    RGBA16F,
    RGBA32UI,
    RGBA32SI,
    RGBA32F,
    DEPTH,
    DEPTH_STENCIL,
    BC1_RGBA,
    BC2_RGBA,
    BC3_RGBA,
    BC4_R,
    BC4_RSN,
    BC5_RG,
    BC5_RGSN,
    BC6H_RGBF,
    BC6H_RGBUF,
    BC7_RGBA,
    PVRTC_RGB_2BPP,
    PVRTC_RGB_4BPP,
    PVRTC_RGBA_2BPP,
    PVRTC_RGBA_4BPP,
    ETC2_RGB8,
    ETC2_RGB8A1,
    ETC2_RGBA8,
    ETC2_RG11,
    ETC2_RG11SN,
    _NUM,
}

Resource_State :: enum i32 {
    INITIAL,
    ALLOC,
    VALID,
    FAILED,
    INVALID,
}

Usage :: enum i32 {
    _DEFAULT,
    IMMUTABLE,
    DYNAMIC,
    STREAM,
    _NUM,
}

Buffer_Type :: enum i32 {
    _DEFAULT,
    VERTEXBUFFER,
    INDEXBUFFER,
    _NUM,
}

Index_Type :: enum i32 {
    _DEFAULT,
    NONE,
    UINT16,
    UINT32,
    _NUM,
}

Image_Type :: enum i32 {
    _DEFAULT,
    NUM_2D,
    CUBE,
    NUM_3D,
    ARRAY,
    _NUM,
}

Sampler_Type :: enum i32 {
    _DEFAULT,
    FLOAT,
    SINT,
    UINT,
}

Cube_Face :: enum i32 {
    POS_X,
    NEG_X,
    POS_Y,
    NEG_Y,
    POS_Z,
    NEG_Z,
    _NUM,
}

Shader_Stage :: enum i32 {
    VS,
    FS,
}

Primitive_Type :: enum i32 {
    _DEFAULT,
    POINTS,
    LINES,
    LINE_STRIP,
    TRIANGLES,
    TRIANGLE_STRIP,
    _NUM,
}

Filter :: enum i32 {
    _DEFAULT,
    NEAREST,
    LINEAR,
    NEAREST_MIPMAP_NEAREST,
    NEAREST_MIPMAP_LINEAR,
    LINEAR_MIPMAP_NEAREST,
    LINEAR_MIPMAP_LINEAR,
    _NUM,
}

Wrap :: enum i32 {
    _DEFAULT,
    REPEAT,
    CLAMP_TO_EDGE,
    CLAMP_TO_BORDER,
    MIRRORED_REPEAT,
    _NUM,
}

Border_Color :: enum i32 {
    _DEFAULT,
    TRANSPARENT_BLACK,
    OPAQUE_BLACK,
    OPAQUE_WHITE,
    _NUM,
}

Vertex_Format :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    BYTE4,
    BYTE4N,
    UBYTE4,
    UBYTE4N,
    SHORT2,
    SHORT2N,
    USHORT2N,
    SHORT4,
    SHORT4N,
    USHORT4N,
    UINT10_N2,
    _NUM,
}

Vertex_Step :: enum i32 {
    _DEFAULT,
    PER_VERTEX,
    PER_INSTANCE,
    _NUM,
}

Uniform_Type :: enum i32 {
    INVALID,
    FLOAT,
    FLOAT2,
    FLOAT3,
    FLOAT4,
    INT,
    INT2,
    INT3,
    INT4,
    MAT4,
    _NUM,
}

Uniform_Layout :: enum i32 {
    _DEFAULT,
    NATIVE,
    STD140,
    _NUM,
}

Cull_Mode :: enum i32 {
    _DEFAULT,
    NONE,
    FRONT,
    BACK,
    _NUM,
}

Face_Winding :: enum i32 {
    _DEFAULT,
    CCW,
    CW,
    _NUM,
}

Compare_Func :: enum i32 {
    _DEFAULT,
    NEVER,
    LESS,
    EQUAL,
    LESS_EQUAL,
    GREATER,
    NOT_EQUAL,
    GREATER_EQUAL,
    ALWAYS,
    _NUM,
}

Stencil_Op :: enum i32 {
    _DEFAULT,
    KEEP,
    ZERO,
    REPLACE,
    INCR_CLAMP,
    DECR_CLAMP,
    INVERT,
    INCR_WRAP,
    DECR_WRAP,
    _NUM,
}

Blend_Factor :: enum i32 {
    _DEFAULT,
    ZERO,
    ONE,
    SRC_COLOR,
    ONE_MINUS_SRC_COLOR,
    SRC_ALPHA,
    ONE_MINUS_SRC_ALPHA,
    DST_COLOR,
    ONE_MINUS_DST_COLOR,
    DST_ALPHA,
    ONE_MINUS_DST_ALPHA,
    SRC_ALPHA_SATURATED,
    BLEND_COLOR,
    ONE_MINUS_BLEND_COLOR,
    BLEND_ALPHA,
    ONE_MINUS_BLEND_ALPHA,
    _NUM,
}

Blend_Op :: enum i32 {
    _DEFAULT,
    ADD,
    SUBTRACT,
    REVERSE_SUBTRACT,
    _NUM,
}

Color_Mask :: enum i32 {
    _DEFAULT,
    NONE = 16,
    R = 1,
    G = 2,
    RG = 3,
    B = 4,
    RB = 5,
    GB = 6,
    RGB = 7,
    A = 8,
    RA = 9,
    GA = 10,
    RGA = 11,
    BA = 12,
    RBA = 13,
    GBA = 14,
    RGBA = 15,
}

Action :: enum i32 {
    _DEFAULT,
    CLEAR,
    LOAD,
    DONTCARE,
    _NUM,
}

// Structs

Buffer :: struct {
    id: u32,
}

Image :: struct {
    id: u32,
}

Shader :: struct {
    id: u32,
}

Pipeline :: struct {
    id: u32,
}

Pass :: struct {
    id: u32,
}

Context :: struct {
    id: u32,
}

Range :: struct {
    ptr: rawptr,
    size: int,
}

Color :: struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
}

PixelformatInfo :: struct {
    sample: bool,
    filter: bool,
    render: bool,
    blend: bool,
    msaa: bool,
    depth: bool,
}

Features :: struct {
    instancing: bool,
    origin_top_left: bool,
    multiple_render_targets: bool,
    msaa_render_targets: bool,
    imagetype_3d: bool,
    imagetype_array: bool,
    image_clamp_to_border: bool,
    mrt_independent_blend_state: bool,
    mrt_independent_write_mask: bool,
}

Limits :: struct {
    max_image_size_2d: c.int,
    max_image_size_cube: c.int,
    max_image_size_3d: c.int,
    max_image_size_array: c.int,
    max_image_array_layers: c.int,
    max_vertex_attrs: c.int,
    gl_max_vertex_uniform_vectors: c.int,
}

ColorAttachmentAction :: struct {
    action: Action,
    value: Color,
}

DepthAttachmentAction :: struct {
    action: Action,
    value: f32,
}

StencilAttachmentAction :: struct {
    action: Action,
    value: u8,
}

PassAction :: struct {
    _start_canary: u32,
    colors: [4]ColorAttachmentAction,
    depth: DepthAttachmentAction,
    stencil: StencilAttachmentAction,
    _end_canary: u32,
}

Bindings :: struct {
    _start_canary: u32,
    vertex_buffers: [8]Buffer,
    vertex_buffer_offsets: [8]c.int,
    index_buffer: Buffer,
    index_buffer_offset: c.int,
    vs_images: [12]Image,
    fs_images: [12]Image,
    _end_canary: u32,
}

BufferDesc :: struct {
    _start_canary: u32,
    size: int,
    type: Buffer_Type,
    usage: Usage,
    data: Range,
    label: cstring,
    gl_buffers: [2]u32,
    mtl_buffers: [2]rawptr,
    d3d11_buffer: rawptr,
    wgpu_buffer: rawptr,
    _end_canary: u32,
}

ImageData :: struct {
    subimage: [6][16]Range,
}

ImageDesc :: struct {
    _start_canary: u32,
    type: Image_Type,
    render_target: bool,
    width: c.int,
    height: c.int,
    num_slices: c.int,
    num_mipmaps: c.int,
    usage: Usage,
    pixel_format: Pixel_Format,
    sample_count: c.int,
    min_filter: Filter,
    mag_filter: Filter,
    wrap_u: Wrap,
    wrap_v: Wrap,
    wrap_w: Wrap,
    border_color: Border_Color,
    max_anisotropy: u32,
    min_lod: f32,
    max_lod: f32,
    data: ImageData,
    label: cstring,
    gl_textures: [2]u32,
    gl_texture_target: u32,
    mtl_textures: [2]rawptr,
    d3d11_texture: rawptr,
    d3d11_shader_resource_view: rawptr,
    wgpu_texture: rawptr,
    _end_canary: u32,
}

ShaderAttrDesc :: struct {
    name: cstring,
    sem_name: cstring,
    sem_index: c.int,
}

ShaderUniformDesc :: struct {
    name: cstring,
    type: Uniform_Type,
    array_count: c.int,
}

ShaderUniformBlockDesc :: struct {
    size: int,
    layout: Uniform_Layout,
    uniforms: [16]ShaderUniformDesc,
}

ShaderImageDesc :: struct {
    name: cstring,
    image_type: Image_Type,
    sampler_type: Sampler_Type,
}

ShaderStageDesc :: struct {
    source: cstring,
    bytecode: Range,
    entry: cstring,
    d3d11_target: cstring,
    uniform_blocks: [4]ShaderUniformBlockDesc,
    images: [12]ShaderImageDesc,
}

ShaderDesc :: struct {
    _start_canary: u32,
    attrs: [16]ShaderAttrDesc,
    vs: ShaderStageDesc,
    fs: ShaderStageDesc,
    label: cstring,
    _end_canary: u32,
}

BufferLayoutDesc :: struct {
    stride: c.int,
    step_func: Vertex_Step,
    step_rate: c.int,
}

VertexAttrDesc :: struct {
    buffer_index: c.int,
    offset: c.int,
    format: Vertex_Format,
}

LayoutDesc :: struct {
    buffers: [8]BufferLayoutDesc,
    attrs: [16]VertexAttrDesc,
}

StencilFaceState :: struct {
    compare: Compare_Func,
    fail_op: Stencil_Op,
    depth_fail_op: Stencil_Op,
    pass_op: Stencil_Op,
}

StencilState :: struct {
    enabled: bool,
    front: StencilFaceState,
    back: StencilFaceState,
    read_mask: u8,
    write_mask: u8,
    ref: u8,
}

DepthState :: struct {
    pixel_format: Pixel_Format,
    compare: Compare_Func,
    write_enabled: bool,
    bias: f32,
    bias_slope_scale: f32,
    bias_clamp: f32,
}

BlendState :: struct {
    enabled: bool,
    src_factor_rgb: Blend_Factor,
    dst_factor_rgb: Blend_Factor,
    op_rgb: Blend_Op,
    src_factor_alpha: Blend_Factor,
    dst_factor_alpha: Blend_Factor,
    op_alpha: Blend_Op,
}

ColorState :: struct {
    pixel_format: Pixel_Format,
    write_mask: Color_Mask,
    blend: BlendState,
}

PipelineDesc :: struct {
    _start_canary: u32,
    shader: Shader,
    layout: LayoutDesc,
    depth: DepthState,
    stencil: StencilState,
    color_count: c.int,
    colors: [4]ColorState,
    primitive_type: Primitive_Type,
    index_type: Index_Type,
    cull_mode: Cull_Mode,
    face_winding: Face_Winding,
    sample_count: c.int,
    blend_color: Color,
    alpha_to_coverage_enabled: bool,
    label: cstring,
    _end_canary: u32,
}

PassAttachmentDesc :: struct {
    image: Image,
    mip_level: c.int,
    slice: c.int,
}

PassDesc :: struct {
    _start_canary: u32,
    color_attachments: [4]PassAttachmentDesc,
    depth_stencil_attachment: PassAttachmentDesc,
    label: cstring,
    _end_canary: u32,
}

SlotInfo :: struct {
    state: Resource_State,
    res_id: u32,
    ctx_id: u32,
}

BufferInfo :: struct {
    slot: SlotInfo,
    update_frame_index: u32,
    append_frame_index: u32,
    append_pos: c.int,
    append_overflow: bool,
    num_slots: c.int,
    active_slot: c.int,
}

ImageInfo :: struct {
    slot: SlotInfo,
    upd_frame_index: u32,
    num_slots: c.int,
    active_slot: c.int,
    width: c.int,
    height: c.int,
}

ShaderInfo :: struct {
    slot: SlotInfo,
}

PipelineInfo :: struct {
    slot: SlotInfo,
}

PassInfo :: struct {
    slot: SlotInfo,
}

GlContextDesc :: struct {
    force_gles2: bool,
}

MetalContextDesc :: struct {
    device: rawptr,
    renderpass_descriptor_cb: proc "c" () -> rawptr,
    renderpass_descriptor_userdata_cb: proc "c" () -> rawptr,
    drawable_cb: proc "c" () -> rawptr,
    drawable_userdata_cb: proc "c" () -> rawptr,
    user_data: rawptr,
}

D3d11ContextDesc :: struct {
    device: rawptr,
    device_context: rawptr,
    render_target_view_cb: proc "c" () -> rawptr,
    render_target_view_userdata_cb: proc "c" () -> rawptr,
    depth_stencil_view_cb: proc "c" () -> rawptr,
    depth_stencil_view_userdata_cb: proc "c" () -> rawptr,
    user_data: rawptr,
}

WgpuContextDesc :: struct {
    device: rawptr,
    render_view_cb: proc "c" () -> rawptr,
    render_view_userdata_cb: proc "c" () -> rawptr,
    resolve_view_cb: proc "c" () -> rawptr,
    resolve_view_userdata_cb: proc "c" () -> rawptr,
    depth_stencil_view_cb: proc "c" () -> rawptr,
    depth_stencil_view_userdata_cb: proc "c" () -> rawptr,
    user_data: rawptr,
}

ContextDesc :: struct {
    color_format: c.int,
    depth_format: c.int,
    sample_count: c.int,
    gl: GlContextDesc,
    metal: MetalContextDesc,
    d3d11: D3d11ContextDesc,
    wgpu: WgpuContextDesc,
}

Desc :: struct {
    _start_canary: u32,
    buffer_pool_size: c.int,
    image_pool_size: c.int,
    shader_pool_size: c.int,
    pipeline_pool_size: c.int,
    pass_pool_size: c.int,
    context_pool_size: c.int,
    uniform_buffer_size: c.int,
    staging_buffer_size: c.int,
    sampler_cache_size: c.int,
    ctx: ContextDesc,
    _end_canary: u32,
}

// Procedures

@(default_calling_convention="c")
@(link_prefix="sg_")
foreign sg_lib {
    setup :: proc(desc: Desc) ---
    shutdown :: proc() ---
    isvalid :: proc() -> bool ---
    reset_state_cache :: proc() ---
    push_debug_group :: proc(name: cstring) ---
    pop_debug_group :: proc() ---
    make_buffer :: proc(desc: BufferDesc) -> Buffer ---
    make_image :: proc(desc: ImageDesc) -> Image ---
    make_shader :: proc(desc: ShaderDesc) -> Shader ---
    make_pipeline :: proc(desc: PipelineDesc) -> Pipeline ---
    make_pass :: proc(desc: PassDesc) -> Pass ---
    destroy_buffer :: proc(buf: Buffer) ---
    destroy_image :: proc(img: Image) ---
    destroy_shader :: proc(shd: Shader) ---
    destroy_pipeline :: proc(pip: Pipeline) ---
    destroy_pass :: proc(pass: Pass) ---
    update_buffer :: proc(buf: Buffer, data: Range) ---
    update_image :: proc(img: Image, data: ImageData) ---
    append_buffer :: proc(buf: Buffer, data: Range) -> c.int ---
    query_buffer_overflow :: proc(buf: Buffer) -> bool ---
    begin_default_pass :: proc(pass_action: PassAction, width: c.int, height: c.int) ---
    begin_default_passf :: proc(pass_action: PassAction, width: f32, height: f32) ---
    begin_pass :: proc(pass: Pass, pass_action: PassAction) ---
    apply_viewport :: proc(x: c.int, y: c.int, width: c.int, height: c.int, origin_top_left: bool) ---
    apply_viewportf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool) ---
    apply_scissor_rect :: proc(x: c.int, y: c.int, width: c.int, height: c.int, origin_top_left: bool) ---
    apply_scissor_rectf :: proc(x: f32, y: f32, width: f32, height: f32, origin_top_left: bool) ---
    apply_pipeline :: proc(pip: Pipeline) ---
    apply_bindings :: proc(bindings: Bindings) ---
    apply_uniforms :: proc(stage: Shader_Stage, ub_index: u32, data: Range) ---
    draw :: proc(base_element: u32, num_elements: u32, num_instances: u32) ---
    end_pass :: proc() ---
    commit :: proc() ---
    query_desc :: proc() -> Desc ---
    query_backend :: proc() -> Backend ---
    query_features :: proc() -> Features ---
    query_limits :: proc() -> Limits ---
    query_pixelformat :: proc(fmt: Pixel_Format) -> PixelformatInfo ---
    query_buffer_state :: proc(buf: Buffer) -> Resource_State ---
    query_image_state :: proc(img: Image) -> Resource_State ---
    query_shader_state :: proc(shd: Shader) -> Resource_State ---
    query_pipeline_state :: proc(pip: Pipeline) -> Resource_State ---
    query_pass_state :: proc(pass: Pass) -> Resource_State ---
    query_buffer_info :: proc(buf: Buffer) -> BufferInfo ---
    query_image_info :: proc(img: Image) -> ImageInfo ---
    query_shader_info :: proc(shd: Shader) -> ShaderInfo ---
    query_pipeline_info :: proc(pip: Pipeline) -> PipelineInfo ---
    query_pass_info :: proc(pass: Pass) -> PassInfo ---
    query_buffer_defaults :: proc(desc: BufferDesc) -> BufferDesc ---
    query_image_defaults :: proc(desc: ImageDesc) -> ImageDesc ---
    query_shader_defaults :: proc(desc: ShaderDesc) -> ShaderDesc ---
    query_pipeline_defaults :: proc(desc: PipelineDesc) -> PipelineDesc ---
    query_pass_defaults :: proc(desc: PassDesc) -> PassDesc ---
    alloc_buffer :: proc() -> Buffer ---
    alloc_image :: proc() -> Image ---
    alloc_shader :: proc() -> Shader ---
    alloc_pipeline :: proc() -> Pipeline ---
    alloc_pass :: proc() -> Pass ---
    dealloc_buffer :: proc(buf_id: Buffer) ---
    dealloc_image :: proc(img_id: Image) ---
    dealloc_shader :: proc(shd_id: Shader) ---
    dealloc_pipeline :: proc(pip_id: Pipeline) ---
    dealloc_pass :: proc(pass_id: Pass) ---
    init_buffer :: proc(buf_id: Buffer, desc: BufferDesc) ---
    init_image :: proc(img_id: Image, desc: ImageDesc) ---
    init_shader :: proc(shd_id: Shader, desc: ShaderDesc) ---
    init_pipeline :: proc(pip_id: Pipeline, desc: PipelineDesc) ---
    init_pass :: proc(pass_id: Pass, desc: PassDesc) ---
    uninit_buffer :: proc(buf_id: Buffer) -> bool ---
    uninit_image :: proc(img_id: Image) -> bool ---
    uninit_shader :: proc(shd_id: Shader) -> bool ---
    uninit_pipeline :: proc(pip_id: Pipeline) -> bool ---
    uninit_pass :: proc(pass_id: Pass) -> bool ---
    fail_buffer :: proc(buf_id: Buffer) ---
    fail_image :: proc(img_id: Image) ---
    fail_shader :: proc(shd_id: Shader) ---
    fail_pipeline :: proc(pip_id: Pipeline) ---
    fail_pass :: proc(pass_id: Pass) ---
    setup_context :: proc() -> Context ---
    activate_context :: proc(ctx_id: Context) ---
    discard_context :: proc(ctx_id: Context) ---
    d3d11_device :: proc() -> rawptr ---
    mtl_device :: proc() -> rawptr ---
    mtl_render_command_encoder :: proc() -> rawptr ---
}
