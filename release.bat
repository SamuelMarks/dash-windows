@echo off
setlocal enabledelayedexpansion

set DASH_REF=%~1
if "%DASH_REF%"=="" set DASH_REF=v0.5.13.5

echo ==============================================
echo Building DASH Windows Release (%DASH_REF%)
echo ==============================================

if not exist dash (
    if exist ..\dash\src\main.c (
        echo Using local ..\dash repository...
    ) else (
        echo Cloning DASH from https://git.kernel.org/pub/scm/utils/dash/dash.git...
        git clone --branch %DASH_REF% --depth 1 https://git.kernel.org/pub/scm/utils/dash/dash.git dash
    )
)

if exist dash\src\main.c (
    if not exist dash\CMakeLists.txt (
        echo Applying Windows native builds patch...
        cd dash
        git apply --ignore-whitespace ..\patches\0001-Windows-native-builds.patch
        if errorlevel 1 (
            echo Failed to apply patch
            cd ..
            exit /b 1
        )
        cd ..
    )
)

if not exist auto-win-msvc (
    if exist ..\auto-win-msvc\CMakeLists.txt (
        echo Using local ..\auto-win-msvc repository...
    )
)

set BUILD_DIR=build_release
if exist %BUILD_DIR% rmdir /s /q %BUILD_DIR%

echo Configuring with CMake...
cmake -B %BUILD_DIR% -S . -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 exit /b 1

echo Compiling DASH Release...
cmake --build %BUILD_DIR% --config Release
if errorlevel 1 exit /b 1

echo Packaging with CPack...
cd %BUILD_DIR%
cpack -G ZIP
cpack -G NSIS
cd ..

echo Build and packaging complete!
