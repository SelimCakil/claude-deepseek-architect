#!/bin/bash
# Claude Code + DeepSeek Mimar Kurulum Scripti (Linux/macOS)
# Çalıştırmak için: bash setup.sh

set -e

echo ""
echo "=== Claude Code + DeepSeek Mimar Kurulumu ==="
echo ""

# 1. Node.js kontrolü
if ! command -v node &> /dev/null; then
    echo "[HATA] Node.js bulunamadı. https://nodejs.org adresinden kurun."
    exit 1
fi

# 2. Claude Code kontrolü
if ! command -v claude &> /dev/null; then
    echo "[HATA] Claude Code bulunamadı. https://claude.ai/code adresinden kurun."
    exit 1
fi

# 3. DeepSeek API key al
if [ -z "$DEEPSEEK_API_KEY" ]; then
    echo "DeepSeek API anahtarınızı girin (https://platform.deepseek.com):"
    read -r DEEPSEEK_API_KEY
    if [ -z "$DEEPSEEK_API_KEY" ]; then
        echo "[HATA] API key boş olamaz."
        exit 1
    fi
fi

CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

# 4. CLAUDE.md kopyala
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_CLAUDE="$CLAUDE_DIR/CLAUDE.md"

if [ -f "$TARGET_CLAUDE" ]; then
    echo ""
    echo "Mevcut CLAUDE.md bulundu: $TARGET_CLAUDE"
    read -rp "Üzerine yazılsın mı? (e/h): " overwrite
    if [ "$overwrite" = "e" ]; then
        cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_CLAUDE"
        echo "[OK] CLAUDE.md güncellendi."
    else
        echo "CLAUDE.md atlandı."
    fi
else
    cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_CLAUDE"
    echo "[OK] CLAUDE.md kopyalandı."
fi

# 5. settings.json oluştur
SETTINGS_FILE="$CLAUDE_DIR/settings.json"

cat > "$SETTINGS_FILE" << EOF
{
  "theme": "dark-daltonized",
  "mcpServers": {
    "houtini-lm": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@houtini/lm"],
      "env": {
        "HOUTINI_LM_ENDPOINT_URL": "https://api.deepseek.com",
        "HOUTINI_LM_API_KEY": "$DEEPSEEK_API_KEY"
      }
    }
  }
}
EOF

echo "[OK] settings.json oluşturuldu."

# 6. Ön yükleme
echo ""
read -rp "houtini-lm paketi önceden indirilsin mi? (e/h, önerilir): " preload
if [ "$preload" = "e" ]; then
    echo "İndiriliyor..."
    npx -y @houtini/lm --help > /dev/null 2>&1 || true
    echo "[OK] houtini-lm hazır."
fi

echo ""
echo "=== Kurulum tamamlandı! ==="
echo ""
echo "Herhangi bir klasörde 'claude' yazarak başlayabilirsiniz."
echo "MD dosyası verdiğinizde Claude otomatik analiz edip paralel görev dağıtımı yapacak."
echo ""
