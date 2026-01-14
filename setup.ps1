# Antigravity Mega Studio Installer
Continue = "Stop"
Write-Host "?? Antigravity Mega Studio Kurulumu Baþlatýlýyor..." -ForegroundColor Cyan

 = $PSScriptRoot
$destGemini = "$HOME\.gemini"
$destAgent = "$HOME\.agent"

# 1. Clean old installs
if (Test-Path $destGemini\antigravity) { Remove-Item $destGemini\antigravity -Recurse -Force }
if (Test-Path $destAgent\workflows) { Remove-Item $destAgent\workflows -Recurse -Force }

# 2. Install
New-Item -ItemType Directory -Force -Path $destGemini | Out-Null
Copy-Item -Path "$source\antigravity" -Destination "$destGemini\antigravity" -Recurse -Force
Copy-Item -Path "$source\GEMINI.md" -Destination "$destGemini\GEMINI.md" -Force

New-Item -ItemType Directory -Force -Path $destAgent\workflows | Out-Null
Copy-Item -Path "$source\.agent\workflows\*" -Destination "$destAgent\workflows" -Recurse -Force

Write-Host "? Kurulum Tamamlandý!" -ForegroundColor Green
