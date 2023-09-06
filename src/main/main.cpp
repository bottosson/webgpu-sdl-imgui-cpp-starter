#include <stdio.h>

#include "shaderPaths.h"
#include <imgui.h>
#include <backends/imgui_impl_sdl2.h>
#include <backends/imgui_impl_wgpu.h>
#include <SDL.h>
#include <SDL_syswm.h>
#include <webgpu/webgpu_cpp.h>
#include <filesystem>
#include <fstream>

#if defined(__MACOSX__)
#include <SDL_metal.h>
#endif // defined(__MACOSX__)

static void OnUnhandledWgpuError(WGPUErrorType errorType, const char* message, void*)
{
    const char* errorTypeString = "";
    switch (errorType)
    {
    case WGPUErrorType_Validation:  errorTypeString = "Validation"; break;
    case WGPUErrorType_OutOfMemory: errorTypeString = "Out of memory"; break;
    case WGPUErrorType_Unknown:     errorTypeString = "Unknown"; break;
    case WGPUErrorType_DeviceLost:  errorTypeString = "Device lost"; break;
    default:                        errorTypeString = "Unknown";
    }
    printf("%s error: %s\n", errorTypeString, message);
    std::exit(1);
}

void SetAdapterCallback(WGPURequestAdapterStatus status, WGPUAdapter adapter, char const* message, void* userdata)
{
    *reinterpret_cast<wgpu::Adapter*>(userdata) = wgpu::Adapter(adapter);
}

void SetDeviceCallback(WGPURequestDeviceStatus status, WGPUDevice device, char const* message, void* userdata)
{
    *reinterpret_cast<wgpu::Device*>(userdata) = wgpu::Device(device);
}

wgpu::ProgrammableStageDescriptor LoadShader(wgpu::Device& device, const char* name, wgpu::ShaderStage shaderStage)
{
    static char spirvPath[512];
    static char hlslPath[512];
    static char cmdPath[512];

    const char* entry;
    const char* targetProfile;
    switch (shaderStage)
    {
        case wgpu::ShaderStage::Compute:
        {
            targetProfile = "cs_6_7";
            entry = "CSMain";
            break;
        }
        case wgpu::ShaderStage::Fragment:
        {
            targetProfile = "ps_6_7";
            entry = "PSMain";
            break;
        }
        case wgpu::ShaderStage::Vertex:
        {
            targetProfile = "vs_6_7";
            entry = "VSMain";
            break;
        }
    }

    snprintf(spirvPath, sizeof(spirvPath), "shaders/%s_%s.spirv", name, entry);
    std::filesystem::file_time_type spirvTime;
    bool spirvExists = std::filesystem::exists(spirvPath);
    if (spirvExists)
        spirvTime = std::filesystem::last_write_time(spirvPath);

    snprintf(hlslPath, sizeof(hlslPath), "%s/%s.hlsl", SHADER_SOURCE_PATH, name);
    std::filesystem::file_time_type hlslTime;
    bool hlslExists = std::filesystem::exists(hlslPath);
    if (hlslExists)
        hlslTime = std::filesystem::last_write_time(hlslPath);

    if (!hlslExists && !spirvExists)
    {
        printf("Error loading shader: %s\n", name);
        std::exit(1);
    }


    if (!spirvExists || spirvTime < hlslTime)
    {
        std::filesystem::create_directory("shaders");


        snprintf(cmdPath, sizeof(cmdPath), "%s -spirv -T %s -E %s -Fo %s %s", DXC_PATH, targetProfile, entry, spirvPath, hlslPath);

#if defined(__WINDOWS__)
        {
            char* ix = cmdPath;
            while ((ix = strchr(ix, '/')) != nullptr)
            {
                *ix++ = '\\';
            }
        }
#endif // defined(__WINDOWS__)

        system(cmdPath);
    }

    if (!std::filesystem::exists(spirvPath))
    {
        printf("Error loading shader: %s, can't find result after compiling.\n", name);
        std::exit(1);
    }

    std::ifstream f(spirvPath, std::ios::binary);
    f.seekg(0, f.end);
    size_t size = f.tellg();
    f.seekg(0, f.beg);

    char* data = new char[size];
    f.read(data, size);
    f.close();

    wgpu::ShaderModuleSPIRVDescriptor spirv_desc = {};
    spirv_desc.codeSize = (uint32_t)(size / sizeof(uint32_t));
    spirv_desc.code = (uint32_t*)data;

    wgpu::ShaderModuleDescriptor desc = {};
    desc.nextInChain = &spirv_desc;

    wgpu::ProgrammableStageDescriptor stage_desc = {};
    stage_desc.module = device.CreateShaderModule(&desc);
    stage_desc.entryPoint = entry;

    delete[] data;
    
    return stage_desc;
}

struct WebGpuData
{
    wgpu::Instance instance;
    wgpu::Adapter adapter;
    wgpu::Device device;
    wgpu::Surface surface;
    wgpu::SwapChain swapChain;

#if defined(__MACOSX__)
    SDL_MetalView sdlMetalView;
#endif
    
    static WebGpuData Create(SDL_Window& window, int width, int height);
    bool CreateSwapChain(int width, int height);
    

};

bool WebGpuData::CreateSwapChain(int width, int height)
{
    if (swapChain)
        swapChain.Release();

    wgpu::SwapChainDescriptor swapChainDesc;
    swapChainDesc.width = width;
    swapChainDesc.height = height;
    swapChainDesc.usage = wgpu::TextureUsage::RenderAttachment;
    swapChainDesc.format = wgpu::TextureFormat::BGRA8Unorm;
    swapChainDesc.presentMode = wgpu::PresentMode::Mailbox;

    swapChain = device.CreateSwapChain(surface, &swapChainDesc);

    return (bool)swapChain;
}

WebGpuData WebGpuData::Create(SDL_Window& window, int width, int height)
{
    WebGpuData data;

    data.instance = wgpu::CreateInstance();

    if (!data.instance)
        return {};

    data.instance.RequestAdapter(nullptr, SetAdapterCallback, reinterpret_cast<void*>(&data.adapter));

    if (!data.adapter)
        return {};

    data.adapter.RequestDevice(nullptr, SetDeviceCallback, reinterpret_cast<void*>(&data.device));

    if (!data.device)
        return {};

    data.device.SetUncapturedErrorCallback(OnUnhandledWgpuError, nullptr);

#if defined(__WINDOWS__)
    SDL_SysWMinfo wmInfo;
    SDL_VERSION(&wmInfo.version);
    SDL_GetWindowWMInfo(&window, &wmInfo);
    
    wgpu::SurfaceDescriptorFromWindowsHWND windowsDesc;
    windowsDesc.hwnd = wmInfo.info.win.window;
    windowsDesc.hinstance = wmInfo.info.win.hinstance;
    
#elif defined(__MACOSX__)
    data.sdlMetalView = SDL_Metal_CreateView(&window);
    wgpu::SurfaceDescriptorFromMetalLayer windowsDesc;
    windowsDesc.layer = SDL_Metal_GetLayer(data.sdlMetalView);
#endif
    
    wgpu::SurfaceDescriptor surfaceDesc;
    surfaceDesc.nextInChain = &windowsDesc;
    data.surface = data.instance.CreateSurface(&surfaceDesc);

    if (!data.surface)
        return {};

    if (!data.CreateSwapChain(width, height))
        return {};

    return data;
}

int main(int argc, char** argv)
{
    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_TIMER | SDL_INIT_GAMECONTROLLER) != 0)
    {
        printf("Error: %s\n", SDL_GetError());
        return -1;
    }

    SDL_WindowFlags window_flags = (SDL_WindowFlags)(SDL_WINDOW_RESIZABLE | SDL_WINDOW_ALLOW_HIGHDPI);
    SDL_Window* window = SDL_CreateWindow("Dear ImGui + SDL2 + Dawn Example", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 1280, 720, window_flags);
    SDL_SysWMinfo wmInfo;
    SDL_VERSION(&wmInfo.version);
    SDL_GetWindowWMInfo(window, &wmInfo);
    
#if defined(__WINDOWS__)
    HWND hwnd = (HWND)wmInfo.info.win.window;
#endif // defined(__WINDOWS__)

    int w, h;
    SDL_GL_GetDrawableSize(window, &w, &h);
    {
        WebGpuData webGpuData = WebGpuData::Create(*window, w, h);
        if (!webGpuData.swapChain)
        {
            return 1;
        }

        wgpu::RenderPipeline simpleRenderPipeline;
        
        {
            wgpu::ProgrammableStageDescriptor simpleFragment = LoadShader(webGpuData.device, "simple", wgpu::ShaderStage::Fragment);
            wgpu::ProgrammableStageDescriptor simpleVertex = LoadShader(webGpuData.device, "simple", wgpu::ShaderStage::Vertex);

            wgpu::RenderPipelineDescriptor renderPipelineDesc = {};
            renderPipelineDesc.primitive.topology = wgpu::PrimitiveTopology::TriangleList;
            renderPipelineDesc.layout = nullptr;

            // Create the vertex shader
            renderPipelineDesc.vertex.module = simpleVertex.module;
            renderPipelineDesc.vertex.entryPoint = simpleVertex.entryPoint;

            wgpu::VertexAttribute vertexDesc[] =
            {
                { wgpu::VertexFormat::Float32x2, 0, 0 },
                { wgpu::VertexFormat::Float32x3, 2 * sizeof(float), 1 },
            };

            wgpu::VertexBufferLayout bufferLayouts[1];
            bufferLayouts[0].arrayStride = 5 * sizeof(float);
            bufferLayouts[0].stepMode = wgpu::VertexStepMode::Vertex;
            bufferLayouts[0].attributeCount = 2;
            bufferLayouts[0].attributes = vertexDesc;

            renderPipelineDesc.vertex.bufferCount = 1;
            renderPipelineDesc.vertex.buffers = bufferLayouts;

            // Create the blending setup
            wgpu::BlendState blendState = {};
            blendState.alpha.operation = wgpu::BlendOperation::Add;
            blendState.alpha.srcFactor = wgpu::BlendFactor::One;
            blendState.alpha.dstFactor = wgpu::BlendFactor::OneMinusSrcAlpha;
            blendState.color.operation = wgpu::BlendOperation::Add;
            blendState.color.srcFactor = wgpu::BlendFactor::SrcAlpha;
            blendState.color.dstFactor = wgpu::BlendFactor::OneMinusSrcAlpha;

            wgpu::ColorTargetState colorState = {};
            colorState.format = wgpu::TextureFormat::BGRA8Unorm;
            colorState.blend = &blendState;
            colorState.writeMask = wgpu::ColorWriteMask::All;

            wgpu::FragmentState fragmentState = {};
            fragmentState.module = simpleFragment.module;
            fragmentState.entryPoint = simpleFragment.entryPoint;
            fragmentState.targetCount = 1;
            fragmentState.targets = &colorState;

            renderPipelineDesc.fragment = &fragmentState;

            simpleRenderPipeline = webGpuData.device.CreateRenderPipeline(&renderPipelineDesc);
        }

        wgpu::Buffer vertexBuffer;
        
        {
            wgpu::BufferDescriptor desc = {};
            desc.usage = wgpu::BufferUsage::CopyDst | wgpu::BufferUsage::Vertex;
            desc.size = 3 * 5 * sizeof(float);
            vertexBuffer = webGpuData.device.CreateBuffer(&desc);
        }

        IMGUI_CHECKVERSION();
        ImGui::CreateContext();
        ImGui::StyleColorsDark();
#if defined(__WINDOWS__)
        ImGui_ImplSDL2_InitForD3D(window);
#elif defined(__MACOSX__)
        ImGui_ImplSDL2_InitForMetal(window);
#endif
        ImGui_ImplWGPU_Init(webGpuData.device.Get(), 3, WGPUTextureFormat_BGRA8Unorm, WGPUTextureFormat_Undefined);

        float colorA[] = { 1.f,0.f,0.f };
        float colorB[] = { 0.f,1.f,0.f };
        float colorC[] = { 0.f,0.f,1.f };

        bool done = false;
        while (!done)
        {
            SDL_Event event;
            while (SDL_PollEvent(&event))
            {
                ImGui_ImplSDL2_ProcessEvent(&event);
                if (event.type == SDL_QUIT)
                    done = true;
                if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_CLOSE && event.window.windowID == SDL_GetWindowID(window))
                    done = true;
                if (event.type == SDL_WINDOWEVENT && event.window.event == SDL_WINDOWEVENT_RESIZED && event.window.windowID == SDL_GetWindowID(window))
                {
                    int w, h;
                    SDL_GL_GetDrawableSize(window, &w, &h);

                    ImGui_ImplWGPU_InvalidateDeviceObjects();
                    webGpuData.CreateSwapChain(w, h);
                    ImGui_ImplWGPU_CreateDeviceObjects();
                }
            }

            {
                ImGui_ImplWGPU_NewFrame();
                ImGui_ImplSDL2_NewFrame();
                ImGui::NewFrame();

                {
                    ImGui::Begin("Triangle Colors");
                    ImGui::ColorPicker3("A", colorA);
                    ImGui::ColorPicker3("B", colorB);
                    ImGui::ColorPicker3("C", colorC);
                    ImGui::End();
                }

                ImGui::Render();
            }

            {
                wgpu::RenderPassColorAttachment colorAttachments = {};
                colorAttachments.loadOp = wgpu::LoadOp::Clear;
                colorAttachments.storeOp = wgpu::StoreOp::Store;
                colorAttachments.clearValue = { 0.1f, 0.1f, 0.1f, 1.f };
                colorAttachments.view = webGpuData.swapChain.GetCurrentTextureView();

                wgpu::RenderPassDescriptor renderPassDesc = {};
                renderPassDesc.colorAttachmentCount = 1;
                renderPassDesc.colorAttachments = &colorAttachments;
                renderPassDesc.depthStencilAttachment = NULL;

                wgpu::CommandEncoderDescriptor encoderDesc = {};
                wgpu::CommandEncoder encoder = webGpuData.device.CreateCommandEncoder(&encoderDesc);

                wgpu::RenderPassEncoder pass = encoder.BeginRenderPass(&renderPassDesc);

                pass.SetPipeline(simpleRenderPipeline);
                pass.SetVertexBuffer(0, vertexBuffer);
                pass.Draw(3, 1, 0, 0);
                
                ImGui_ImplWGPU_RenderDrawData(ImGui::GetDrawData(), pass.Get());
                pass.End();

                wgpu::CommandBufferDescriptor commandBufferDesc = {};
                wgpu::CommandBuffer commandBuffer = encoder.Finish(&commandBufferDesc);
                wgpu::Queue queue = wgpuDeviceGetQueue(webGpuData.device.Get());
                
                float vertexData[] =
                {
                    -0.8f, -0.8f, colorA[0], colorA[1], colorA[2],
                     0.8f, -0.8f, colorB[0], colorB[1], colorB[2],
                    -0.0f,  0.8f, colorC[0], colorC[1], colorC[2],
                };
                queue.WriteBuffer(vertexBuffer, 0, vertexData, sizeof(vertexData));
                
                queue.Submit(1, &commandBuffer);

                webGpuData.swapChain.Present();
            }
        }

        ImGui_ImplWGPU_Shutdown();
        ImGui_ImplSDL2_Shutdown();
        ImGui::DestroyContext();
        
#if defined(__MACOSX__)
        SDL_MetalView metalView = webGpuData.sdlMetalView;
#endif
        
        webGpuData = {};

#if defined(__MACOSX__)
        SDL_Metal_DestroyView(metalView);
#endif
    }
    
    SDL_DestroyWindow(window);
    SDL_Quit();

    return 0;
}
