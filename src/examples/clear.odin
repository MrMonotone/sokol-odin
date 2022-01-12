package main

import "../sokol/gfx"
import "../sokol/app"
import "../sokol"
import "core:os"
import "core:runtime"

pass_action : gfx.PassAction

init_callback :: proc "c" () {
    context = runtime.default_context()
    gfx.setup(gfx.Desc {
        ctx = sokol.make_gfx_context(),
    })
    pass_action.colors[0] = {action = .CLEAR, value = {1.0, 0.0, 0.0, 1.0}}
}

frame_callback :: proc "c" () {
    context = runtime.default_context()
    g := pass_action.colors[0].value.g + 0.01;
    if g > 1.0 do pass_action.colors[0].value.g = 0.0 else do pass_action.colors[0].value.g = g
    gfx.begin_default_pass(pass_action, app.width(), app.height());
    gfx.end_pass()
    gfx.commit()
}

main :: proc() {
	err := app.run({
		init_cb      = init_callback,
		frame_cb     = frame_callback,
		cleanup_cb   = proc "c" () { gfx.shutdown(); },
		width        = 400,
		height       = 300,
		window_title = "Clear (sokol app)",
	})
	os.exit(int(err))
}