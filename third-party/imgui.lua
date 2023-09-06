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
         "imgui", 
      }
      
      externalincludedirs {
         "imgui", 
         dawn_include_dir,
         dawn_gen_include_dir,
         sdl_include_dir,
      }

      files { 
         "imgui/*.h", 
         "imgui/*.cpp",
         "imgui/backends/imgui_impl_wgpu.h", 
         "imgui/backends/imgui_impl_wgpu.cpp",
         "imgui/backends/imgui_impl_sdl2.h",  
         "imgui/backends/imgui_impl_sdl2.cpp",  
      }

      filter "system:macosx"
         systemversion "11.0"

      filter "configurations:Debug"
         defines { "DEBUG" }
         symbols "On"

      filter "configurations:Release"
         defines { "NDEBUG" }
         optimize "On"