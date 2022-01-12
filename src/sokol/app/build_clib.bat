@echo off
setlocal

cl /DDEBUG /c /Zi /Fo../lib/sokol_appd.obj /Fd../lib/sokol_appd.pdb ../c/sokol_app.c
lib /out:../lib/sokol_appd.lib ../lib/sokol_appd.obj

cl /DNDEBUG /O2 /c /Fo../lib/sokol_app.obj ../c/sokol_app.c
lib /out:../lib/sokol_app.lib ../lib/sokol_app.obj

del "../lib/*.obj" 
