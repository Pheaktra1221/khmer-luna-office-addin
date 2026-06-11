param(
  [string]$ManifestPath = (Join-Path $PSScriptRoot "..\manifest.xml")
)

$ErrorActionPreference = "Stop"

$manifestSource = Resolve-Path $ManifestPath
$manifestName = Split-Path $manifestSource -Leaf
$wefRoot = Join-Path $env:LOCALAPPDATA "Microsoft\Office\16.0\Wef"

Write-Host "Khmer Luna Office Add-in — Windows sideload"
Write-Host "Manifest: $manifestSource"
Write-Host ""

if (-not (Test-Path $wefRoot)) {
  New-Item -ItemType Directory -Path $wefRoot -Force | Out-Null
}

$targets = @(
  (Join-Path $wefRoot $manifestName)
)

foreach ($target in $targets) {
  Copy-Item -Path $manifestSource -Destination $target -Force
  Write-Host "Copied manifest to: $target"
}

Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Run: npm start"
Write-Host "2. Open Excel, Word, or PowerPoint"
Write-Host "3. Home > Add-ins > select Khmer Luna Date"
Write-Host ""
Write-Host "If the add-in does not appear, restart Office."
Write-Host "Office 2021 requires Microsoft Edge WebView2."
