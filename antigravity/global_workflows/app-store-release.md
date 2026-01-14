---
name: app-store-release
description: App Store ve Play Store mağaza yayın rehberi. Submission süreci, screenshot hazırlama, review guidelines ve rejection handling.
metadata:
  skillport:
    category: operations
    tags:
      - app-store
      - play-store
      - release
      - mobile
      - flutter
---

# App Store Release Becerisi

> iOS App Store ve Android Google Play Store'a uygulama yayınlama rehberi.
> Submission süreci, asset hazırlama ve review sürecini yönetme.

---

# 📋 İçindekiler

1. [Release Öncesi Checklist](#1-release-öncesi-checklist)
2. [iOS App Store](#2-ios-app-store)
3. [Android Play Store](#3-android-play-store)
4. [Screenshot ve Görseller](#4-screenshot-ve-görseller)
5. [Store Metadata](#5-store-metadata)
6. [Test Süreçleri](#6-test-süreçleri)
7. [Review Guidelines](#7-review-guidelines)
8. [Rejection Handling](#8-rejection-handling)
9. [Post-Release](#9-post-release)

---

# 1. Release Öncesi Checklist

```markdown
## Production Release Checklist

### Kod Kalitesi
- [ ] flutter analyze hatasız
- [ ] Tüm testler geçiyor
- [ ] Debug kodları temizlendi (print, debugPrint)
- [ ] API endpoint'ler production'a işaret ediyor
- [ ] Feature flag'ler doğru ayarlandı

### Güvenlik
- [ ] Obfuscation aktif
- [ ] API key'ler güvende (.env veya secret manager)
- [ ] SSL Pinning aktif (varsa)
- [ ] ProGuard/R8 kuralları test edildi

### Assets
- [ ] App icon tüm boyutlarda hazır
- [ ] Splash screen yapılandırıldı
- [ ] Screenshot'lar hazır (tüm cihazlar)
- [ ] Feature graphic (Play Store)

### Legal
- [ ] Privacy Policy URL hazır
- [ ] Terms of Service URL hazır
- [ ] GDPR/KVKK uyumluluğu
- [ ] Gerekli lisans bilgileri
```

---

# 2. iOS App Store

## 2.1 App Store Connect Setup

```markdown
## App Store Connect Checklist

### App Bilgileri
- [ ] Bundle ID: com.company.appname
- [ ] SKU: benzersiz tanımlayıcı
- [ ] Primary Language
- [ ] App Name (30 karakter)
- [ ] Subtitle (30 karakter)

### Kategori
- [ ] Primary Category
- [ ] Secondary Category (opsiyonel)

### Privacy
- [ ] Privacy Policy URL
- [ ] App Privacy Details (data collection)

### Age Rating
- [ ] Content descriptions questionnaire dolduruldu
```

## 2.2 iOS Build Hazırlama

```bash
# 1. Version ve build number güncelle
# pubspec.yaml: version: 1.0.0+1

# 2. iOS build oluştur
flutter build ios --release

# 3. Xcode'da Archive
open ios/Runner.xcworkspace
# Product > Archive

# 4. App Store Connect'e yükle
# Organizer > Distribute App > App Store Connect
```

## 2.3 iOS Screenshot Boyutları

| Cihaz | Boyut (px) | Zorunlu |
|-------|------------|---------|
| iPhone 6.7" | 1290 x 2796 | ✅ |
| iPhone 6.5" | 1284 x 2778 | ✅ |
| iPhone 5.5" | 1242 x 2208 | ✅ |
| iPad Pro 12.9" | 2048 x 2732 | Tablet varsa |
| iPad Pro 11" | 1668 x 2388 | Tablet varsa |

---

# 3. Android Play Store

## 3.1 Play Console Setup

```markdown
## Play Console Checklist

### App Bilgileri
- [ ] Package name: com.company.appname
- [ ] Default language
- [ ] App name (50 karakter)
- [ ] Short description (80 karakter)
- [ ] Full description (4000 karakter)

### Category
- [ ] App category
- [ ] Tags

### Contact Details
- [ ] Developer email
- [ ] Phone number (opsiyonel)
- [ ] Website

### Privacy
- [ ] Privacy policy URL
- [ ] Data safety form dolduruldu
```

## 3.2 Android Build Hazırlama

```bash
# 1. Keystore oluştur (ilk seferde)
keytool -genkey -v -keystore ~/upload-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias upload

# 2. key.properties oluştur
cat > android/key.properties << EOF
storePassword=<password>
keyPassword=<password>
keyAlias=upload
storeFile=/path/to/upload-keystore.jks
EOF

# 3. AAB (App Bundle) oluştur
flutter build appbundle --release --obfuscate \
  --split-debug-info=build/debug-info

# 4. APK oluştur (test için)
flutter build apk --release --obfuscate \
  --split-debug-info=build/debug-info
```

## 3.3 Android Screenshot Boyutları

| Tip | Boyut (px) | Zorunlu |
|-----|------------|---------|
| Phone | 1080 x 1920 - 1440 x 2560 | 2-8 adet ✅ |
| 7" Tablet | 1200 x 1920 | Tablet varsa |
| 10" Tablet | 1600 x 2560 | Tablet varsa |
| Feature Graphic | 1024 x 500 | ✅ |
| App Icon | 512 x 512 | ✅ |

---

# 4. Screenshot ve Görseller

## 4.1 Screenshot Best Practices

```markdown
## Etkili Screenshot İpuçları

### İçerik
- Uygulamanın ana özelliklerini göster
- İlk 2 screenshot en önemli (görünür)
- Kısa, açıklayıcı metin ekle
- Branding tutarlılığı

### Teknik
- Gerçek cihaz mockup'ları kullan
- Yüksek çözünürlük
- Tutarlı arka plan
- Device frame (mockup) kullanılabilir

### Sıralama
1. En çarpıcı özellik
2. Ana kullanım senaryosu
3. Benzersiz özellikler
4. Sosyal kanıt (varsa)
```

## 4.2 Screenshot Araçları

```markdown
## Önerilen Araçlar

- **Figma**: Mockup tasarımı
- **Rotato**: 3D device mockups
- **AppMockUp**: Hızlı mockup
- **Screenshot Pro**: Otomatik oluşturma
- **fastlane screengrab**: Otomatik capture
```

---

# 5. Store Metadata

## 5.1 App Description Template

```markdown
## App Store Description Template

### Kısa Açıklama (80 karakter)
[Ana değer önerisi - tek cümle]

### Tam Açıklama
[Problem ve çözüm - 2-3 cümle]

[Ana Özellikler]
• Özellik 1: Kısa açıklama
• Özellik 2: Kısa açıklama
• Özellik 3: Kısa açıklama

[Nasıl Çalışır - opsiyonel]
1. Adım 1
2. Adım 2
3. Adım 3

[Neden Biz]
- Avantaj 1
- Avantaj 2

[CTA]
Hemen indirin ve [fayda]!

[İletişim]
Sorularınız için: support@example.com
```

## 5.2 Keywords (iOS)

```markdown
## Keyword Stratejisi

### Kurallar
- 100 karakter limiti
- Virgülle ayır (boşluk yok)
- App name'deki kelimeleri tekrarlama
- Rakip isimlerini kullanma

### Örnek
puzzle,brain,game,logic,mind,training,fun,free
```

---

# 6. Test Süreçleri

## 6.1 iOS TestFlight

```markdown
## TestFlight Checklist

### Internal Testing
- [ ] Build yüklendi
- [ ] Internal testers eklendi (25 kişiye kadar)
- [ ] Test notes yazıldı

### External Testing (Beta)
- [ ] Beta App Review submitted
- [ ] External testers eklendi (10,000 kişiye kadar)
- [ ] Public link oluşturuldu (opsiyonel)
```

## 6.2 Android Test Tracks

```markdown
## Play Console Test Tracks

### Internal Testing
- En hızlı (dakikalar içinde)
- 100 tester'a kadar

### Closed Testing (Alpha)
- Email ile davet
- Unlimited testers
- Production-like deneyim

### Open Testing (Beta)
- Herkes katılabilir
- Store'da "Beta" etiketi
- Pre-launch report

### Production Rollout
- Staged rollout önerilir (%10 → %50 → %100)
```

---

# 7. Review Guidelines

## 7.1 Apple Review Guidelines

```markdown
## En Sık Red Nedenleri

### Performance
- [ ] App çökmüyor
- [ ] Tüm özellikler çalışıyor
- [ ] Login gerektiriyorsa demo hesap sağla

### Design
- [ ] iOS Human Interface Guidelines uyumu
- [ ] iPad desteği (Universal app ise)

### Legal
- [ ] Privacy policy var ve geçerli
- [ ] Data collection açıklaması doğru

### Content
- [ ] User Generated Content moderasyonu
- [ ] Copyright ihlali yok

### In-App Purchase
- [ ] "Restore Purchases" butonu var
- [ ] Fiyatlar doğru gösteriliyor
```

## 7.2 Google Play Policy

```markdown
## Play Store Politikaları

### Data Safety
- [ ] Data collection form dolduruldu
- [ ] Privacy policy güncel

### Ads
- [ ] Ads policy uyumu
- [ ] Reklam içeriği uygunluğu

### Permissions
- [ ] Sadece gerekli permission'lar
- [ ] Permission kullanım açıklaması

### Content Rating
- [ ] Questionnaire doğru dolduruldu
```

---

# 8. Rejection Handling

## 8.1 Red Sonrası Adımlar

```markdown
## Rejection Response Süreci

### 1. Analiz
- [ ] Rejection reason'ı tam oku
- [ ] Hangi guideline ihlal edildi?
- [ ] Ek bilgi istendi mi?

### 2. Aksiyon
- [ ] Kod değişikliği gerekli mi?
- [ ] Metadata değişikliği yeterli mi?
- [ ] Demo hesap bilgisi sağlanacak mı?

### 3. Response
- Resolution Center'dan yanıt ver
- Net ve profesyonel ol
- Değişiklikleri detaylı açıkla

### 4. Resubmit
- Tüm değişiklikleri test et
- Yeni build yükle
- Review notes güncelle
```

---

# 9. Post-Release

## 9.1 Monitoring

```markdown
## Release Sonrası İzleme

### Crash Monitoring
- [ ] Firebase Crashlytics aktif
- [ ] Sentry veya alternatif

### Analytics
- [ ] App Store Analytics
- [ ] Play Console vitals
- [ ] Custom analytics (Firebase, Mixpanel)

### Reviews
- [ ] Review'ları günlük kontrol et
- [ ] Negatif review'lara yanıt ver
- [ ] Feature request'leri topla
```

## 9.2 Update Cycle

```markdown
## Güncelleme Stratejisi

### Frequency
- Major: 2-3 ayda bir
- Minor/Patch: 2-4 haftada bir
- Hotfix: Kritik bug'lar için hemen

### Release Notes
- Kullanıcı odaklı dil
- Yeni özellikler öne çıkar
- Bug fix'leri listele
- Teşekkür et
```

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.0
