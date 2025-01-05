# FidelityFX Super Resolution 3 (Updated for UE5.5.1 {WIP})
The AMD FidelityFX Super Resolution 3 (FSR3) plugin for Unreal Engine 5.5.1.

As of right now Frame Gen is not working.

## Setup

To install the plugin:
1. Extract the zip file.
2. Place the FSR3 folder within your Unreal Engine source tree at: Engine/Plugins/Marketplace 
3. Open UnrealEditor.
4. Go to the Plugins window & enable FSR3
5. Restart.

## Usage
Temporal upsampling must be enabled in the `Project Settings > Rendering` or via the Console Variable `r.TemporalAA.Upsampling`.

FSR 3 can be enabled or disabled from the `Project Settings > FidelityFX Super Resolution 3 > Enabled`, or with the Console Variable `r.FidelityFX.FSR3.Enabled` in the configuration files - the variable can be modified at runtime *however* this is not guaranteed to be safe when other third-party upscalers are also enabled.

There are two backends for FSR3, one based on Unreal's RHI and a D3D12 native backend. 
The D3D12 backend supports asynchronous execution of frame interpolation and presentation that allows for superior performance and frame pacing, whereas the RHI backend executes frame interpolation serially without specific frame pacing but function on any platform supporting Shader Model 6.

By default the D3D12 backend is enabled, to use the RHI backend:
- Disable `r.FidelityFX.FSR3.UseNativeDX12` and enable `r.FidelityFX.FSR3.UseRHI`.

The plugin will use specific quality modes specified via `r.FidelityFX.FSR3.QualityMode` overriding `r.ScreenPercentage`.
The exposed modes are:
- **Native AA** : `r.FidelityFX.FSR3.QualityMode 0` <br>
Uses Super Resolution to perform temporal anti-aliasing without upscaling.

- **Quality** : `r.FidelityFX.FSR3.QualityMode 1` <br>
Produces a Super Resolution image which is nearly indiscernible from native rendering, and should be selected when image fidelity is paramount.

- **Balanced** : `r.FidelityFX.FSR3.QualityMode 2` <br>
Produces a Super Resolution image which is representative of native rendering, with minimal artifacts and sizeable performance gains.

- **Performance** : `r.FidelityFX.FSR3.QualityMode 3` <br>
Produces a Super Resolution image which approximates native rendering, with occasional artifacts but exceptional performance gains.

- **Ultra Performance** : `r.FidelityFX.FSR3.QualityMode 4` <br> 
Produces a Super Resolution image which may have notable artifacts under some conditions, and should be selected in situations where performance is critical.

## Frame Interpolation
Frame Interpolation is a new feature of FSR3. It requires FSR3 Upscaling to be enabled.

The FSR3 Frame Interpolation defaults to a D3D12 specific implementation that allows asynchronous execution of frame interpolation and frame pacing with or without VSync. 
For platforms that support Shader Model 6 there is also an RHI backend built on top of Unreal's RHI and Slate APIs. The RHI backend cannot perform proper frame-pacing so to get the best results `r.Vsync` must be enabled.

To use the RHI backend:
- Disable `r.FidelityFX.FSR3.UseNativeDX12` and enable `r.FidelityFX.FSR3.UseRHI`.

## Integration Instructions
FidelityFX Super Resolution 3 contains a built-in sharpening pass called RCAS that can be configured through the CVar `r.FidelityFX.FSR3.Sharpness`, this is disabled by default.  If your project has already integrated [FidelityFX-CAS](https://github.com/GPUOpenSoftware/UnrealEngine/tree/FidelityFXCAS-4.26), it may be necessary to disable FidelityFX CAS - including any in-game menu options - while `r.FidelityFX.FSR3.Sharpness` is enabled to prevent over-sharpening your final renders, and improve integration results. 

In order for FSR3 to process materials with World Position Offset and/or World Displacement correctly the `r.Velocity.EnableVertexDeformation` option must be enabled. The `r.FidelityFX.FSR3.ForceVertexDeformationOutputsVelocity` setting is enabled by default and when enabled FSR3 will force `r.Velocity.EnableVertexDeformation` on.
*For best results with Foliage assets that use World Position Offset and/or World Displacement select Moveable mobility to generate the necessary motion vectors.*

When `r.FidelityFX.FSR3.CreateReactiveMask` is enabled the FSR3 plugin forces `r.SSR.ExperimentalDenoiser` to 1 in order to capture the ScreenSpaceReflections, to handle this the initial value of `r.SSR.ExperimentalDenoiser` will be applied to `r.FidelityFX.FSR3.UseSSRExperimentalDenoiser`. Subsequent changes to the value of `r.FidelityFX.FSR3.UseSSRExperimentalDenoiser` will override this.

It is possible in the FSR3 plugin as of version 3.1.1 to use a Custom Depth/Stencil pass to setup select objects to write specific values into the reactive mask. To enable a custom Depth/Stencil pass in Unreal Engine 5 go to `Edit > Project Settings > Rendering` and setting `Custom Depth-Stencil Pass` to `Enabled with Stencil`, enabling `Custom Depth Taa Jitter` may reduce jitter. Then select objects in the main editor and navigate to the `Rendering > Advanced` settings and enable `Render CustomDepth Pass` and set the `CustomDepth Stencil Value` to a value between `1-255`, it is important to ensure that masking this value with `r.FidelityFX.FSR3.CustomStencilMask` produces a non-zero result. Set `r.FidelityFX.FSR3.CustomStencilShift` to make sure that the range for `r.FidelityFX.FSR3.CustomStencilMask` begins at `0-n`.

## Other Configurations
FidelityFX Super Resolution 3 has several additional CVars that can assist in meeting the needs of your project:

| CVar                                                      | Default Value | Valid Values | Details |
|-----------------------------------------------------------|---------------|--------------|--------------|
| `r.FidelityFX.FSR3.UseNativeDX12`                         | 1             | 0, 1         | True to use FSR3's native & optimised D3D12 backend, false to use the fallback implementation based on Unreal's RHI. Default is 1. |
| `r.FidelityFX.FSR3.UseRHI`                                | 0             | 0, 1         | True to enable FSR3's default RHI backend, false to disable in which case a native backend must be enabled. Default is 0. |
| `r.FidelityFX.FSR3.AdjustMipBias`                         | 1             | 0, 1         | Applies negative MipBias to material textures, improving results. <br>&nbsp;&nbsp; 0: Disabled <br>&nbsp;&nbsp; 1: Automatic |
| `r.FidelityFX.FSR3.Sharpness`                             | 0             | [0.0 - 1.0]  | When greater than 0.0 this enables Robust Contrast Adaptive Sharpening Filter to sharpen the output image. |
| `r.FidelityFX.FSR3.AutoExposure`                          | 0             | 0, 1         | Set to 1 to use FSR3's own auto-exposure, otherwise the engine's auto-exposure value is used. |
| `r.FidelityFX.FSR3.HistoryFormat`                         | 0             | 0, 1         | Selects the bit-depth for the FSR3 history texture format, defaults to PF_FloatRGBA but can be set to PF_FloatR11G11B10 to reduce bandwidth at the expense of quality. |
| `r.FidelityFX.FSR3.CreateReactiveMask`                    | 1             | 0, 1         | Enable to generate a mask from the SceneColor, GBuffer, SeparateTranslucency & ScreenspaceReflections that determines how reactive each pixel should be. |
| `r.FidelityFX.FSR3.ReactiveMaskReflectionScale`           | 0.4           | [0.0 - 1.0]  | Scales the Unreal engine reflection contribution to the reactive mask, which can be used to control the amount of aliasing on reflective surfaces. |
| `r.FidelityFX.FSR3.ReactiveMaskReflectionLumaBias`        | 0             | [0.0 - 1.0]  | Biases the reactive mask by the luminance of the reflection. Use to balance aliasing against ghosting on brightly lit reflective surfaces. |
| `r.FidelityFX.FSR3.ReactiveMaskRoughnessScale`            | 0.15          | [0.0 - 1.0]  | Scales the GBuffer roughness to provide a fallback value for the reactive mask when screenspace & planar reflections are disabled or don't affect a pixel. |
| `r.FidelityFX.FSR3.ReactiveMaskRoughnessBias`             | 0.25          | [0.0 - 1.0]  | Biases the reactive mask value when screenspace/planar reflections are weak with the GBuffer roughness to account for reflection environment captures. |
| `r.FidelityFX.FSR3.ReactiveMaskRoughnessMaxDistance`      | 6000          | [0.0 - INF]  | Maximum distance in world units for using material roughness to contribute to the reactive mask, the maximum of this value and View.FurthestReflectionCaptureDistance will be used. |
| `r.FidelityFX.FSR3.ReactiveMaskRoughnessForceMaxDistance` | 0             | 0, 1         | Enable to force the maximum distance in world units for using material roughness to contribute to the reactive mask rather than using View.FurthestReflectionCaptureDistance. |
| `r.FidelityFX.FSR3.ReactiveHistoryTranslucencyBias`       | 0.5           | [0.0 - 1.0]  | Scales how much translucency suppresses history via the reactive mask. Higher values will make translucent materials less reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveHistoryTranslucencyLumaBias`   | 0.0           | [0.0 - 1.0]  | Biases how much the translucency suppresses history via the reactive mask by the luminance of the transparency. Higher values will make bright translucent materials less reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskTranslucencyBias`          | 1.0           | [0.0 - 1.0]  | Scales how much contribution translucency makes to the reactive mask. Higher values will make translucent materials less reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskTranslucencyLumaBias`      | 0.0           | [0.0 - 1.0]  | Biases the translucency contribution to the reactive mask by the luminance of the transparency. Higher values will make bright translucent materials less reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskTranslucencyMaxDistance`   | 500000        | [0.0 - INF]  | Maximum distance in world units for using translucency to contribute to the reactive mask. This is a way to remove sky-boxes and other back-planes from the reactive mask, at the expense of nearer translucency not being reactive. |
| `r.FidelityFX.FSR3.ReactiveMaskPreDOFTranslucencyScale`   | 1.0           | [0.0 - 1.0]  | Scales how much contribution pre-Depth-of-Field translucency color makes to translucency contributions. Higher values will make translucent materials less reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskPreDOFTranslucencyMax`     | 0             | 0, 1         | Toggle to determine whether to use the max(SceneColorPostDepthOfField - SceneColorPreDepthOfField) or length(SceneColorPostDepthOfField - SceneColorPreDepthOfField) to determine the contribution of Pre-Depth-of-Field translucency. |
| `r.FidelityFX.FSR3.ReactiveMaskReactiveShadingModelID `   | MSM_NUM       | [0- MSM_NUM] | Treat the specified shading model as reactive, taking the CustomData0.x value as the reactive value to write into the mask. |
| `r.FidelityFX.FSR3.ReactiveMaskForceReactiveMaterialValue`| 0.0           | [0.0 - 1.0]  | Force the reactive mask value for Reactive Shading Model materials, when > 0 this value can be used to override the value supplied in the Material Graph. |
| `r.FidelityFX.FSR3.ReactiveMaskDeferredDecalScale`        | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), scales how much deferred decal values contribute to the reactive mask. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveHistoryDeferredDecalScale`     | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), scales how much deferred decal values contribute to supressing history. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskTAAResponsiveValue`        | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), value to write to reactive mask when pixels are marked in the stencil buffer as TAA Responsive. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveHistoryTAAResponsiveValue`     | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), value to write to reactive history when pixels are marked in the stencil buffer as TAA Responsive. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveMaskCustomStencilScale`        | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), scales how much custom stencil values contribute to the reactive mask. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.ReactiveHistoryCustomStencilScale`     | 0             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 0.0), scales how much custom stencil values contribute to supressing history. Higher values will make translucent materials more reactive which can reduce smearing. |
| `r.FidelityFX.FSR3.VelocityFactor`                        | 1             | 0.0 - 1.0    | Range from 0.0 to 1.0 (Default 1.0), value of 0.0f can improve temporal stability of bright pixels. |
| `r.FidelityFX.FSR3.CustomStencilMask`                     | 0             | 0 - 255      | A bitmask 0-255 (0-0xff) used when accessing the custom stencil to read reactive mask values. Setting to 0 will disable use of the custom-depth/stencil buffer. Default is 0. |
| `r.FidelityFX.FSR3.CustomStencilShift`                    | 0             | 0 - 31       | Bitshift to apply to the value read from the custom stencil when using it to provide reactive mask values. Default is 0. |
| `r.FidelityFX.FSR3.ForceVertexDeformationOutputsVelocity` | 1             | 0, 1         | Force enables materials with World Position Offset and/or World Displacement to output velocities during velocity pass even when the actor has not moved. |
| `r.FidelityFX.FSR3.UseSSRExperimentalDenoiser`            | 0             | 0, 1         | Enable to use r.SSR.ExperimentalDenoiser when FSR3 is enabled. This is required when r.FidelityFX.FSR3.CreateReactiveMask is enabled as the FSR3 plugin sets r.SSR.ExperimentalDenoiser to 1 in order to capture reflection data to generate the reactive mask. |
| `r.FidelityFX.FSR3.EnabledInEditorViewport`               | 0             | 0, 1         | Enable FidelityFX Super Resolution for Temporal Upscale in the Editor viewport by default. |
| `r.FidelityFX.FSR3.DeDither`                              | 0             | 0, 1         | Set to 1 to add an extra pass to de-dither rendering and avoid dithered/thin appearance. |
| `r.FidelityFX.FSR3.QuantizeInternalTextures`              | 0             | 0, 1         | Setting this to 1 will round up the size of some internal texture to ensure a specific divisibility. This is only intended for compatibility if required. Default is 0. |
| `r.FidelityFX.FI.Enabled`                                 | 1             | 0, 1         | Enable FidelityFX Frame Interpolation. |
| `r.FidelityFX.FI.CaptureDebugUI`                          | 1             | 0, 1         | Force FidelityFX Frame Interpolation to detect and copy any debug UI which only renders on the first invocation of Slate's DrawWindow command. Disabled in Shipping builds. |
| `r.FidelityFX.FI.OverrideSwapChainDX12`                   | 1             | 0, 1         | True to use FSR3's D3D12 swap-chain override that improves frame pacing, false to use the fallback implementation based on Unreal's RHI. Default is 1. |
| `r.FidelityFX.FI.AllowAsyncWorkloads`                     | 0             | 0, 1         | True to use async. execution of Frame Interpolation, 0 to run Frame Interpolation synchronously with the game. Default is 0 |
| `r.FidelityFX.FI.UpdateGlobalFrameTime`                   | 0             | 0, 1         | True to update the GAverageMs/GAverageFPS globals with average frame time/FPS calculated by the frame interpolation code. Default is 0. |
| `r.FidelityFX.FI.ShowDebugTearLines`                      | 1             | 0, 1         | Show the debug tear lines when running Frame Interpolation. Default is 1 for Debug/Development, not available in Test/Shipping. |
| `r.FidelityFX.FI.ShowDebugView`                           | 0             | 0, 1         | Show the debug view when running Frame Interpolation. Only available in Debug/Development. |
| `r.FidelityFX.FI.UIMode`                                  | 0             | 0, 1         | The method to render the UI when using Frame Generation. Slate Redraw (0): will cause Slate to render the UI on to both the real & generated images. UI Extraction (1): will compare the pre- & post- UI frame to extract the UI and copy it on to the generated frame. |
| `r.FidelityFX.FI.ModifySlateDeltaTime`                    | 1             | 0, 1         | Set the FSlateApplication delta time to 0.0 when redrawing the UI for the 'Slate Redraw' UI mode to prevent widgets' NativeTick implementations updating incorrectly, ignored when using 'UI Extraction'. |
| `r.FidelityFX.FI.RHIPacingMode`                           | 0             | 0, 1         | Enable pacing frames when using the RHI backend. None (0) : No frame pacing. Custom Present VSync (1) : enable VSync for the second presented frame. |
