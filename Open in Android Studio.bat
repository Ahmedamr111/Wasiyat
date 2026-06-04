@echo off
setlocal enabledelayedexpansion

:: Define the project directory (current directory + wasiyati_app)
set "PROJECT_DIR=%~dp0wasiyati_app"

:: Check if wasiyati_app directory exists, otherwise fallback to the current directory
if not exist "%PROJECT_DIR%" (
    set "PROJECT_DIR=%~dp0"
)

echo ===================================================
echo   Wasiyati (وصيتي) - Open in Android Studio
echo ===================================================
echo.
echo Project Path: "%PROJECT_DIR%"
echo.
echo Searching for Android Studio installation...

:: Search Method 1: Query the Windows Registry for installation path
for /f "tokens=2*" %%A in ('reg query "HKLM\SOFTWARE\Android Studio" /v Path 2^>nul') do (
    set "STUDIO_PATH=%%B\bin\studio64.exe"
)

:: Search Method 2: Standard Program Files path
if not defined STUDIO_PATH (
    if exist "C:\Program Files\Android\Android Studio\bin\studio64.exe" (
        set "STUDIO_PATH=C:\Program Files\Android\Android Studio\bin\studio64.exe"
    )
)

:: Search Method 3: Local AppData path (user-only installation)
if not defined STUDIO_PATH (
    if exist "%LOCALAPPDATA%\Programs\Android Studio\bin\studio64.exe" (
        set "STUDIO_PATH=%LOCALAPPDATA%\Programs\Android Studio\bin\studio64.exe"
    )
)

:: Search Method 4: 32-bit or generic studio.exe fallback
if not defined STUDIO_PATH (
    if exist "C:\Program Files\Android\Android Studio\bin\studio.exe" (
        set "STUDIO_PATH=C:\Program Files\Android\Android Studio\bin\studio.exe"
    )
)

:: If found, launch it passing the project directory
if defined STUDIO_PATH (
    echo.
    echo Success: Found Android Studio at "%STUDIO_PATH%"
    echo Launching Wasiyati...
    start "" "%STUDIO_PATH%" "%PROJECT_DIR%"
    timeout /t 3 >nul
    exit
) else (
    echo.
    echo Warning: Android Studio was not found in standard installation paths.
    echo Attempting to launch using command-line shortcut 'studio'...
    echo.
    start "" studio "%PROJECT_DIR%" 2>nul
    if !errorlevel! equ 0 (
        echo Success: Launched via command-line shortcut.
        timeout /t 3 >nul
        exit
    )
    
    echo ===================================================
    echo   [ERROR] Android Studio could not be found!
    echo ===================================================
    echo Please make sure Android Studio is installed on your PC.
    echo.
    echo Checked standard locations:
    echo 1. Registry: HKLM\SOFTWARE\Android Studio
    echo 2. C:\Program Files\Android\Android Studio
    echo 3. %%LOCALAPPDATA%%\Programs\Android Studio
    echo.
    pause
)
