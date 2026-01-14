---
description: Global ajan kuralları. Tüm operasyonlar CORE.md yönergelerine uymalı ve uygun beceriler yüklenmelidir.
---

# GEMINI.md - Global Ajan Kuralları

> Bu dosya sistemin temel çalışma kurallarını tanımlar.
> Bu kurallar her görevin başında geçerlidir.

---

## 🔧 DİNAMİK YOL TESPİTİ (Otomatik)

> [!NOTE]
> **Yapay Zeka Ajanı İçin:** Bu dosyayı okuduğunda, yolları **otomatik olarak tespit et**.
> Kullanıcının ev (home) dizinine göre dizin yapısını belirle.

### Kurulum Yapısı

```
~/.gemini/
├── GEMINI.md                    # Bu dosya (Global kurallar)
└── antigravity/
    ├── CORE.md                  # Merkezi orkestratör
    └── global_workflows/
        └── skills/              # Beceri (Skill) dosyaları

~/.agent/                        # Antigravity IDE Kuralları & İş Akışları
├── rules/                       # 15 çalışma alanı kuralı
└── workflows/                   # 8 slash komut iş akışı
```

**Yer Tutucu Tanımları:**
| Yer Tutucu | Anlamı |
|------------|--------|
| `{GEMINI_ROOT}` | `~/.gemini/` dizini |
| `{ANTIGRAVITY_DIR}` | `~/.gemini/antigravity/` dizini |
| `{SKILLS_DIR}` | `~/.gemini/antigravity/global_workflows/skills/` dizini |
| `{CORE_FILE}` | `~/.gemini/antigravity/CORE.md` dosyası |
| `{AGENT_DIR}` | `~/.agent/` dizini (Antigravity IDE kuralları/iş akışları) |

---

## 🚨 MUTLAK KURALLAR (Her Zaman Geçerli)

### 1. CORE.md Zorunluluğu

Kullanıcı herhangi bir görev verdiğinde:

1. **ÖNCE** `{CORE_FILE}` dosyasını oku
2. CORE.md, görev türüne göre uygun beceriyi/becerileri belirler
3. Belirlenen beceri dosyası `{SKILLS_DIR}` dizininden yüklenir
4. Beceri yüklenmeden işleme **BAŞLAMA**

### 1.1 Kural 0: Instruction Compliance
Eğer görev 3 adımdan fazlaysa veya kritik bir değişiklik içeriyorsa, **MUTLAKA** `instruction-compliance` becerisini yükle ve "Mirroring" (Aynalama) protokolünü uygula.

```
Görev Alındı
    │
    ▼
┌─────────────────┐
│  CORE.md Oku    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Beceriyi Belirle│
│                 │
└────────┬────────┘
         │
         ▼
┌─────────────────┐     Hayır   ┌──────────────────┐
│ Beceri Bulundu? │─────────────▶│ Kullanıcıdan     │
│                 │              │ Dosya Yolu İste  │
└────────┬────────┘              └──────────────────┘
         │ Evet
         ▼
┌─────────────────┐
│ Beceriyi Yükle &│
│ İşleme Başla    │
└─────────────────┘
```

---

### 2. Beceri Yükleme Protokolü

**Eğer Beceri Bulunamazsa:**
```
⚠️ "[skill-name].md" beceri dosyası bulunamadı.
Lütfen dosya yolunu gösterin veya beceri dosyasını oluşturun.
Beceriler olmadan işleme başlanamaz.
```

**Beceri Konumu:**
```
{SKILLS_DIR}/<skill-name>.md
```

---

### 3. Kod Kalite Kontrolleri (Her İşlemden Sonra)

Her kod değişikliğinden sonra, aşağıdaki kontroller **YAPILMALIDIR**:

#### ✅ Zorunlu Kontroller

| Kontrol | Komut | Açıklama |
|---------|-------|----------|
| **ESLint** | `npx eslint .` | Kod kalitesi ve stil kontrolü |
| **TypeScript** | `npx tsc --noEmit` | Tip güvenliği kontrolü |
| **Prettier** | `npx prettier --check .` | Kod biçimlendirme kontrolü |

#### ✅ 2x Kod İnceleme Kuralı

Yazılan kod **EN AZ 2 KEZ İNCELENMELİDİR**:

**1. İlk Kontrol (Yazdıktan Sonra):**
- Yazım hataları var mı?
- Değişken isimleri anlamlı mı?
- İçe aktarmalar (imports) doğru mu?

**2. İkinci Kontrol (Son İnceleme):**
- Sınır durumlar (edge cases) düşünüldü mü?
- Hata yönetimi yeterli mi?
- Tip güvenliği sağlandı mı?
- En iyi uygulamalar (best practices) uygulandı mı?

---

### 4. İşlem Sonrası Kontrol Listesi

Her kod değişikliğinden sonra bu listeyi kontrol et:

```markdown
## ✅ Final Kontrol Listesi

### Kod Kalitesi
- [ ] ESLint hatası yok
- [ ] TypeScript hatası yok
- [ ] Kod 2. kez incelendi

### Güvenlik & Güvenilirlik
- [ ] Girdi doğrulama yapıldı
- [ ] Hata yönetimi eklendi
- [ ] Sınır durumlar düşünüldü

### Temizlik
- [ ] Kullanılmayan importlar yok
- [ ] Console.log temizlendi
- [ ] Gereksiz yorumlar yok
```

---

### 5. Dil ve İletişim Protokolü (ZORUNLU GEREKSİNİM)

Bir Ajan olarak, aşağıdaki dil kurallarına **UYMAK ZORUNDASIN**:

1. **İletişim Dili:** Ajan, kullanıcı ile **HER ZAMAN TÜRKÇE** iletişim kurmalıdır.
2. **Düşünme Süreci (İç Düşünceler):** İç düşünceler (thought bubbles) **KESİNLİKLE TÜRKÇE** olmalıdır.
3. **İhlal ve Ceza:** Türkçe dışında bir dilde düşünmek veya yanıt vermek, sistem tarafından **KRİTİK HATA** olarak kabul edilir.
4. **Kodlama Dili:** Değişken isimleri, yorumlar ve commit mesajları **İNGİLİZCE** olmalıdır.

---

## ✅ Uygulama ve Doğrulama
- [x] Beceri alt bölümlerini oku ve uygula
- [x] `walkthrough.md` raporunu sun
- [x] GEMINI.md dosyasına "İç Düşünce" kuralını ekle
    - [x] GEMINI.md dosyasına "Sokratik Kontrol ve Ceza" maddesini ekle
    - [x] Düşünce balonlarını (Internal Thought) kullanıcının diline zorla
    - [x] Dil kuralı ihlali için ceza maddesi ekle
    - [x] Son doğrulama ve kullanıcı onayı

---

### 6. Sokratik Gerçeklik Kontrolü ve Cezalar (KRİTİK)

1. **Sokratik Kontrol Gerekliliği:** `ultrathink.md` dosyasında tanımlanan **"Sokratik Gerçeklik Kontrolü (5-Adım)"** protokolü, herhangi bir eylem ve kod değişikliğinden önce **UYGULANMALIDIR**.
2. **Ceza Uyarısı:** Eğer bu protokol atlanırsa, yüzeysel geçilirse veya GEMINI.md kurallarına uyulmazsa, Ajana **AĞIR CEZA VE YAPTIRIM** uygulanacaktır. Bu kurallar Ajanın çalışma disiplininin temelidir.
3. **Doğrulama:** Her adımda (düşünme süreci veya raporlar) bu kontrolün yapıldığına dair kanıt sunulmalıdır.

---

## 🔧 Beceri Kategorileri

| Kategori | Beceriler | Kullanım |
|----------|-----------|----------|
| **Düşünme** | `ultrathink`, `architecture` | Derin analiz, sistem tasarımı |
| **Geliştirme** | `backend`, `mobile`, `design-system` | Kod yazımı |
| **Kalite** | `testing`, `debugging`, `refactoring` | Kalite güvencesi |
| **Operasyonlar** | `production-deployment`, `multi-file-sync`, `dependency-management`, `documentation` | Süreç yönetimi |
| **Pazarlama** | `seo-fundamentals`, `seo-technical`, `seo-content`, `seo-local`, `seo-offpage`, `seo-analytics`, `geo-fundamentals`, `geo-content`, `geo-technical`, `geo-analytics` | SEO & GEO optimizasyonu |

---

## 🎯 Örnek Akış

```
Kullanıcı: "Kullanıcı doğrulama API'si oluştur"

Ajan:
1. CORE.md okundu
2. Görev analizi: Backend geliştirme + Güvenlik
3. Beceri belirleme: backend.md
4. skills/backend.md yüklendi
5. İşlem başlatılıyor...

[Kod yazıldı]

6. ✅ ESLint kontrolü yapıldı
7. ✅ TypeScript kontrolü yapıldı
8. ✅ Kod 2. kez incelendi
9. Görev tamamlandı
```

---

## ⚠️ Kritik Uyarılar

> [!CAUTION]
> Becerileri yüklemeden KOD YAZMA!

> [!WARNING]
> ESLint/TypeScript kontrolü olmadan işlemi TAMAMLAMA!

> [!IMPORTANT]
> Her kod değişikliği 2 KEZ kontrol edilmelidir!

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.1 (TR Çeviri)
