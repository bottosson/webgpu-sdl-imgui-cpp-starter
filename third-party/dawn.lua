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
         "dawn/",
         "dawn/src/",
         "dawn/include", 
         "dawn/out/Debug/gen/src",
         "dawn/out/Debug/gen/include",
      }

      externalincludedirs {
         "dawn/",
         "dawn/src/",
         "dawn/include", 
         "dawn/out/Debug/gen/src",
         "dawn/out/Debug/gen/include",
         "dawn/third_party/abseil-cpp", 
         "dawn/out/Debug/gen/third_party/vulkan-deps/spirv-tools/src",
         "dawn/third_party/vulkan-deps/spirv-tools/src",
         "dawn/third_party/vulkan-deps/spirv-tools/src/include",
         "dawn/third_party/vulkan-deps/spirv-headers/src/include",

      }
      files { 
         "dawn/include/**.h", 
         "dawn/out/Debug/gen/include/**.h",
         "dawn/src/**.h", 
         "dawn/src/**.cpp", 
         "dawn/src/**.cc", 
         "dawn/out/Debug/gen/src/**.h",
         "dawn/out/Debug/gen/src/**.cpp",
         "dawn/third_party/vulkan-deps/spirv-tools/src/source/**.h",
         "dawn/third_party/vulkan-deps/spirv-tools/src/source/**.cpp",
         "dawn/third_party/abseil-cpp/absl/base/**.h",
         "dawn/third_party/abseil-cpp/absl/base/**.cc",
         "dawn/third_party/abseil-cpp/absl/strings/**.h",
         "dawn/third_party/abseil-cpp/absl/strings/**.cc",
         "dawn/third_party/abseil-cpp/absl/numeric/**.h",
         "dawn/third_party/abseil-cpp/absl/numeric/**.cc",
      }
      removefiles { 
         "dawn/src/dawn/common/WindowsUtils.cpp", 
         "dawn/src/dawn/common/WindowsUtils.h", 
         "dawn/src/dawn/common/xlib_with_undefs.h", 
         "dawn/src/dawn/fuzzers/**",       
         "dawn/src/dawn/tests/**", 
         "dawn/src/dawn/native/*/**",
         "dawn/src/dawn/native/X11Functions.h",
         "dawn/src/dawn/native/X11Functions.cpp",
         "dawn/src/dawn/native/SpirvValidation.h",
         "dawn/src/dawn/native/SpirvValidation.cpp",
         "dawn/src/dawn/glfw/**", 
         "dawn/src/dawn/node/**", 
         "dawn/src/dawn/node/**", 
         "dawn/src/dawn/samples/**",
         "dawn/src/dawn/**_mock.h",
         "dawn/src/dawn/**_mock.cpp",
         "dawn/src/dawn/utils/**.cpp",
         "dawn/src/tint/**_test.h", 
         "dawn/src/tint/**_test.cc", 
         "dawn/src/tint/**_test_helper.h", 
         "dawn/src/tint/**_test_helper.cc", 
         "dawn/src/tint/bench/**",
         "dawn/src/tint/cmd/**",
         "dawn/src/tint/**_bench.h", 
         "dawn/src/tint/**_bench.cc", 
         "dawn/src/tint/fuzzers/**",
         "dawn/src/tint/**_posix.cc",
         "dawn/src/tint/**_windows.cc",
         "dawn/src/tint/**_linux.cc",
         "dawn/src/tint/**_other.cc",
         "dawn/src/tint/inspector/test_inspector_*",
         "dawn/src/tint/resolver/resolver_test_helper.h",
         "dawn/src/tint/resolver/resolver_test_helper.cc",
         "dawn/src/tint/test_main.cc",
         "dawn/src/tint/lang/wgsl/writer/options.cc",
         "dawn/out/Debug/gen/src/dawn/native/*/**",
         "dawn/out/Debug/gen/src/dawn/mock_webgpu.h",
         "dawn/out/Debug/gen/src/dawn/mock_webgpu.cpp",
         "dawn/third_party/vulkan-deps/spirv-tools/src/source/wasm/**",
         "dawn/third_party/vulkan-deps/spirv-tools/src/source/fuzz/**",
         "dawn/third_party/abseil-cpp/absl/**_benchmark.cc",
         "dawn/third_party/abseil-cpp/absl/**_testing.cc",
         "dawn/third_party/abseil-cpp/absl/**_test.cc",
         "dawn/third_party/abseil-cpp/absl/**_test_common.cc",
         "dawn/third_party/abseil-cpp/absl/**_test_helpers.h",
      }
      files { 
         "dawn/src/dawn/native/null/**.h",
         "dawn/src/dawn/native/null/**.cpp",
         "dawn/src/dawn/native/stream/**.h",
         "dawn/src/dawn/native/stream/**.cpp",
         "dawn/src/dawn/native/utils/**.h",
         "dawn/src/dawn/native/utils/**.cpp",
         "dawn/src/dawn/utils/ComboRenderBundleEncoderDescriptor.cpp",
         "dawn/src/dawn/utils/ComboRenderBundleEncoderDescriptor.h",
         "dawn/src/dawn/utils/ComboRenderPipelineDescriptor.cpp",
         "dawn/src/dawn/utils/ComboRenderPipelineDescriptor.h",
         "dawn/src/dawn/utils/PlatformDebugLogger.h",
         "dawn/src/dawn/utils/ScopedAutoreleasePool.h",
         "dawn/src/dawn/utils/SystemUtils.cpp",
         "dawn/src/dawn/utils/SystemUtils.h",
         "dawn/src/dawn/utils/TerribleCommandBuffer.cpp",
         "dawn/src/dawn/utils/TerribleCommandBuffer.h",
         "dawn/src/dawn/utils/TestUtils.cpp",
         "dawn/src/dawn/utils/TestUtils.h",
         "dawn/src/dawn/utils/TextureUtils.cpp",
         "dawn/src/dawn/utils/TextureUtils.h",
         "dawn/src/dawn/utils/Timer.h",
         "dawn/src/dawn/utils/WGPUHelpers.cpp",
         "dawn/src/dawn/utils/WGPUHelpers.h",
         "dawn/src/dawn/utils/WireHelper.cpp",
         "dawn/src/dawn/utils/WireHelper.h",
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
            "dawn/src/dawn/common/**.mm",
            "dawn/src/dawn/native/metal/**.h",
            "dawn/src/dawn/native/metal/**.cpp",
            "dawn/src/dawn/native/**.mm",
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
            "dawn/src/tint/**_windows.cc",
            "dawn/src/dawn/common/WindowsUtils.cpp", 
            "dawn/src/dawn/common/WindowsUtils.h", 
            "dawn/src/dawn/native/d3d12/**.h",
            "dawn/src/dawn/native/d3d12/**.cpp",
            "dawn/src/dawn/native/d3d/**.h",
            "dawn/src/dawn/native/d3d/**.cpp",
            "dawn/src/dawn/utils/WindowsDebugLogger.cpp",
            "dawn/src/dawn/utils/WindowsTimer.cpp",
         }
         defines {       
            "NOMINMAX", 
            "DAWN_ENABLE_BACKEND_D3D12",
            "TINT_BUILD_HLSL_WRITER", 
         }