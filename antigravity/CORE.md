---
description: Merkezi Orkestratör & Beceri Kaydı. Görevleri uygun Becerilere, Modlara veya Korumalara yönlendirmek için otomatik olarak yüklenir.
---

# CORE.md - Beceri Orkestratörü

> Bu dosya tüm görevler için merkezi yönlendirme noktasıdır.
> Görev türüne göre uygun beceri(ler) belirlenir ve yüklenir.

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
    ├── CORE.md                  # Bu dosya (Merkezi orkestratör)
    ├── global_workflows/
        └── skills/              # Beceri (Skill) dosyaları
            ├── ultrathink/      # Derin düşünme
            ├── instruction-compliance/ # Talimat uyumu
            └── ...

~/.agent/                        # Antigravity IDE Kuralları & İş Akışları
├── rules/                       # 16 çalışma alanı kuralı
└── workflows/                   # 8 slash komut iş akışı
```

**Yer Tutucu Tanımları:**
| Yer Tutucu | Anlamı |
|------------|--------|
| `{ANTIGRAVITY_DIR}` | `~/.gemini/antigravity/` dizini |
| `{SKILLS_DIR}` | `~/.gemini/antigravity/global_workflows/skills/` dizini |
| `{AGENT_DIR}` | `~/.agent/` dizini |
| `{RULES_DIR}` | `~/.agent/rules/` dizini |
| `{WORKFLOWS_DIR}` | `~/.agent/workflows/` dizini |

---

# 📋 İçindekiler

1. [Beceri Referansı - Hangi Beceri Ne Zaman Kullanılır](#1-beceri-referansı---hangi-beceri-ne-zaman-kullanılır)
    - [1.1 🧠 UltraThink](#11-🧠-ultrathink---derin-düşünme-protokolü)
    - [1.2 🏗️ Architecture](#12-🏗️-architecture---sistem-tasarımı)
    - [1.3 🎨 Design System](#13-🎨-design-system---uiux-rehberi)
    - [1.4 💻 Backend](#14-💻-backend---sunucu-tarafı-geliştirme)
    - [1.5 📱 Mobile](#15-📱-mobile---çapraz-platform-uygulama)
    - [1.6 🧪 Testing](#16-🧪-testing---tdd-ve-test-stratejileri)
    - [1.7 🔍 Debugging](#17-🔍-debugging---hata-ayıklama)
    - [1.8 ♻️ Refactoring](#18-♻️-refactoring---kod-iyileştirme)
    - [1.9 🚀 Production Deployment](#19-🚀-production-deployment---devops)
    - [1.10 📁 Multi-File Sync](#110-📁-multi-file-sync---çoklu-dosya-değişiklikleri)
    - [1.11 📦 Dependency Management](#111-📦-dependency-management---paket-yönetimi)
    - [1.12 📝 Documentation](#112-📝-documentation---dokümantasyon)
    - [1.13 ⚡ Optimization](#113-⚡-optimization---sistem--akış-optimizasyonu)
    - [1.14 🔍 SEO Fundamentals](#114-🔍-seo-fundamentals---temel-ilkeler--e-e-a-t)
    - [1.15 ⚙️ SEO Technical](#115-⚙️-seo-technical---teknik-seo)
    - [1.16 ✍️ SEO Content](#116-✍️-seo-content---içerik-stratejisi)
    - [1.17 📍 SEO Local](#117-📍-seo-local---yerel-seo)
    - [1.18 🔗 SEO Off-Page](#118-🔗-seo-off-page---link-inşası)
    - [1.19 📊 SEO Analytics](#119-📊-seo-analytics---ölçümleme--raporlama)
    - [1.20 🤖 GEO Fundamentals](#120-🤖-geo-fundamentals---üretken-motor-optimizasyonu)
    - [1.21 ✍️ GEO Content](#121-✍️-geo-content---yapay-zeka-dostu-içerik)
    - [1.22 ⚙️ GEO Technical](#122-⚙️-geo-technical---yapay-zeka-teknik-optimizasyon)
    - [1.23 📊 GEO Analytics](#123-📊-geo-analytics---yapay-zeka-atıf-takib)
2. [Beceri Yükleme Protokolü](#2-beceri-yükleme-protokolü)
3. [Beceri Kombinasyonları](#3-beceri-kombinasyonları)
4. [Beceri Dizin Yapısı](#4-beceri-dizin-yapısı)
5. [Kritik Kurallar](#5-kritik-kurallar)

---

# 1. Beceri Referansı - Hangi Beceri Ne Zaman Kullanılır

> [!NOTE]
> **Dinamik Eşleştirme:** Kullanıcılar aşağıdaki örneklere tam uymayan komutlar verebilir.
> Bu tablolar **referans** içindir. Bir ajan olarak, kullanıcının isteğini analiz et ve
> en uygun beceriyi anlamsal olarak **dinamik bir şekilde çıkar**.
> Örneğin: "Bu API'de bir sorun var" → debugging + backend becerileri.

---

## 1.1 🧠 UltraThink - Derin Düşünme Protokolü
**Dosya:** [skills/ultrathink/ultrathink.md](skills/ultrathink/ultrathink.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Sokratik Gerçeklik Kontrolü** | "Kullanıcı ne istiyor? Ben ne yapıyorum?" | [**Bölüm 3:** Sokratik Gerçeklik Kontrolü](skills/ultrathink/ultrathink.md#socratic-reality-check-5-step-reality-check) |
| **Meta-Planlama** | "Bu karmaşık görevi nasıl parçalara ayırmalıyız?" | [**Bölüm 3:** Faz 0 - Meta-Planlama](skills/ultrathink/ultrathink.md#3-phase-0-meta-planning) |

---

## 1.2 🛡️ Instruction Compliance - Talimat Uyumu (ZORUNLU)
**Dosya:** [skills/instruction-compliance.md](skills/instruction-compliance.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Karmaşık Görev** | 3'ten fazla adım içeren her görevde | [**Bölüm 1:** Mirroring Protokolü](skills/instruction-compliance.md#1-mirroring-aynalama-protokolu) |
| **Dil Kontrolü** | "Türkçe konuş" kuralı için | [**Bölüm 3:** Dil Zorunluluğu](skills/instruction-compliance.md#3-dil-zorunlulugu-language-enforcement) |

---

## 1.3 🚀 Flutter Engineer - Geliştirme Uzmanı
**Ajan:** `/flutter-engineer` (Workflow)

| Senaryo | Örnek |
|---------|-------|
| **Proje Başlatma** | "Yeni bir proje kur" |
| **Test & Kalite** | "Testleri çalıştır", "Kod analizi yap" |
| **Build & Release** | "APK al", "Markete yükle" |

---

## 1.2 🏗️ Architecture - Sistem Tasarımı
**Dosya:** [skills/architecture.md](skills/architecture.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Mimari Seçimi** | "Monolit mi Mikroservis mi?" | [**Bölüm 3.1:** Monolit vs Mikroservis](skills/architecture.md#31-monolith-vs-microservices) |
| **Katmanlı Mimari** | "Katmanlı mimari uygula" | [**Bölüm 3.2:** Katmanlı Mimari](skills/architecture.md#32-layered-architecture) |
| **Veritabanı Seçimi** | "SQL vs NoSQL kararı" | [**Bölüm 5:** Veritabanı Seçimi](skills/architecture.md#5-database-selection) |

---

### Level 3: Product Department (Strateji)
*   Keywords: "rakip", "swot", "pazar analizi", "roadmap", "mvp"
*   **Agent:** `skills/studio/03-product/product-strategist.md` (veya Product Owner)

### Level 4: Design Floor (Tasarım) - UI/UX Rehberi
**Dosya:** [skills/design-system.md](skills/design-system.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Bileşen Tasarımı** | "Buton/Kart bileşeni oluştur" | [**Bölüm 5:** Bileşen Boyutlandırma](skills/design-system.md#5-component-sizing) |
| **Görsel Hiyerarşi** | "Gölge ve Z-index ayarla" | [**Bölüm 7:** Görsel Hiyerarşi](skills/design-system.md#7-visual-hierarchy) |
| **Renk & Tema** | "Karanlık mod ve kontrast" | [**Bölüm 4:** Renk Sistemi](skills/design-system.md#4-color-system) |

---

## 1.4 💻 Backend - Sunucu Tarafı Geliştirme
**Dosya:** [skills/backend.md](skills/backend.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **API Tasarımı** | "REST uyumlu rotalar oluştur" | [**Bölüm 4:** API Tasarım En İyi Uygulamaları](skills/backend.md#4-api-design-best-practices) |
| **Doğrulama** | "Girdiyi Zod ile doğrula" | [**Bölüm 5:** Girdi Doğrulama (Zod)](skills/backend.md#5-input-validation-zod) |
| **Güvenlik** | "Rate limit ve Helmet ekle" | [**Bölüm 6:** Güvenlik En İyi Uygulamaları](skills/backend.md#6-security-best-practices) |

---

## 1.5 📱 Mobile - Çapraz Platform Uygulama
**Dosya:** [global_workflows/skills/mobile.md](global_workflows/skills/mobile.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Kurulum & Proje** | "React Native veya Flutter projesi oluştur" | [**Bölüm 2.1 / 3.1:** Proje Yapısı](skills/mobile.md#2-react-native-best-practices) |
| **Performans** | "FlashList veya RepaintBoundary kullan" | [**Bölüm 2.3 / 3.3:** Performans Optimizasyonu](skills/mobile.md#23-performance-optimization) |

---

## 1.6 🧪 Testing - TDD ve Test Stratejileri
**Dosya:** [skills/testing.md](skills/testing.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Birim Test** | "Jest ile fonksiyonu test et" | [**Bölüm 2:** Birim Testi (Jest)](skills/testing.md#2-unit-testing-jest) |
| **E2E Test** | "Playwright ile giriş akışını test et" | [**Bölüm 4:** E2E Testi (Playwright)](skills/testing.md#4-e2e-testing-playwright) |
| **TDD Akışı** | "Red-Green-Refactor uygula" | [**Bölüm 6:** TDD](skills/testing.md#6-tdd-test-driven-development) |

---

## 1.7 🔍 Debugging - Hata Ayıklama Protokolü
**Dosya:** [skills/debugging/debugging.md](skills/debugging/debugging.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Tekrarlama (Replay)** | "Hatayı adım adım tekrarla" | [**Bölüm 2:** Faz 1 - Tekrarlama](skills/debugging/debugging.md#2-phase-1-reproduce) |
| **Kök Neden (RCA)** | "Problem neden oluştu?" | [**Bölüm 3/5:** Kök Neden Analizi](skills/debugging/debugging.md#3-phase-2-understand) |
| **İzolasyon** | "İkili arama ile alanı daralt" | [**Bölüm 4:** Faz 3 - İzole Etme](skills/debugging/debugging.md#4-phase-3-isolate) |

---

## 1.8 ♻️ Refactoring - Kod İyileştirme
**Dosya:** [skills/refactoring/refactoring.md](skills/refactoring/refactoring.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Zamanlama** | "Şu an refactor etmeli miyim?" | [**Bölüm 2:** Ne Zaman Refactor Edilir](skills/refactoring/refactoring.md#2-when-to-refactor) |
| **Kod Kokuları** | "Uzun metot veya tekrar" | [**Bölüm 5:** Kod Kokuları](skills/refactoring/refactoring.md#5-code-smells) |
| **DRY** | "Tekrarlayan kodu temizle" | [**Bölüm 4.5:** Tekrarı Kaldır](skills/refactoring/refactoring.md#45-remove-duplication-dry) |

---

## 1.9 🚀 Production Deployment - DevOps
**Dosya:** [skills/production-deployment.md](skills/production-deployment.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Hazırlık** | "Dağıtım öncesi listeyi kontrol et" | [**Bölüm 2:** Dağıtım Öncesi Liste](skills/production-deployment.md#2-pre-deployment-checklist) |
| **CI/CD** | "GitHub Actions ile pipeline kur" | [**Bölüm 3:** CI/CD Hattı](skills/production-deployment.md#3-cicd-pipeline) |

---

## 1.10 📁 Multi-File Sync - Çoklu Dosya Değişiklikleri
**Dosya:** [skills/multi-file-sync.md](skills/multi-file-sync.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Planlama** | "Bu değişiklik 20 dosyayı etkileyecek" | [**Bölüm 2:** Değişim Süreci](skills/multi-file-sync.md#2-multi-file-change-process) |
| **Global Yeniden Adlandırma** | "userId'yi customerId yap" | [**Bölüm 3.1:** IDE Refactoring](skills/multi-file-sync.md#31-ide-refactoring-rename-symbol) |

---

## 1.11 📦 Dependency Management - Paket Yönetimi
**Dosya:** [skills/dependency-management.md](skills/dependency-management.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Paket Seçimi** | "Bu kütüphaneyi kullanmalı mıyım?" | [**Bölüm 2:** Paket Ekleme Kararı](skills/dependency-management.md#2-package-addition-decision) |
| **Güvenlik** | "Güvenlik açıklarını tara" | [**Bölüm 3:** Güvenlik Denetimi](skills/dependency-management.md#3-security-auditing) |

---

## 1.12 📝 Documentation - Dokümantasyon
**Dosya:** [skills/documentation/documentation.md](skills/documentation/documentation.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **README** | "Proje giriş dokümanı hazırla" | [**Bölüm 2:** README En İyi Uygulamaları](skills/documentation/documentation.md#2-readme-best-practices) |
| **Kod Yorumları** | "JSDoc/TSDoc formatında yorum yaz" | [**Bölüm 3:** Kod Dokümantasyonu](skills/documentation/documentation.md#3-code-documentation) |

---

## 1.13 ⚡ Optimization - Sistem & Akış Optimizasyonu
**Dosya:** [skills/optimization.md](skills/optimization.md)

| Senaryo | Örnek | İlgili Bölüm |
|---------|-------|--------------|
| **Darboğaz Tespiti** | "Sistem neden yavaş?" | [**Bölüm 2:** Darboğaz Tespiti](skills/optimization.md#2-bottleneck-identification-bottleneck-identification) |
| **İyileştirme Döngüsü** | "Ölç → Analiz Et → İyileştir" | [**Bölüm 7:** Sistematik İyileştirme Döngüsü](skills/optimization.md#7-systematic-improvement-loop) |

---

## 1.14 - 1.23 SEO & GEO Becerileri
*(Listelerin çevirisi benzer mantıkla yapılmalıdır. Yer kazanmak için başlıklar İngilizce dosya isimleriyle eşleşecek şekilde bırakılmıştır)*

---

# 2. Beceri Yükleme Protokolü

## 2.1 Adım 1: Hassas Görev Analizi
```
Kullanıcı görevini analiz et (ör: "Button bileşeni tasarla")
    │
    ▼
CORE.md tablolarından BECERİ ve İLGİLİ BÖLÜMÜ bul
(ör: Beceri=design-system.md, Bölüm=#5 Bileşen Boyutlandırma)
    │
    ▼
Tüm beceri dosyasını OKUMA ❌
SADECE ilgili bölümü ve kurallarını oku ✅
```

## 2.2 Adım 2: Seçici Okuma Protokolü

**Tüm dosyayı okumak yerine:**

1. **Hedefi Belirle:** İlgili başlığı bul (ör: `# 5. Component Sizing`)
2. **Konumu Bul:** Dosyadaki satır numarasını bul (`view_file_outline` veya `grep_search` kullanarak)
3. **Kısmi Oku:** Sadece o bölümü ve alt maddelerini oku (`view_file` başlangıç-bitiş satırı ile)

> [!TIP]
> Bu yöntem bağlam (context) limitini korur ve odağı artırır.

## 2.3 Adım 3: Beceri Bulunamadı
```
⚠️ HATA: "[skill-name].md" beceri dosyası bulunamadı.

Lütfen aşağıdakilerden birini yapın:
1. Beceri dosyasının yolunu gösterin
2. Beceri dosyasını oluşturun

Beceriler olmadan işe BAŞLANAMAZ.
```

---

# 3. Beceri Kombinasyonları

Karmaşık görevler birden fazla beceri gerektirebilir:

| Senaryo | Beceri Kombinasyonu | Yükleme Sırası |
|---------|---------------------|----------------|
| **Karmaşık Özellik** | ultrathink + instruction-compliance | 1→2 |
| **Yeni Flutter Projesi** | /flutter-engineer (Workflow) | - |
| **Mağaza Hazırlığı** | /store-policy + /flight-check | - |
| **Critical Bug Fix** | ultrathink + debugging | 1→2 |

---

# 4. Beceri Dizin Yapısı

```
{WORKFLOWS_ROOT}/
├── GEMINI.md           ← Global kurallar
├── CORE.md             ← Bu dosya (Merkezi orkestratör)
└── skills/
    ├── ultrathink.md           ✅ Derin düşünme
    ├── architecture.md         ✅ Sistem tasarımı
    ├── design-system.md        ✅ UI/UX rehberi
    ├── backend.md              ✅ Sunucu tarafı geliştirme
    ├── mobile.md               ✅ Çapraz platform mobil
    ├── testing.md              ✅ TDD ve test stratejileri
    ├── debugging.md            ✅ Sorun giderme
    ├── refactoring.md          ✅ Kod iyileştirme
    ├── production-deployment.md ✅ DevOps/CI-CD
    ├── multi-file-sync.md      ✅ Çoklu dosya değişimi
    ├── dependency-management.md ✅ Paket yönetimi
    ├── documentation.md        ✅ Dokümantasyon
    ├── optimization.md         ✅ Sistem & Akış Optimizasyonu
    └── ... (SEO/GEO Becerileri)
```

---

# 5. Kritik Kurallar

> [!CAUTION]
> **Becerileri yüklemeden işe BAŞLAMA!**

> [!WARNING]
> **Beceri bulunamazsa DUR!**
> Kullanıcıdan dosya yolu iste veya beceri oluşturmayı talep et.

> [!IMPORTANT]
> **GEMINI.md kuralları her zaman geçerlidir!**
> ESLint kontrolü, 2x kod incelemesi yapılmalıdır.

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.3 (TR Çeviri)
