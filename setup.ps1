# Antigravity Mega Studio Installer
# Installs the 7-Level Hierarchy to your local Antigravity setup.

$ErrorActionPreference = "Stop"

Write-Host "🚀 Antigravity Mega Studio Kurulumu Başlatılıyor..." -ForegroundColor Cyan

# Paths
$source = $PSScriptRoot
$destGemini = "$HOME\.gemini"
$destAgent = "$HOME\.agent"

# 1. Install Antigravity Core & Studio
Write-Host "📂 Stüdyo dosyaları kopyalanıyor ($destGemini)..." -ForegroundColor Yellow
if (-not (Test-Path "$destGemini\antigravity")) { New-Item -ItemType Directory -Force -Path "$destGemini\antigravity" | Out-Null }
Copy-Item -Path "$source\antigravity\*" -Destination "$destGemini\antigravity" -Recurse -Force

# 2. Install Workflows
Write-Host "⚡ Kısayollar (Workflows) güncelleniyor ($destAgent)..." -ForegroundColor Yellow
if (-not (Test-Path "$destAgent\workflows")) { New-Item -ItemType Directory -Force -Path "$destAgent\workflows" | Out-Null }
Copy-Item -Path "$source\.agent\workflows\*" -Destination "$destAgent\workflows" -Recurse -Force

# 3. Create Legacy Archive (Cleanup)
$archivePath = "$destAgent\workflows\legacy_archive"
if (-not (Test-Path $archivePath)) { New-Item -ItemType Directory -Force -Path $archivePath | Out-Null }

Write-Host "✅ Kurulum Tamamlandı!" -ForegroundColor Green
Write-Host "🎉 Artık Antigravity'ye 'Bir fikrim var' diyebilirsiniz." -ForegroundColor White
Start-Sleep -Seconds 3
