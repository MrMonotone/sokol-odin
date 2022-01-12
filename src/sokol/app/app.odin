// machine generated, do not edit

package app

when ODIN_OS == "windows" {
    when ODIN_DEBUG == true {
        foreign import sapp_lib "../lib/sokol_appd.lib"
    } else {
        foreign import sapp_lib "../lib/sokol_app.lib"
    }
} else when ODIN_OS == "darwin" {
    foreign import sapp_lib "../lib/sokol_app_metal.a"
}

import "core:c"


// Constants
MAX_TOUCHPOINTS :: 8
MAX_MOUSEBUTTONS :: 3
MAX_KEYCODES :: 512
MAX_ICONIMAGES :: 8

MODIFIER_SHIFT :: 1
MODIFIER_CTRL :: 2
MODIFIER_ALT :: 4
MODIFIER_SUPER :: 8
MODIFIER_LMB :: 256
MODIFIER_RMB :: 512
MODIFIER_MMB :: 1024

// Bit Sets

Modifier :: enum u32 {
    SHIFT = 0,
    CTRL  = 1,
    ALT   = 2,
    SUPER = 3,
    LMB = 8,
    RMB = 9,
    MMB = 10,
}
Modifier_Set :: distinct bit_set[Modifier; u32]

// Enums

Event_Type :: enum i32 {
    INVALID,
    KEY_DOWN,
    KEY_UP,
    CHAR,
    MOUSE_DOWN,
    MOUSE_UP,
    MOUSE_SCROLL,
    MOUSE_MOVE,
    MOUSE_ENTER,
    MOUSE_LEAVE,
    TOUCHES_BEGAN,
    TOUCHES_MOVED,
    TOUCHES_ENDED,
    TOUCHES_CANCELLED,
    RESIZED,
    ICONIFIED,
    RESTORED,
    FOCUSED,
    UNFOCUSED,
    SUSPENDED,
    RESUMED,
    UPDATE_CURSOR,
    QUIT_REQUESTED,
    CLIPBOARD_PASTED,
    FILES_DROPPED,
    _NUM,
}

Key_Code :: enum i32 {
    INVALID = 0,
    SPACE = 32,
    APOSTROPHE = 39,
    COMMA = 44,
    MINUS = 45,
    PERIOD = 46,
    SLASH = 47,
    NUM_0 = 48,
    NUM_1 = 49,
    NUM_2 = 50,
    NUM_3 = 51,
    NUM_4 = 52,
    NUM_5 = 53,
    NUM_6 = 54,
    NUM_7 = 55,
    NUM_8 = 56,
    NUM_9 = 57,
    SEMICOLON = 59,
    EQUAL = 61,
    A = 65,
    B = 66,
    C = 67,
    D = 68,
    E = 69,
    F = 70,
    G = 71,
    H = 72,
    I = 73,
    J = 74,
    K = 75,
    L = 76,
    M = 77,
    N = 78,
    O = 79,
    P = 80,
    Q = 81,
    R = 82,
    S = 83,
    T = 84,
    U = 85,
    V = 86,
    W = 87,
    X = 88,
    Y = 89,
    Z = 90,
    LEFT_BRACKET = 91,
    BACKSLASH = 92,
    RIGHT_BRACKET = 93,
    GRAVE_ACCENT = 96,
    WORLD_1 = 161,
    WORLD_2 = 162,
    ESCAPE = 256,
    ENTER = 257,
    TAB = 258,
    BACKSPACE = 259,
    INSERT = 260,
    DELETE = 261,
    RIGHT = 262,
    LEFT = 263,
    DOWN = 264,
    UP = 265,
    PAGE_UP = 266,
    PAGE_DOWN = 267,
    HOME = 268,
    END = 269,
    CAPS_LOCK = 280,
    SCROLL_LOCK = 281,
    NUM_LOCK = 282,
    PRINT_SCREEN = 283,
    PAUSE = 284,
    F1 = 290,
    F2 = 291,
    F3 = 292,
    F4 = 293,
    F5 = 294,
    F6 = 295,
    F7 = 296,
    F8 = 297,
    F9 = 298,
    F10 = 299,
    F11 = 300,
    F12 = 301,
    F13 = 302,
    F14 = 303,
    F15 = 304,
    F16 = 305,
    F17 = 306,
    F18 = 307,
    F19 = 308,
    F20 = 309,
    F21 = 310,
    F22 = 311,
    F23 = 312,
    F24 = 313,
    F25 = 314,
    KP_0 = 320,
    KP_1 = 321,
    KP_2 = 322,
    KP_3 = 323,
    KP_4 = 324,
    KP_5 = 325,
    KP_6 = 326,
    KP_7 = 327,
    KP_8 = 328,
    KP_9 = 329,
    KP_DECIMAL = 330,
    KP_DIVIDE = 331,
    KP_MULTIPLY = 332,
    KP_SUBTRACT = 333,
    KP_ADD = 334,
    KP_ENTER = 335,
    KP_EQUAL = 336,
    LEFT_SHIFT = 340,
    LEFT_CONTROL = 341,
    LEFT_ALT = 342,
    LEFT_SUPER = 343,
    RIGHT_SHIFT = 344,
    RIGHT_CONTROL = 345,
    RIGHT_ALT = 346,
    RIGHT_SUPER = 347,
    MENU = 348,
}

Mouse_Button :: enum i32 {
    LEFT = 0,
    RIGHT = 1,
    MIDDLE = 2,
    INVALID = 256,
}

Html5_Fetch_Error :: enum i32 {
    FETCH_ERROR_NO_ERROR,
    FETCH_ERROR_BUFFER_TOO_SMALL,
    FETCH_ERROR_OTHER,
}

// Structs

Touchpoint :: struct {
    identifier: uint,
    pos_x: f32,
    pos_y: f32,
    changed: bool,
}

Event :: struct {
    frame_count: u64,
    type: Event_Type,
    key_code: Key_Code,
    char_code: u32,
    key_repeat: bool,
    modifiers: u32,
    mouse_button: Mouse_Button,
    mouse_x: f32,
    mouse_y: f32,
    mouse_dx: f32,
    mouse_dy: f32,
    scroll_x: f32,
    scroll_y: f32,
    num_touches: c.int,
    touches: [MAX_TOUCHPOINTS]Touchpoint,
    window_width: c.int,
    window_height: c.int,
    framebuffer_width: c.int,
    framebuffer_height: c.int,
}

Range :: struct {
    ptr: rawptr,
    size: int,
}

ImageDesc :: struct {
    width: c.int,
    height: c.int,
    pixels: Range,
}

IconDesc :: struct {
    sokol_default: bool,
    images: [8]ImageDesc,
}

Desc :: struct {
    init_cb: proc "c" (),
    frame_cb: proc "c" (),
    cleanup_cb: proc "c" (),
    event_cb: proc "c" (e: ^Event),
    fail_cb: proc "c" (msg: cstring),
    user_data: rawptr,
    init_userdata_cb: proc "c" (user_data: rawptr),
    frame_userdata_cb: proc "c" (user_data: rawptr),
    cleanup_userdata_cb: proc "c" (user_data: rawptr),
    event_userdata_cb: proc "c" (e: ^Event, user_data: rawptr),
    fail_userdata_cb: proc "c" (msg: cstring, user_data: rawptr),
    width: c.int,
    height: c.int,
    sample_count: c.int,
    swap_interval: c.int,
    high_dpi: bool,
    fullscreen: bool,
    alpha: bool,
    window_title: cstring,
    user_cursor: bool,
    enable_clipboard: bool,
    clipboard_size: c.int,
    enable_dragndrop: bool,
    max_dropped_files: c.int,
    max_dropped_file_path_length: c.int,
    icon: IconDesc,
    gl_force_gles2: bool,
    win32_console_utf8: bool,
    win32_console_create: bool,
    win32_console_attach: bool,
    html5_canvas_name: cstring,
    html5_canvas_resize: bool,
    html5_preserve_drawing_buffer: bool,
    html5_premultiplied_alpha: bool,
    html5_ask_leave_site: bool,
    ios_keyboard_resizes_canvas: bool,
}

Html5FetchResponse :: struct {
    succeeded: bool,
    error_code: Html5_Fetch_Error,
    file_index: c.int,
    fetched_size: u32,
    buffer_ptr: rawptr,
    buffer_size: u32,
    user_data: rawptr,
}

Html5FetchRequest :: struct {
    dropped_file_index: c.int,
    callback: proc "c" (),
    buffer_ptr: rawptr,
    buffer_size: u32,
    user_data: rawptr,
}

// Procedures

@(default_calling_convention="c")
@(link_prefix="sapp_")
foreign sapp_lib {
    isvalid :: proc() -> bool ---
    width :: proc() -> c.int ---
    widthf :: proc() -> f32 ---
    height :: proc() -> c.int ---
    heightf :: proc() -> f32 ---
    color_format :: proc() -> c.int ---
    depth_format :: proc() -> c.int ---
    sample_count :: proc() -> c.int ---
    high_dpi :: proc() -> bool ---
    dpi_scale :: proc() -> f32 ---
    show_keyboard :: proc(show: bool) ---
    keyboard_shown :: proc() -> bool ---
    is_fullscreen :: proc() -> bool ---
    toggle_fullscreen :: proc() ---
    show_mouse :: proc(show: bool) ---
    mouse_shown :: proc() -> bool ---
    lock_mouse :: proc(lock: bool) ---
    mouse_locked :: proc() -> bool ---
    userdata :: proc() -> rawptr ---
    query_desc :: proc() -> Desc ---
    request_quit :: proc() ---
    cancel_quit :: proc() ---
    quit :: proc() ---
    consume_event :: proc() ---
    frame_count :: proc() -> u64 ---
    frame_duration :: proc() -> f64 ---
    set_clipboard_string :: proc(str: cstring) ---
    get_clipboard_string :: proc() -> cstring ---
    set_window_title :: proc(str: cstring) ---
    set_icon :: proc(icon_desc: IconDesc) ---
    get_num_dropped_files :: proc() -> c.int ---
    get_dropped_file_path :: proc(index: c.int) -> cstring ---
    run :: proc(desc: Desc) -> c.int ---
    gles2 :: proc() -> bool ---
    html5_ask_leave_site :: proc(ask: bool) ---
    html5_get_dropped_file_size :: proc(index: c.int) -> u32 ---
    html5_fetch_dropped_file :: proc(request: Html5FetchRequest) ---
    metal_get_device :: proc() -> rawptr ---
    metal_get_renderpass_descriptor :: proc() -> rawptr ---
    metal_get_drawable :: proc() -> rawptr ---
    macos_get_window :: proc() -> rawptr ---
    ios_get_window :: proc() -> rawptr ---
    d3d11_get_device :: proc() -> rawptr ---
    d3d11_get_device_context :: proc() -> rawptr ---
    d3d11_get_swap_chain :: proc() -> rawptr ---
    d3d11_get_render_target_view :: proc() -> rawptr ---
    d3d11_get_depth_stencil_view :: proc() -> rawptr ---
    win32_get_hwnd :: proc() -> rawptr ---
    wgpu_get_device :: proc() -> rawptr ---
    wgpu_get_render_view :: proc() -> rawptr ---
    wgpu_get_resolve_view :: proc() -> rawptr ---
    wgpu_get_depth_stencil_view :: proc() -> rawptr ---
    android_get_native_activity :: proc() -> rawptr ---
}
