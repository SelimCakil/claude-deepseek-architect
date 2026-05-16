# ── DeepSeek / Claudex Komutları ──────────────────────────────────────────────
#
# Bu dosyayı PowerShell profilinize ekleyin:
#   Windows : C:\Users\<kullanici>\Documents\WindowsPowerShell\profile.ps1
#   macOS   : ~/.zshrc veya ~/.bashrc (bash/zsh uyarlaması gerekir)
#
# DEEPSEEK_API_KEY değişkenini kendi anahtarınızla doldurun.
# Anahtar: https://platform.deepseek.com
# ──────────────────────────────────────────────────────────────────────────────

$DEEPSEEK_API_KEY = "YOUR_DEEPSEEK_API_KEY"
$DEEPSEEK_PROFILE = "$env:USERPROFILE\.claudex\profiles\deepseek"

# Kaydedilmemiş VS Code dosyalarını kaydeder (deepseek-code / deepseek-code-del için yardımcı)
function Save-VSCodeFiles {
    $wsh = New-Object -ComObject WScript.Shell
    $wsh.AppActivate("Visual Studio Code")
    Start-Sleep -Milliseconds 300
    $wsh.SendKeys("^k")
    Start-Sleep -Milliseconds 100
    $wsh.SendKeys("s")
}

# ── deepseek ──────────────────────────────────────────────────────────────────
# Kullanım : deepseek
# Ne yapar : Terminalde Claude Code'u açar, tüm API çağrıları DeepSeek'e gider.
#             Claude kotanız tükenmez; model olarak deepseek-v4-pro kullanılır.
# Nasıl    : ANTHROPIC_BASE_URL'yi DeepSeek endpoint'ine yönlendirir,
#             ayrı bir CLAUDE_CONFIG_DIR profili kullanır.
function deepseek {
    $env:CLAUDE_CONFIG_DIR          = $DEEPSEEK_PROFILE
    $env:ANTHROPIC_BASE_URL         = "https://api.deepseek.com/anthropic"
    $env:ANTHROPIC_AUTH_TOKEN       = $DEEPSEEK_API_KEY
    $env:ANTHROPIC_API_KEY          = ""
    $env:ANTHROPIC_MODEL            = "deepseek-v4-pro"
    $env:ANTHROPIC_SMALL_FAST_MODEL = "deepseek-v4-flash"
    claude @args
}

# ── deepseek-code ─────────────────────────────────────────────────────────────
# Kullanım : cd proje-dizini && deepseek-code
# Ne yapar : VS Code'daki Claude Code extension'ını DeepSeek'e bağlar.
#             Proje dizinine .vscode/settings.json oluşturur, VS Code'u yeniden
#             yükler. Bu projede VS Code Chat artık DeepSeek kullanır.
# Geri almak: deepseek-code-del
function deepseek-code {
    $vscodeDir    = Join-Path (Get-Location) ".vscode"
    $settingsFile = Join-Path $vscodeDir "settings.json"

    if (-not (Test-Path $vscodeDir)) {
        New-Item -ItemType Directory -Force $vscodeDir | Out-Null
    }

    $settings = @{
        "claudeCode.environmentVariables" = @{
            "CLAUDE_CONFIG_DIR"          = $DEEPSEEK_PROFILE
            "ANTHROPIC_BASE_URL"         = "https://api.deepseek.com/anthropic"
            "ANTHROPIC_AUTH_TOKEN"       = $DEEPSEEK_API_KEY
            "ANTHROPIC_API_KEY"          = ""
            "ANTHROPIC_MODEL"            = "deepseek-v4-pro"
            "ANTHROPIC_SMALL_FAST_MODEL" = "deepseek-v4-flash"
        }
    }

    $settings | ConvertTo-Json -Depth 5 | Out-File -FilePath $settingsFile -Encoding utf8
    Write-Host "DeepSeek aktif: $settingsFile"

    Save-VSCodeFiles
    Start-Sleep -Milliseconds 500
    code -r .
}

# ── deepseek-code-del ─────────────────────────────────────────────────────────
# Kullanım : cd proje-dizini && deepseek-code-del
# Ne yapar : deepseek-code tarafından oluşturulan .vscode klasörünü siler,
#             VS Code'u yeniden yükler. Extension varsayılan Claude'a döner.
# Not      : .vscode içinde başka ayarlarınız varsa onlar da silinir.
function deepseek-code-del {
    $vscodeDir = Join-Path (Get-Location) ".vscode"

    if (Test-Path $vscodeDir) {
        Remove-Item -Recurse -Force $vscodeDir
        Write-Host ".vscode klasörü silindi."
    } else {
        Write-Host ".vscode klasörü zaten yok."
    }

    Save-VSCodeFiles
    Start-Sleep -Milliseconds 500
    code -r .
}
