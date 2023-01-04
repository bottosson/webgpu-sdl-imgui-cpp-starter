workspace "webgpu-sdl-imgui-cpp-starter-%{_ACTION}"
   configurations { "Debug", "Release" }
   architecture "x86_64"
   startproject "Main"

   location ("local")

   filter "system:macosx"
      systemversion "11.0"


target_dir = "%{wks.location}/bin/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}-%{_ACTION}"
obj_dir = "%{wks.location}/obj/%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}-%{_ACTION}"
build_dir = "%{wks.location}/build/%{_ACTION}"

sdl_include_dir = "third-party/sdl/include" 
dawn_include_dir = "third-party/dawn/include" 
dawn_gen_include_dir = "third-party/dawn/out/Debug/gen/include" 
imgui_include_dir = "third-party/imgui" 


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
      "third-party/sdl/include", 
      "third-party/sdl/src/",
   }

   files { 
    "third-party/sdl/include/**.h",
    "third-party/sdl/src/*.h", 
    "third-party/sdl/src/*.c",
    "third-party/sdl/src/*/*.h", 
    "third-party/sdl/src/*/*.c",
    "third-party/sdl/src/audio/disk/*.h",  
    "third-party/sdl/src/audio/disk/*.c", 
    "third-party/sdl/src/*/dummy/*.h",
    "third-party/sdl/src/*/dummy/*.c",
    "third-party/sdl/src/joystick/hidapi/*.h", 
    "third-party/sdl/src/joystick/hidapi/*.c",
    "third-party/sdl/src/joystick/virtual/*.h", 
    "third-party/sdl/src/joystick/virtual/*.c",
    "third-party/sdl/src/video/yuv2rgb/*.h", 
    "third-party/sdl/src/video/yuv2rgb/*.c",
   }

   filter "system:macosx"
      buildoptions ( "-fobjc-arc" )
      systemversion "11.0"
      files {
         "third-party/sdl/src/audio/coreaudio/*.h",  
         "third-party/sdl/src/audio/coreaudio/*.m",  
         "third-party/sdl/src/*/unix/*.h",
         "third-party/sdl/src/*/unix/*.c",
         "third-party/sdl/src/*/mac/*.h",
         "third-party/sdl/src/*/mac/*.c",
         "third-party/sdl/src/*/mac/*.m",
         "third-party/sdl/src/*/macosx/*.h",
         "third-party/sdl/src/*/macosx/*.c",
         "third-party/sdl/src/*/macosx/*.m",
         "third-party/sdl/src/*/metal/*.h",
         "third-party/sdl/src/*/metal/*.c",
         "third-party/sdl/src/*/metal/*.m",
         "third-party/sdl/src/*/cocoa/*.h",
         "third-party/sdl/src/*/cocoa/*.c",
         "third-party/sdl/src/*/cocoa/*.m",
         "third-party/sdl/src/*/darwin/*.h",
         "third-party/sdl/src/*/darwin/*.c",
         "third-party/sdl/src/*/darwin/*.m",
         "third-party/sdl/src/thread/pthread/*.h", 
         "third-party/sdl/src/thread/pthread/*.c",
         "third-party/sdl/src/loadso/dlopen/*.h",
         "third-party/sdl/src/loadso/dlopen/*.c",
         "third-party/sdl/src/joystick/iphoneos/*.h", 
         "third-party/sdl/src/joystick/iphoneos/*.c",
         "third-party/sdl/src/joystick/iphoneos/*.m",
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
        "third-party/sdl/src/audio/directsound/*.h",  
        "third-party/sdl/src/audio/directsound/*.c",   
        "third-party/sdl/src/audio/wasapi/*.h",  
        "third-party/sdl/src/audio/wasapi/*.c",  
        "third-party/sdl/src/audio/winmm/*.h",  
        "third-party/sdl/src/audio/winmm/*.c",  
        "third-party/sdl/src/*/windows/*.h",
        "third-party/sdl/src/*/windows/*.c",
        "third-party/sdl/src/*/direct3d/*.h",
        "third-party/sdl/src/*/direct3d/*.c", 
        "third-party/sdl/src/*/direct3d11/*.h",
        "third-party/sdl/src/*/direct3d11/*.c",  
        "third-party/sdl/src/*/direct3d12/*.h",
        "third-party/sdl/src/*/direct3d12/*.c",  
        "third-party/sdl/src/thread/generic/SDL_syscond_c.h", 
        "third-party/sdl/src/thread/generic/SDL_syscond.c",
      }
      removefiles { 
        "third-party/sdl/src/hidapi/windows/hid.c", 
        "third-party/sdl/src/main/windows/**", 
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
      "third-party/sdl/include", 
   }
   externalincludedirs {
      "third-party/sdl/include", 
   }
   links {
      "SDL"
   }
   files {
      "third-party/sdl/src/main/windows/**" 
   }

   filter "system:macosx"
      systemversion "11.0"

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"

project "Dawn"
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
      "third-party/dawn/",
      "third-party/dawn/src/",
      "third-party/dawn/include", 
      "third-party/dawn/out/Debug/gen/src",
      "third-party/dawn/out/Debug/gen/include",
   }

   externalincludedirs {
      "third-party/dawn/",
      "third-party/dawn/src/",
      "third-party/dawn/include", 
      "third-party/dawn/out/Debug/gen/src",
      "third-party/dawn/out/Debug/gen/include",
      "third-party/dawn/third_party/abseil-cpp", 
      "third-party/dawn/out/Debug/gen/third_party/vulkan-deps/spirv-tools/src",
      "third-party/dawn/third_party/vulkan-deps/spirv-tools/src",
      "third-party/dawn/third_party/vulkan-deps/spirv-tools/src/include",
      "third-party/dawn/third_party/vulkan-deps/spirv-headers/src/include",

   }
   files { 
      "third-party/dawn/include/**.h", 
      "third-party/dawn/out/Debug/gen/include/**.h",
      "third-party/dawn/src/**.h", 
      "third-party/dawn/src/**.cpp", 
      "third-party/dawn/src/**.cc", 
      "third-party/dawn/out/Debug/gen/src/**.h",
      "third-party/dawn/out/Debug/gen/src/**.cpp",
      "third-party/dawn/third_party/vulkan-deps/spirv-tools/src/source/**.h",
      "third-party/dawn/third_party/vulkan-deps/spirv-tools/src/source/**.cpp",
      "third-party/dawn/third_party/abseil-cpp/absl/base/**.h",
      "third-party/dawn/third_party/abseil-cpp/absl/base/**.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/strings/**.h",
      "third-party/dawn/third_party/abseil-cpp/absl/strings/**.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/numeric/**.h",
      "third-party/dawn/third_party/abseil-cpp/absl/numeric/**.cc",
   }
   removefiles { 
      "third-party/dawn/src/dawn/common/WindowsUtils.cpp", 
      "third-party/dawn/src/dawn/common/WindowsUtils.h", 
      "third-party/dawn/src/dawn/fuzzers/**",       
      "third-party/dawn/src/dawn/tests/**", 
      "third-party/dawn/src/dawn/native/*/**",
      "third-party/dawn/src/dawn/native/XlibXcbFunctions.h",
      "third-party/dawn/src/dawn/native/XlibXcbFunctions.cpp",
      "third-party/dawn/src/dawn/native/SpirvValidation.h",
      "third-party/dawn/src/dawn/native/SpirvValidation.cpp",
      "third-party/dawn/src/dawn/node/**", 
      "third-party/dawn/src/dawn/node/**", 
      "third-party/dawn/src/dawn/samples/**", 
      "third-party/dawn/src/dawn/**_mock.h",
      "third-party/dawn/src/dawn/**_mock.cpp",
      "third-party/dawn/src/dawn/utils/**.cpp",
      "third-party/dawn/src/tint/**_test.h", 
      "third-party/dawn/src/tint/**_test.cc", 
      "third-party/dawn/src/tint/**_test_helper.h", 
      "third-party/dawn/src/tint/**_test_helper.cc", 
      "third-party/dawn/src/tint/bench/**",
      "third-party/dawn/src/tint/cmd/**",
      "third-party/dawn/src/tint/**_bench.h", 
      "third-party/dawn/src/tint/**_bench.cc", 
      "third-party/dawn/src/tint/fuzzers/**",
      "third-party/dawn/src/tint/**_posix.cc",
      "third-party/dawn/src/tint/**_windows.cc",
      "third-party/dawn/src/tint/**_linux.cc",
      "third-party/dawn/src/tint/**_other.cc",
      "third-party/dawn/src/tint/inspector/test_inspector_*",
      "third-party/dawn/src/tint/resolver/resolver_test_helper.h",
      "third-party/dawn/src/tint/resolver/resolver_test_helper.cc",
      "third-party/dawn/src/tint/test_main.cc",
      "third-party/dawn/out/Debug/gen/src/dawn/native/*/**",
      "third-party/dawn/out/Debug/gen/src/dawn/mock_webgpu.h",
      "third-party/dawn/out/Debug/gen/src/dawn/mock_webgpu.cpp",
      "third-party/dawn/third_party/vulkan-deps/spirv-tools/src/source/wasm/**",
      "third-party/dawn/third_party/abseil-cpp/absl/**_benchmark.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/**_testing.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/**_test.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/**_test_common.cc",
      "third-party/dawn/third_party/abseil-cpp/absl/**_test_helpers.h",
   }
   files { 
      "third-party/dawn/src/dawn/native/null/**.h",
      "third-party/dawn/src/dawn/native/null/**.cpp",
      "third-party/dawn/src/dawn/native/stream/**.h",
      "third-party/dawn/src/dawn/native/stream/**.cpp",
      "third-party/dawn/src/dawn/native/utils/**.h",
      "third-party/dawn/src/dawn/native/utils/**.cpp",
      "third-party/dawn/src/dawn/utils/ComboRenderBundleEncoderDescriptor.cpp",
      "third-party/dawn/src/dawn/utils/ComboRenderBundleEncoderDescriptor.h",
      "third-party/dawn/src/dawn/utils/ComboRenderPipelineDescriptor.cpp",
      "third-party/dawn/src/dawn/utils/ComboRenderPipelineDescriptor.h",
      "third-party/dawn/src/dawn/utils/PlatformDebugLogger.h",
      "third-party/dawn/src/dawn/utils/ScopedAutoreleasePool.h",
      "third-party/dawn/src/dawn/utils/SystemUtils.cpp",
      "third-party/dawn/src/dawn/utils/SystemUtils.h",
      "third-party/dawn/src/dawn/utils/TerribleCommandBuffer.cpp",
      "third-party/dawn/src/dawn/utils/TerribleCommandBuffer.h",
      "third-party/dawn/src/dawn/utils/TestUtils.cpp",
      "third-party/dawn/src/dawn/utils/TestUtils.h",
      "third-party/dawn/src/dawn/utils/TextureUtils.cpp",
      "third-party/dawn/src/dawn/utils/TextureUtils.h",
      "third-party/dawn/src/dawn/utils/Timer.h",
      "third-party/dawn/src/dawn/utils/WGPUHelpers.cpp",
      "third-party/dawn/src/dawn/utils/WGPUHelpers.h",
      "third-party/dawn/src/dawn/utils/WireHelper.cpp",
      "third-party/dawn/src/dawn/utils/WireHelper.h",
   }
   defines {       
      "TINT_BUILD_WGSL_WRITER", 
      "TINT_BUILD_WGSL_READER",
      "TINT_BUILD_SPV_WRITER", 
      "TINT_BUILD_SPV_READER",
   }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"

   filter "system:macosx"
      systemversion "11.0"
      files {
         "third-party/dawn/src/dawn/common/**.mm",
         "third-party/dawn/src/dawn/native/metal/**.h",
         "third-party/dawn/src/dawn/native/metal/**.cpp",
         "third-party/dawn/src/dawn/native/**.mm",
      }
      defines {       
         "DAWN_ENABLE_BACKEND_METAL",
         "TINT_BUILD_MSL_WRITER", 
      }

   filter "system:windows"
      links { 
         "d3d12", 
         "dxgi", 
         "dxguid",
      }
      files {
         "third-party/dawn/src/tint/**_windows.cc",
         "third-party/dawn/src/dawn/common/WindowsUtils.cpp", 
         "third-party/dawn/src/dawn/common/WindowsUtils.h", 
         "third-party/dawn/src/dawn/native/d3d12/**.h",
         "third-party/dawn/src/dawn/native/d3d12/**.cpp",
         "third-party/dawn/src/dawn/utils/WindowsDebugLogger.cpp",
         "third-party/dawn/src/dawn/utils/WindowsTimer.cpp",
         "third-party/dawn/src/tint/diagnostic/printer_windows.cc",
      }
      defines {       
         "NOMINMAX", 
         "DAWN_ENABLE_BACKEND_D3D12",
         "TINT_BUILD_HLSL_WRITER", 
      }

project "ImGui"
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
      "third-party/imgui", 
   }
   
   externalincludedirs {
      "third-party/imgui", 
      dawn_include_dir,
      dawn_gen_include_dir,
      sdl_include_dir,
   }

   files { 
      "third-party/imgui/*.h", 
      "third-party/imgui/*.cpp",
      "third-party/imgui/backends/imgui_impl_wgpu.h", 
      "third-party/imgui/backends/imgui_impl_wgpu.cpp",
      "third-party/imgui/backends/imgui_impl_sdl.h",  
      "third-party/imgui/backends/imgui_impl_sdl.cpp",  
   }

   filter "system:macosx"
      systemversion "11.0"

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"

project "Main"
   kind "ConsoleApp"
   language "C++"
   cppdialect "C++17"
   flags { 
      "MultiProcessorCompile"
   }

   io.writefile("local/gen/main/shaderPaths.h",[[
      #pragma once
      // This file is generated from Premake. Edits will be overwritten
      #include <SDL_platform.h>
      #if defined(__WINDOWS__)
      #define DXC_PATH "../../../../third-party/dxc/bin/x64/dxc.exe"
      #elif defined(__MACOSX__)
      #define DXC_PATH "../../../../third-party/dxc-osx/bin/dxc"
      #endif
      #define SHADER_SOURCE_PATH "../../../../src/shaders"
   ]])
   
   targetdir (target_dir .. "/%{prj.name}")
   debugdir (target_dir .. "/%{prj.name}")
   objdir (obj_dir .. "/%{prj.name}")
   location (build_dir .. "/%{prj.name}")

   includedirs {
      "src/main/", 
      "%{wks.location}/gen/main",
   }

   externalincludedirs {
      "src/main/",  
      "%{wks.location}/gen/main",
      dawn_include_dir,
      dawn_gen_include_dir,
      sdl_include_dir,
      imgui_include_dir,
   }

   links {
      "Dawn",
      "SDL",
      "SDL_main",
      "Imgui",
   }
   
   files { 
      "%{wks.location}/gen/main/**.h",
      "%{wks.location}/gen/main/**.cpp",
      "src/main/**.h", 
      "src/main/**.cpp" 
   }

   filter "system:macosx"
      systemversion "11.0"
      links { 
         "AudioToolbox.framework",
         "Carbon.framework",
         "Cocoa.framework",
         "CoreAudio.framework",
         "CoreFoundation.framework",
         "CoreHaptics.framework",
         "ForceFeedback.framework",
         "GameController.framework",
         "IOKit.framework",
         "IOSurface.framework",
         "Metal.framework",
         "QuartzCore.framework",
      }

   filter "configurations:Debug"
      defines { "DEBUG" }
      symbols "On"

   filter "configurations:Release"
      defines { "NDEBUG" }
      optimize "On"

   