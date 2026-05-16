# Claude Code + DeepSeek Mimar Kurulumu

Claude Code'u **mimar** olarak, DeepSeek'i ise **developer** olarak kullanan bir iş akışı.  
Claude görevleri analiz eder, bağımsız parçaları DeepSeek'e paralel olarak devreder, koordinasyonu üstlenir.

---

## Nasıl Çalışır?

```
Sen → MD dosyası ver → Claude analiz eder
                              ↓
              Paralel mi?    Sıralı mı?
                 ↓                ↓
        DeepSeek A  DeepSeek B   Adım adım
        (Frontend)  (Backend)
                 ↓
         Claude çıktıları birleştirir → Sana sunar
```

- **Claude (Sonnet/Opus):** Mimar — analiz, karar, review, koordinasyon
- **DeepSeek:** Developer — kod üretme, test yazma, boilerplate

---

## Gereksinimler

| Araç | Versiyon | Link |
|---|---|---|
| Node.js | 18+ | [nodejs.org](https://nodejs.org) |
| Claude Code | Güncel | [claude.ai/code](https://claude.ai/code) |
| DeepSeek API key | — | [platform.deepseek.com](https://platform.deepseek.com) |

---

## Kurulum

### Windows

```powershell
.\setup.ps1
```

### Linux / macOS

```bash
bash setup.sh
```

Script şunları yapar:
1. `CLAUDE.md` dosyasını `~/.claude/CLAUDE.md` konumuna kopyalar
2. `houtini-lm` MCP sunucusunu API key ile yapılandırır
3. Claude Code izinlerini ayarlar

---

## Manuel Kurulum

### 1. CLAUDE.md

`CLAUDE.md` dosyasını global Claude konumuna kopyalayın:

```powershell
# Windows
Copy-Item CLAUDE.md "$env:USERPROFILE\.claude\CLAUDE.md"
```

```bash
# Linux/macOS
cp CLAUDE.md ~/.claude/CLAUDE.md
```

### 2. MCP Sunucu Ayarları

`~/.claude/settings.json` dosyasına ekleyin:

```json
{
  "mcpServers": {
    "houtini-lm": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@houtini/lm"],
      "env": {
        "HOUTINI_LM_ENDPOINT_URL": "https://api.deepseek.com",
        "HOUTINI_LM_API_KEY": "YOUR_DEEPSEEK_API_KEY"
      }
    }
  }
}
```

---

## Kullanım

1. Herhangi bir klasörde terminali açın
2. `claude` yazın
3. Bir MD dosyası verin veya içeriğini yapıştırın
4. Claude otomatik olarak:
   - Görevleri analiz eder
   - Bağımsız parçaları paralel olarak DeepSeek'e devreder
   - Sonuçları birleştirip size sunar

**Paralel yap" demenize gerek yok — mimar kararı kendisi verir.**

---

## DeepSeek Araçları

| Araç | Ne Zaman |
|---|---|
| `code_task` | Kod üretme, düzenleme, review |
| `chat` | Brainstorm, açıklama, soru-cevap |
| `code_task_files` | Dosya tabanlı kod görevleri |
| `discover` | Model durumu ve hız kontrolü |

---

## Örnek

`examples/ornek-gorev.md` dosyasını Claude'a verin ve paralel görev dağıtımını canlı görün.
