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

sdl_include_dir = "%{wks.location}/../third-party/sdl/include" 
dawn_include_dir = "%{wks.location}/../third-party/dawn/include" 
dawn_gen_include_dir = "%{wks.location}/../third-party/dawn/out/Debug/gen/include" 
imgui_include_dir = "%{wks.location}/../third-party/imgui" 

group "third-party"
   include "third-party/sdl.lua"
   include "third-party/dawn.lua"
   include "third-party/imgui.lua"

group ""

   include "src/main"