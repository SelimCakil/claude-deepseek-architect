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
| VS Code | Güncel | [code.visualstudio.com](https://code.visualstudio.com) |
| DeepSeek API key | — | [platform.deepseek.com](https://platform.deepseek.com) |

---

## Terminal Komutları

Bu komutlar PowerShell profiline eklenir ve her terminalda hazır gelir.  
Kaynak: [`powershell-profile.ps1`](./powershell-profile.ps1)

### `deepseek`

```powershell
deepseek
```

**Ne yapar:** Terminalde Claude Code'u açar, ancak tüm API çağrıları DeepSeek'e gider.  
Claude kotanız harcanmaz. Model olarak `deepseek-v4-pro` kullanılır.

**Nasıl çalışır:** `ANTHROPIC_BASE_URL` ortam değişkenini DeepSeek endpoint'ine
(`https://api.deepseek.com/anthropic`) yönlendirir ve ayrı bir config profili kullanır.
Claude Code arayüzü aynı kalır, sadece arka plandaki model değişir.

---

### `deepseek-code`

```powershell
cd proje-dizini
deepseek-code
```

**Ne yapar:** VS Code'daki Claude Code extension'ını DeepSeek'e bağlar.  
Proje dizinine `.vscode/settings.json` oluşturur ve VS Code'u yeniden yükler.
Bu projede VS Code Chat (Ctrl+Shift+P → Claude) artık DeepSeek kullanır.

**Kapsamı:** Sadece bu proje — diğer projeleri etkilemez.

---

### `deepseek-code-del`

```powershell
cd proje-dizini
deepseek-code-del
```

**Ne yapar:** `deepseek-code` tarafından oluşturulan `.vscode` klasörünü siler,
VS Code'u yeniden yükler. Extension varsayılan Claude'a geri döner.

> **Not:** `.vscode` içinde başka ayarlarınız varsa onlar da silinir.

---

## Kurulum

### Windows (Otomatik)

```powershell
.\setup.ps1
```

Script şunları yapar:
1. `CLAUDE.md` dosyasını `~/.claude/CLAUDE.md` konumuna kopyalar
2. `houtini-lm` MCP sunucusunu API key ile yapılandırır
3. Claude Code izinlerini ayarlar
4. PowerShell profil komutlarını kurar (`deepseek`, `deepseek-code`, `deepseek-code-del`)

### Linux / macOS (Otomatik)

```bash
bash setup.sh
```

### Manuel Kurulum

**1. CLAUDE.md — Global mimar talimatları**

```powershell
# Windows
Copy-Item CLAUDE.md "$env:USERPROFILE\.claude\CLAUDE.md"
```

```bash
# Linux/macOS
cp CLAUDE.md ~/.claude/CLAUDE.md
```

**2. MCP Sunucu — houtini-lm**

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

**3. PowerShell Profil Komutları**

`powershell-profile.ps1` içeriğini PowerShell profilinize ekleyin:

```powershell
# Profil dosyasını aç
notepad $PROFILE

# Veya doğrudan ekle (API key'i doldurarak)
Get-Content .\powershell-profile.ps1 >> $PROFILE
```

---

## Kullanım Senaryoları

| Senaryo | Komut |
|---|---|
| Terminal'de DeepSeek ile çalış | `deepseek` |
| VS Code'da DeepSeek'e geç | `deepseek-code` |
| VS Code'u varsayılan Claude'a döndür | `deepseek-code-del` |
| MD dosyası analizi + paralel görev | `claude` → MD ver |
| Sınırlı kod görevi (kota tasarrufu) | `claude` → Claude DeepSeek'e devreder |

---

## DeepSeek MCP Araçları (Claude içinden)

Claude, `claude` komutuyla açıldığında aşağıdaki araçlarla DeepSeek'e görev devreder:

| Araç | Ne Zaman |
|---|---|
| `code_task` | Kod üretme, düzenleme, review |
| `chat` | Brainstorm, açıklama, soru-cevap |
| `code_task_files` | Dosya tabanlı kod görevleri |
| `discover` | Model durumu ve hız kontrolü |

---

## Örnek

`examples/ornek-gorev.md` dosyasını Claude'a verin ve paralel görev dağıtımını canlı görün.
