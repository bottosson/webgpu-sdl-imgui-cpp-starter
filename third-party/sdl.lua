project "SDL"
kind "StaticLib"
language "C++"
cppdialect "C++17"
flags { 
   "MultiProcessorCompile"
}

targetdir (target_dir .. "/%{prj.name}")
objdir (obj_dir .. "/%{prj.name}")
location (build_dir .. "/%{prj.name}")

externalincludedirs {
   "sdl/include", 
   "sdl/src/",
}

files { 
"sdl/include/**.h",
"sdl/src/*.h", 
"sdl/src/*.c",
"sdl/src/*/*.h", 
"sdl/src/*/*.c",
"sdl/src/audio/disk/*.h",  
"sdl/src/audio/disk/*.c", 
"sdl/src/audio/dummy/*.h",
"sdl/src/audio/dummy/*.c",
"sdl/src/joystick/hidapi/*.h", 
"sdl/src/joystick/hidapi/*.c",
"sdl/src/joystick/virtual/*.h", 
"sdl/src/joystick/virtual/*.c",
"sdl/src/video/dummy/*.h",
"sdl/src/video/dummy/*.c",
"sdl/src/video/yuv2rgb/*.h", 
"sdl/src/video/yuv2rgb/*.c",
}

filter "system:macosx"
   buildoptions ( "-fobjc-arc" )
   systemversion "11.0"
   files {
      "sdl/src/audio/coreaudio/*.h",  
      "sdl/src/audio/coreaudio/*.m",  
      "sdl/src/*/unix/*.h",
      "sdl/src/*/unix/*.c",
      "sdl/src/*/mac/*.h",
      "sdl/src/*/mac/*.c",
      "sdl/src/*/mac/*.m",
      "sdl/src/*/macosx/*.h",
      "sdl/src/*/macosx/*.c",
      "sdl/src/*/macosx/*.m",
      "sdl/src/*/metal/*.h",
      "sdl/src/*/metal/*.c",
      "sdl/src/*/metal/*.m",
      "sdl/src/*/cocoa/*.h",
      "sdl/src/*/cocoa/*.c",
      "sdl/src/*/cocoa/*.m",
      "sdl/src/*/darwin/*.h",
      "sdl/src/*/darwin/*.c",
      "sdl/src/*/darwin/*.m",
      "sdl/src/thread/pthread/*.h", 
      "sdl/src/thread/pthread/*.c",
      "sdl/src/loadso/dlopen/*.h",
      "sdl/src/loadso/dlopen/*.c",
      "sdl/src/joystick/iphoneos/*.h", 
      "sdl/src/joystick/iphoneos/*.c",
      "sdl/src/joystick/iphoneos/*.m",
   }
   defines {       
      "SDL_VIDEO_RENDER_OGL=0",  
      "SDL_VIDEO_RENDER_OGL_ES2=0",  
      "SDL_VIDEO_RENDER_SW=0", 
      "SDL_VIDEO_OPENGL_EGL=0",
   }

filter "system:windows"
   links { 
      "d3d12", 
      "dxgi", 
      "d3dcompiler",
      "winmm",
      "setupapi",
      "imm32",
      "version",
   }
   files {
   "sdl/src/audio/directsound/*.h",  
   "sdl/src/audio/directsound/*.c",   
   "sdl/src/audio/wasapi/*.h",  
   "sdl/src/audio/wasapi/*.c",  
   "sdl/src/audio/winmm/*.h",  
   "sdl/src/audio/winmm/*.c",  
   "sdl/src/*/windows/*.h",
   "sdl/src/*/windows/*.c",
   "sdl/src/*/direct3d/*.h",
   "sdl/src/*/direct3d/*.c", 
   "sdl/src/*/direct3d11/*.h",
   "sdl/src/*/direct3d11/*.c",  
   "sdl/src/*/direct3d12/*.h",
   "sdl/src/*/direct3d12/*.c",  
   "sdl/src/thread/generic/SDL_syscond_c.h", 
   "sdl/src/thread/generic/SDL_syscond.c",
   }
   removefiles { 
   "sdl/src/hidapi/windows/hid.c", 
   "sdl/src/main/windows/**", 
   }
   defines {       
      "SDL_VIDEO_RENDER_OGL=0",  
      "SDL_VIDEO_RENDER_OGL_ES2=0",  
      "SDL_VIDEO_RENDER_SW=0", 
   }

filter "configurations:Debug"
   defines { "DEBUG" }
   symbols "On"

filter "configurations:Release"
   defines { "NDEBUG" }
   optimize "On"

project "SDL_main"
kind "StaticLib"
language "C++"
cppdialect "C++17"
flags { 
   "MultiProcessorCompile"
}

targetdir (target_dir .. "/%{prj.name}")
objdir (obj_dir .. "/%{prj.name}")
location (build_dir .. "/%{prj.name}")

includedirs {
   "sdl/include", 
}
externalincludedirs {
   "sdl/include", 
}
links {
   "SDL"
}
files {
   "sdl/src/main/windows/**" 
}

filter "system:macosx"
   systemversion "11.0"

filter "configurations:Debug"
   defines { "DEBUG" }
   symbols "On"

filter "configurations:Release"
   defines { "NDEBUG" }
   optimize "On"