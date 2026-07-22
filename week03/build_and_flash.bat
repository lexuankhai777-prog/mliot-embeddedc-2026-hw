@echo off
setlocal

set BUILD_DIR=build
set FIRMWARE=%BUILD_DIR%\app_firmware.bin
set FLASH_ADDR=0x08000000

cd /d "%~dp0"

echo STEP 1: CLEANING BUILD DIRECTORY
if exist %BUILD_DIR% (
    echo Deleting existing build folder...
    rmdir /s /q %BUILD_DIR%
)

echo.
echo STEP 2: CONFIGURING PROJECT WITH CMAKE
cmake -B %BUILD_DIR% -G Ninja
if %ERRORLEVEL% neq 0 (
    echo CMake configure failed.
    pause
    exit /b 1
)

echo.
echo STEP 3: COMPILING FIRMWARE WITH NINJA
cmake --build %BUILD_DIR%
if %ERRORLEVEL% neq 0 (
    echo Build failed.
    pause
    exit /b 1
)

if not exist %FIRMWARE% (
    echo Firmware file not found: %FIRMWARE%
    pause
    exit /b 1
)

echo.
echo STEP 4: FLASHING FIRMWARE TO TARGET MCU
STM32_Programmer_CLI -c port=SWD -w %FIRMWARE% %FLASH_ADDR% -v -rst
if %ERRORLEVEL% neq 0 (
    echo Flash failed.
    pause
    exit /b 1
)

echo.
echo Application running.
pause
endlocal