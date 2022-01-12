@echo off
setlocal

cl /DDEBUG /c /Zi /Fo../lib/sokol_gfxd.obj /Fd../lib/sokol_gfxd.pdb ../c/sokol_app.c
lib /out:../lib/sokol_gfxd.lib ../lib/sokol_gfxd.obj

cl /DNDEBUG /O2 /c /Fo../lib/sokol_gfx.obj ../c/sokol_app.c
lib /out:../lib/sokol_gfx.lib ../lib/sokol_gfx.obj

del "../lib/*.obj" 
