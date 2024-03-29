This is a quick example of using [Dear ImGui](https://github.com/ocornut/imgui), [SDL](https://www.libsdl.org/) and the [Dawn](hhttps://dawn.googlesource.com/dawn/+/refs/heads/chromium-gpu-experimental/README.md) WebGPU implementation together with a custom [premake](https://premake.github.io/) build script. I created this to be able to experiment with using WebGPU as native graphics API. Despite its name, WebGPU is showing a lot of promise as a simple native graphics API, but there aren't that many examples around for quickly getting started with WebGPU and C++.

Higlights:
- Builds Dawn, Dear Imgui and SDL from source using premake to generate projects. 
- If you have Windows and Visual Studio 2022 or Mac OS X and XCode, all you should need to get started is this repo (but no promises it will work for your particular configuration). Run the generate projects script and build the solution generated in the "local" folder.
- Dawn source includes generated code, normally generated from the build process, from https://github.com/hexops/dawn/tree/main/mach
- Currently only supports Windows and DX12 or Mac OS X and Metal (only verified on Intel Mac).
- Includes an example of using HLSL shaders by using dxc to build spir-v. DXC binaries are included in the repo for Windows and OS X.
- Uses webgpu_cpp.h, a C++ api for webgpu

Future work I am considering includes:
- Updating to a newer Dawn version. Current version is from 2022-08-16
- Attempting to reduce compile times and executable size
- Generating and storing native shaders per platform rather than generating them at runtime.
