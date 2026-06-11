@echo off
REM Khmer Luna Date - Windows Installer (Batch version)
REM Double-click to run, or run from Command Prompt

echo ====================================
echo Khmer Luna Date - Windows Installer
echo ====================================
echo.

REM Check for admin rights
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo This installer needs Administrator privileges.
    echo Please right-click and select "Run as administrator"
    pause
    exit /b 1
)

set MANIFEST_URL=https://khmer-luna-office-addin.onrender.com/manifest.xml
set ADDIN_DIR=%LOCALAPPDATA%\KhmerLunaAddin
set MANIFEST_PATH=%ADDIN_DIR%\manifest.xml

echo Creating directory: %ADDIN_DIR%
if not exist "%ADDIN_DIR%" mkdir "%ADDIN_DIR%"

echo Downloading manifest...
powershell -Command "Invoke-WebRequest -Uri '%MANIFEST_URL%' -OutFile '%MANIFEST_PATH%' -UseBasicParsing"

if %errorLevel% neq 0 (
    echo Failed to download manifest
    pause
    exit /b 1
)

echo Manifest saved to: %MANIFEST_PATH%

echo.
echo Registering add-in in Windows Registry...
powershell -Command "$manifestUrl = '%MANIFEST_URL%'; $key = 'HKCU:\Software\Microsoft\Office\16.0\WEF\Developer'; if (!(Test-Path $key)) { New-Item -Path $key -Force | Out-Null }; $existing = (Get-ItemProperty -Path $key -Name 'Manifests' -ErrorAction SilentlyContinue).Manifests; if ($existing) { $list = $existing -split ';' | Where-Object { $_ -and $_ -notlike '*khmer-luna*' }; $list += $manifestUrl; $new = ($list -join ';') } else { $new = $manifestUrl }; Set-ItemProperty -Path $key -Name 'Manifests' -Value $new -Type String"

if %errorLevel% neq 0 (
    echo Failed to register in registry
    pause
    exit /b 1
)

echo.
echo ====================================
echo Installation Complete!
echo ====================================
echo.
echo Next steps:
echo 1. Close ALL Office apps (Word, Excel, PowerPoint)
echo 2. Reopen Word/Excel/PowerPoint
echo 3. Look for "Khmer Luna" button in the Home ribbon
echo.
echo If you don't see it, go to Insert -^> Add-ins -^> My Add-ins
echo The add-in should appear under "Developer Add-ins"
echo.
pause
