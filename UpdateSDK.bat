:: This file is part of the FidelityFX Super Resolution 3.1 Unreal Engine Plugin.
::
:: Copyright (c) 2023-2025 Advanced Micro Devices, Inc. All rights reserved.
::
:: Permission is hereby granted, free of charge, to any person obtaining a copy
:: of this software and associated documentation files (the "Software"), to deal
:: in the Software without restriction, including without limitation the rights
:: to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
:: copies of the Software, and to permit persons to whom the Software is
:: furnished to do so, subject to the following conditions:
:: The above copyright notice and this permission notice shall be included in
:: all copies or substantial portions of the Software.
::
:: THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
:: IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
:: FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
:: AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
:: LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
:: OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
:: THE SOFTWARE.

@echo off
setlocal
pushd "%~dp0"

RMDIR /S /Q FSR3\Source\fidelityfx-hlsl

mkdir FSR3\Source\fidelityfx-hlsl
mkdir FSR3\Source\fidelityfx-hlsl\frameinterpolation
mkdir FSR3\Source\fidelityfx-hlsl\frameinterpolation\spd
mkdir FSR3\Source\fidelityfx-hlsl\fsr3upscaler
mkdir FSR3\Source\fidelityfx-hlsl\opticalflow
mkdir FSR3\Source\fidelityfx-hlsl\spd
mkdir FSR3\Source\fidelityfx-hlsl\fsr1
mkdir FSR3\Source\fidelityfx-hlsl\fsr3upscaler\spd
mkdir FSR3\Source\fidelityfx-hlsl\fsr3upscaler\fsr1
mkdir FSR3\Source\fidelityfx-hlsl\opticalflow\spd
mkdir FSR3\Source\fidelityfx-hlsl\opticalflow\opticalflow

xcopy FSR3\Source\fidelityfx-sdk\sdk\src\backends\dx12\shaders\frameinterpolation\*.hlsl FSR3\Source\fidelityfx-hlsl
xcopy FSR3\Source\fidelityfx-sdk\sdk\src\backends\dx12\shaders\fsr3upscaler\*.hlsl FSR3\Source\fidelityfx-hlsl
xcopy FSR3\Source\fidelityfx-sdk\sdk\src\backends\dx12\shaders\opticalflow\*.hlsl FSR3\Source\fidelityfx-hlsl

xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\*.h FSR3\Source\fidelityfx-hlsl\frameinterpolation
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\*.h FSR3\Source\fidelityfx-hlsl\fsr3upscaler
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\*.h FSR3\Source\fidelityfx-hlsl\opticalflow

xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\frameinterpolation\*.h FSR3\Source\fidelityfx-hlsl\frameinterpolation
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\fsr3upscaler\*.h FSR3\Source\fidelityfx-hlsl\fsr3upscaler
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\opticalflow\*.h FSR3\Source\fidelityfx-hlsl\opticalflow
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\opticalflow\*.h FSR3\Source\fidelityfx-hlsl\opticalflow\opticalflow
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\fsr1\*.h FSR3\Source\fidelityfx-hlsl\fsr1
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\spd\*.h FSR3\Source\fidelityfx-hlsl\spd
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\fsr1\*.h FSR3\Source\fidelityfx-hlsl\fsr3upscaler\fsr1
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\spd\*.h FSR3\Source\fidelityfx-hlsl\fsr3upscaler\spd
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\spd\*.h FSR3\Source\fidelityfx-hlsl\opticalflow\spd
xcopy FSR3\Source\fidelityfx-sdk\sdk\include\FidelityFX\gpu\spd\*.h FSR3\Source\fidelityfx-hlsl\frameinterpolation\spd

pushd FSR3\Source\fidelityfx-sdk\ffx-api

call BuildFfxApiDll.bat -DFFX_API_BACKEND=DX12_X64 -DCMAKE_OBJECT_PATH_MAX=260

popd

xcopy /y /q FSR3\Source\fidelityfx-sdk\ffx-api\bin\amd_fidelityfx_dx12.dll FSR3\Source\fidelityfx-sdk\PrebuiltSignedDLL

popd
