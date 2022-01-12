// machine generated, do not edit

package time

when ODIN_OS == "windows" do foreign import stm_lib "../lib/sokol_time.lib"
else when ODIN_OS == "darwin" do foreign import stm_lib "../lib/sokol_time.a"

import "core:c"


// Constants
// Bit Sets


// Enums

// Structs

// Procedures

@(default_calling_convention="c")
@(link_prefix="stm_")
foreign stm_lib {
    setup :: proc() ---
    now :: proc() -> u64 ---
    diff :: proc(new_ticks: u64, old_ticks: u64) -> u64 ---
    since :: proc(start_ticks: u64) -> u64 ---
    laptime :: proc(last_time: ^u64) -> u64 ---
    round_to_common_refresh_rate :: proc(frame_ticks: u64) -> u64 ---
    sec :: proc(ticks: u64) -> f64 ---
    ms :: proc(ticks: u64) -> f64 ---
    us :: proc(ticks: u64) -> f64 ---
    ns :: proc(ticks: u64) -> f64 ---
}
