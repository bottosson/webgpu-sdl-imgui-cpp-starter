project "Main"
      kind "ConsoleApp"
      language "C++"
      cppdialect "C++17"
      flags { 
         "MultiProcessorCompile"
      }

      io.writefile("../../local/gen/main/shaderPaths.h",[[
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
         "", 
         "%{wks.location}/gen/main",
      }

      externalincludedirs {
         "",  
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
         "**.h", 
         "**.cpp" 
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