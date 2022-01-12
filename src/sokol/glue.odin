package sokol

import "app"
import "gfx"

make_gfx_context :: proc() -> gfx.ContextDesc {
    return gfx.ContextDesc {
        color_format = app.color_format(),
        depth_format = app.depth_format(),
        sample_count = app.sample_count(),
        gl = {
            force_gles2 = app.gles2(),
        },
        metal = {
            device = app.metal_get_device(),
            renderpass_descriptor_cb = app.metal_get_renderpass_descriptor,
            drawable_cb = app.metal_get_drawable,
        },
        d3d11 = {
            device = app.d3d11_get_device(),
            device_context = app.d3d11_get_device_context(),
            render_target_view_cb = app.d3d11_get_render_target_view,
            depth_stencil_view_cb = app.d3d11_get_depth_stencil_view,
        },
        wgpu = {
            device = app.wgpu_get_device(),
            render_view_cb = app.wgpu_get_render_view,
            resolve_view_cb = app.wgpu_get_resolve_view,
            depth_stencil_view_cb = app.wgpu_get_depth_stencil_view,
        },
    }
}