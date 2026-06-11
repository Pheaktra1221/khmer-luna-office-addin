# Khmer Luna Date - Local File Installation for Office 2021
# This installs using a LOCAL file path which Office 2021 supports better than URLs

$manifestUrl = "https://khmer-luna-office-addin.onrender.com/manifest.xml"
$localDir = "$env:USERPROFILE\Documents\KhmerLunaAddin"
$localManifest = "$localDir\manifest.xml"

Write-Host "Installing Khmer Luna Date add-in..." -ForegroundColor Cyan
Write-Host ""

# Create directory
if (!(Test-Path $localDir)) {
    New-Item -ItemType Directory -Path $localDir -Force | Out-Null
}

# Download manifest
Write-Host "Downloading manifest to: $localManifest"
try {
    Invoke-WebRequest -Uri $manifestUrl -OutFile $localManifest -UseBasicParsing
    Write-Host "Downloaded successfully" -ForegroundColor Green
} catch {
    Write-Host "Failed to download manifest: $_" -ForegroundColor Red
    exit 1
}

# Register using LOCAL FILE PATH
$regKey = "HKCU:\Software\Microsoft\Office\16.0\WEF\Developer"
if (!(Test-Path $regKey)) {
    New-Item -Path $regKey -Force | Out-Null
}

$existing = (Get-ItemProperty -Path $regKey -Name "Manifests" -ErrorAction SilentlyContinue).Manifests

if ($existing) {
    $list = $existing -split ";" | Where-Object { $_ -and $_ -notlike "*KhmerLuna*" }
    $list += $localManifest
    $newValue = ($list -join ";")
} else {
    $newValue = $localManifest
}

Set-ItemProperty -Path $regKey -Name "Manifests" -Value $newValue -Type String
Write-Host "Registered in registry with LOCAL path" -ForegroundColor Green

Write-Host ""
Write-Host "===== IMPORTANT =====" -ForegroundColor Yellow
Write-Host "Office 2021 has LIMITED Web Add-in support."
Write-Host "The add-in button may NOT appear in the ribbon."
Write-Host ""
Write-Host "To use the add-in:" -ForegroundColor Cyan
Write-Host "1. Close all Office apps"
Write-Host "2. Open Word/Excel/PowerPoint"
Write-Host "3. Go to: Insert -> Add-ins -> My Add-ins"
Write-Host "4. Look under 'DEVELOPER ADD-INS' tab"
Write-Host "5. Click 'Khmer Luna Date' to load"
Write-Host ""
Write-Host "Alternative: Use web version directly"
Write-Host "https://khmer-luna-office-addin.onrender.com/taskpane/taskpane.html"
Write-Host ""
pause
