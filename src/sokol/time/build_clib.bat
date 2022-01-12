@echo off
setlocal

cl /DNDEBUG /O2 /c /Fo../lib/sokol_time.obj ../c/sokol_time.c
lib /out:../lib/sokol_time.lib ../lib/sokol_time.obj

del "../lib/*.obj" 
