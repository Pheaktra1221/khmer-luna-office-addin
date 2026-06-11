# Khmer Luna Date - Office Add-in Installer
# Run as Administrator: Right-click this file -> Run with PowerShell

$addinId   = "8f3c2a1b-4d5e-6f70-8192-a3b4c5d6e7f8"
$addinName = "Khmer Luna Date"
$manifestUrl = "https://khmer-luna-office-addin.onrender.com/manifest.xml"

# Download manifest to temp folder
$manifestDir  = "$env:LOCALAPPDATA\KhmerLunaAddin"
$manifestPath = "$manifestDir\manifest.xml"

Write-Host "Creating folder: $manifestDir"
New-Item -ItemType Directory -Force -Path $manifestDir | Out-Null

Write-Host "Downloading manifest..."
Invoke-WebRequest -Uri $manifestUrl -OutFile $manifestPath -UseBasicParsing
Write-Host "Saved to: $manifestPath"

# Register via shared catalog in registry
$catalogKey = "HKCU:\Software\Microsoft\Office\16.0\WEF\TrustedCatalogs\$addinId"
Write-Host "Registering catalog in registry..."
New-Item -Path $catalogKey -Force | Out-Null
Set-ItemProperty -Path $catalogKey -Name "Id"          -Value $addinId
Set-ItemProperty -Path $catalogKey -Name "Url"         -Value $manifestDir
Set-ItemProperty -Path $catalogKey -Name "Flags"       -Value 1 -Type DWord
Set-ItemProperty -Path $catalogKey -Name "Type"        -Value 1 -Type DWord

Write-Host ""
Write-Host "Done! Now:" -ForegroundColor Green
Write-Host "1. Close and reopen Word / Excel / PowerPoint"
Write-Host "2. Go to Insert -> Add-ins -> My Add-ins -> SHARED FOLDER tab"
Write-Host "3. Click 'Khmer Luna Date' then Add"
