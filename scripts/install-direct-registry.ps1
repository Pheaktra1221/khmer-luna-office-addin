# Khmer Luna Date - Direct Registry Installation
# Run as Administrator

$addinId   = "8f3c2a1b-4d5e-6f70-8192-a3b4c5d6e7f8"
$manifestUrl = "https://khmer-luna-office-addin.onrender.com/manifest.xml"

Write-Host "Installing Khmer Luna Date add-in via registry..." -ForegroundColor Cyan

# For Word
$wordKey = "HKCU:\Software\Microsoft\Office\16.0\WEF\Developer"
Write-Host "Registering in Word..."
if (!(Test-Path $wordKey)) {
    New-Item -Path $wordKey -Force | Out-Null
}

# Get existing manifests
$existing = Get-ItemProperty -Path $wordKey -Name "Manifests" -ErrorAction SilentlyContinue | Select-Object -ExpandProperty Manifests -ErrorAction SilentlyContinue

if ($existing) {
    $manifestList = $existing -split ";" | Where-Object { $_ -and $_ -notlike "*$addinId*" }
    $manifestList += $manifestUrl
    $newValue = ($manifestList -join ";")
} else {
    $newValue = $manifestUrl
}

Set-ItemProperty -Path $wordKey -Name "Manifests" -Value $newValue -Type String
Write-Host "Word: Registered"

# For Excel
$excelKey = "HKCU:\Software\Microsoft\Office\16.0\WEF\Developer"
Write-Host "Excel: Using same key (multi-host manifest)"

# For PowerPoint
Write-Host "PowerPoint: Using same key (multi-host manifest)"

Write-Host ""
Write-Host "Done! Now:" -ForegroundColor Green
Write-Host "1. Close ALL Office apps completely (check Task Manager)"
Write-Host "2. Open Word/Excel/PowerPoint"
Write-Host "3. Look for 'Khmer Luna' button in the Home ribbon"
Write-Host ""
Write-Host "If you don't see it, go to Insert -> Add-ins -> My Add-ins"
Write-Host "The add-in should appear under 'Developer Add-ins'"
