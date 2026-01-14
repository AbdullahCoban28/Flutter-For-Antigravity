�	# Connect-Antigravity.ps1
# Bu scripti hangi klasörde çalıştırırsanız, orayı "Mega Studio"ya bağlar.
# Dosya kopyalamaz, "tünel" (Symlink) açar. Ana merkez güncellenince burası da güncellenir.

$globalAgent = "C:\Users\Abdullah\.agent"
$currentDir = Get-Location
$localAgent = Join-Path $currentDir ".agent"

Write-Host "🔌 Antigravity Bağlantısı Kuruluyor..." -ForegroundColor Cyan

if (-not (Test-Path $globalAgent)) {
    Write-Error "HATA: Ana Merkez ($globalAgent) bulunamadı! Önce kurulumu yapın."
    exit
}

if (Test-Path $localAgent) {
    Write-Warning "Bu projede zaten bir .agent klasörü var."
    $response = Read-Host "Silip yeniden bağlansın mı? (E/H)"
    if ($response -eq 'E') {
        Remove-Item $localAgent -Recurse -Force
    }
    else {
        Write-Host "İşlem iptal edildi."
        exit
    }
}

# Tüneli Aç (Junction)
New-Item -ItemType Junction -Path $localAgent -Target $globalAgent | Out-Null

Write-Host "✅ BAŞARILI!" -ForegroundColor Green
Write-Host "Bu proje artık Mega Studio'ya bağlı."
Write-Host "VS Code penceresini 'Reload' yapınca / tuşu çalışacaktır."
�	*cascade0821file:///C:/Users/Abdullah/Connect-Antigravity.ps1