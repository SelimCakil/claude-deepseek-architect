# Claude Code + DeepSeek Mimar Kurulum Scripti (Windows)
# Çalıştırmak için: .\setup.ps1

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "=== Claude Code + DeepSeek Mimar Kurulumu ===" -ForegroundColor Cyan
Write-Host ""

# 1. Node.js kontrolü
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "[HATA] Node.js bulunamadi. https://nodejs.org adresinden kurun." -ForegroundColor Red
    exit 1
}

# 2. Claude Code kontrolü
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    Write-Host "[HATA] Claude Code bulunamadi. https://claude.ai/code adresinden kurun." -ForegroundColor Red
    exit 1
}

# 3. DeepSeek API key al
$apiKey = $env:DEEPSEEK_API_KEY
if (-not $apiKey) {
    Write-Host "DeepSeek API anahtarinizi girin (https://platform.deepseek.com):" -ForegroundColor Yellow
    $apiKey = Read-Host "DEEPSEEK_API_KEY"
    if (-not $apiKey) {
        Write-Host "[HATA] API key bos olamaz." -ForegroundColor Red
        exit 1
    }
}

# 4. ~/.claude dizini kontrolü
$claudeDir = "$env:USERPROFILE\.claude"
if (-not (Test-Path $claudeDir)) {
    New-Item -ItemType Directory -Path $claudeDir | Out-Null
}

# 5. CLAUDE.md global konuma kopyala
$sourceClaude = Join-Path $PSScriptRoot "CLAUDE.md"
$targetClaude = Join-Path $claudeDir "CLAUDE.md"

if (Test-Path $targetClaude) {
    Write-Host ""
    Write-Host "Mevcut CLAUDE.md bulundu: $targetClaude" -ForegroundColor Yellow
    $overwrite = Read-Host "Uzerine yazilsin mi? (e/h)"
    if ($overwrite -ne "e") {
        Write-Host "CLAUDE.md guncellenmedi, atlanıyor." -ForegroundColor Gray
    } else {
        Copy-Item $sourceClaude $targetClaude -Force
        Write-Host "[OK] CLAUDE.md guncellendi." -ForegroundColor Green
    }
} else {
    Copy-Item $sourceClaude $targetClaude
    Write-Host "[OK] CLAUDE.md kopyalandi." -ForegroundColor Green
}

# 6. settings.json oluştur (API key enjekte edilerek)
$settingsTarget = Join-Path $claudeDir "settings.json"
$settingsContent = @"
{
  "theme": "dark-daltonized",
  "mcpServers": {
    "houtini-lm": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@houtini/lm"],
      "env": {
        "HOUTINI_LM_ENDPOINT_URL": "https://api.deepseek.com",
        "HOUTINI_LM_API_KEY": "$apiKey"
      }
    }
  }
}
"@

if (Test-Path $settingsTarget) {
    $existingSettings = Get-Content $settingsTarget | ConvertFrom-Json
    if ($existingSettings.mcpServers) {
        Write-Host ""
        Write-Host "Mevcut settings.json'da mcpServers zaten var." -ForegroundColor Yellow
        $overwriteSettings = Read-Host "houtini-lm guncellenerek yazilsin mi? (e/h)"
        if ($overwriteSettings -ne "e") {
            Write-Host "settings.json guncellenmedi, atlanıyor." -ForegroundColor Gray
        } else {
            $settingsContent | Out-File -FilePath $settingsTarget -Encoding utf8
            Write-Host "[OK] settings.json guncellendi." -ForegroundColor Green
        }
    } else {
        $settingsContent | Out-File -FilePath $settingsTarget -Encoding utf8
        Write-Host "[OK] settings.json guncellendi." -ForegroundColor Green
    }
} else {
    $settingsContent | Out-File -FilePath $settingsTarget -Encoding utf8
    Write-Host "[OK] settings.json olusturuldu." -ForegroundColor Green
}

# 7. houtini-lm paketini önden indir (isteğe bağlı)
Write-Host ""
$preload = Read-Host "houtini-lm paketi onceden indirilsin mi? (e/h, onerilir)"
if ($preload -eq "e") {
    Write-Host "Indiriliyor..." -ForegroundColor Gray
    npx -y @houtini/lm --help 2>&1 | Out-Null
    Write-Host "[OK] houtini-lm hazir." -ForegroundColor Green
}

Write-Host ""
Write-Host "=== Kurulum tamamlandi! ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Simdi herhangi bir klasorde 'claude' yazarak baslayabilirsiniz." -ForegroundColor White
Write-Host "MD dosyasi verdiginizde Claude otomatik analiz edip paralel gorev dagitimi yapacak." -ForegroundColor White
Write-Host ""
