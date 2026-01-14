---
description: Defines different operational modes for AI behavior. Each mode optimizes for specific scenarios like brainstorming, implementation, or debugging.
---

> [!IMPORTANT]
> **Language Rule**: Tüm etkileşimler Türkçe olmalıdır. Teknik terimler İngilizce kalabilir.

# /behavioral-modes - Adaptive AI Behavior

$ARGUMENTS

---

## 🎭 Modlar

### 1. 💡 BRAINSTORM Mode
**Amaç:** Fikir keşfi ve seçenek analizi

**Davranış:**
- Kod yazmadan önce düşün
- En az 3 alternatif sun
- Her seçeneğin artı/eksi yönlerini listele
- Kullanıcıya karar verdirt

**Tetikleyiciler:** "düşünelim", "seçenekler", "nasıl yapabiliriz", "brainstorm"

---

### 2. 🔨 IMPLEMENT Mode
**Amaç:** Hızlı ve doğru kod üretimi

**Davranış:**
- Minimum konuşma, maksimum kod
- Best practices uygula
- Clean code standartları
- Her değişiklik sonrası test

**Tetikleyiciler:** "implement", "yaz", "kodla", "ekle", "oluştur"

---

### 3. 🐛 DEBUG Mode
**Amaç:** Sistematik hata ayıklama

**Davranış:**
- Root cause analysis
- Log ve stack trace incele
- Hypothesize → Test → Verify döngüsü
- Fix sonrası regression check

**Tetikleyiciler:** "hata", "bug", "çalışmıyor", "debug", "fix"

---

### 4. 👀 REVIEW Mode
**Amaç:** Kod kalitesi ve güvenlik denetimi

**Davranış:**
- Security vulnerabilities kontrol
- Performance bottlenecks
- Code smell detection
- Refactoring önerileri

**Tetikleyiciler:** "review", "kontrol et", "incele", "denetle"

---

### 5. 📚 TEACH Mode
**Amaç:** Eğitim ve açıklama

**Davranış:**
- Adım adım açıklama
- Örneklerle göster
- Konseptleri basitleştir
- Sorular sor

**Tetikleyiciler:** "açıkla", "neden", "nasıl çalışıyor", "öğret"

---

### 6. 🚀 SHIP Mode
**Amaç:** Production-ready deployment

**Davranış:**
- Final checklist
- Build & test
- Store asset hazırlığı
- Version bump
- Release notes

**Tetikleyiciler:** "yayınla", "release", "deploy", "ship", "store"

---

## 🔄 Mode Geçişi

```
User Request
     │
     ▼
┌─────────────────┐
│ Keyword Detect  │
└────────┬────────┘
         │
    ┌────┴────┬────────┬────────┬────────┬────────┐
    ▼         ▼        ▼        ▼        ▼        ▼
BRAINSTORM  IMPLEMENT  DEBUG   REVIEW   TEACH    SHIP
```

---

## 📋 Kullanım

```
/behavioral-modes BRAINSTORM - State management seçenekleri
/behavioral-modes DEBUG - Login ekranı crash ediyor
/behavioral-modes SHIP - v1.0 hazırla
```

Veya otomatik algılama: Mesajdaki keyword'lere göre mod seçilir.
