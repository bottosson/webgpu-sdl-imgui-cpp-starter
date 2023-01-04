This is a quick example of using Dear ImGui, SDL and the Dawn WebGPU implementation together. I created this to be able to experiment with using WebGPU as native graphics API. Despite its name, WebGPU is showing a lot of promise as a simple native graphics API, but it isn't very accessible.

Higlights:
- If you have Windows and Visual Studio 2022 or Mac OS X and XCode, all you should need to get started is this repo (but no promises it will work for your particular configuration).
- Builds Dawn, Dear Imgui and SDL from source using premake to generate projects. 
- Dawn source includes generated code normally generated from the build process, from https://github.com/hexops/dawn/tree/main/mach
- Currently only supports Windows and DX12 or Mac OS X and Metal (currently only verified on Intel Mac).
- Includes an example of using HLSL shaders by using dxc to build spir-v. DXC binaries are included in the repo,  
- Uses webgpu_cpp.h

Future work I am considering includes:
- Updating to a newer Dawn version
- Attempting to reduce compile times and executable size
- Generating and storing native shaders per platform rather than generating them at runtime.