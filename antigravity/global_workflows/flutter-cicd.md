---
name: flutter-cicd
description: Flutter CI/CD pipeline rehberi. GitHub Actions, Fastlane, Codemagic, code signing ve otomatik deployment.
metadata:
  skillport:
    category: operations
    tags:
      - flutter
      - ci-cd
      - github-actions
      - fastlane
      - codemagic
---

# Flutter CI/CD Becerisi

> Flutter uygulamaları için otomatik build, test ve deployment pipeline'ları.
> GitHub Actions, Fastlane ve Codemagic entegrasyonları.

---

# 📋 İçindekiler

1. [CI/CD Stratejisi](#1-cicd-stratejisi)
2. [GitHub Actions](#2-github-actions)
3. [Fastlane](#3-fastlane)
4. [Codemagic](#4-codemagic)
5. [Code Signing](#5-code-signing)
6. [Environment Yönetimi](#6-environment-yönetimi)
7. [Versioning](#7-versioning)

---

# 1. CI/CD Stratejisi

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│    COMMIT    │───▶│     TEST     │───▶│    BUILD     │
│   (push/PR)  │    │   (analyze,  │    │  (APK, IPA)  │
│              │    │  unit tests) │    │              │
└──────────────┘    └──────────────┘    └──────┬───────┘
                                               │
       ┌──────────────┐    ┌──────────────┐    │
       │   RELEASE    │◀───│   DEPLOY     │◀───┘
       │  (stores)    │    │ (TestFlight, │
       │              │    │  Play Store) │
       └──────────────┘    └──────────────┘
```

---

# 2. GitHub Actions

## 2.1 Test Workflow

```yaml
# .github/workflows/test.yml
name: Test

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'
          cache: true

      - name: Install dependencies
        run: flutter pub get

      - name: Analyze code
        run: flutter analyze

      - name: Run tests
        run: flutter test --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: coverage/lcov.info
```

## 2.2 Android Build Workflow

```yaml
# .github/workflows/android.yml
name: Android Build

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Java
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'

      - name: Decode Keystore
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 -d > android/app/keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=${{ secrets.KEY_ALIAS }}" >> android/key.properties
          echo "storeFile=keystore.jks" >> android/key.properties

      - name: Build APK
        run: flutter build apk --release

      - name: Build App Bundle
        run: flutter build appbundle --release

      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: release-apk
          path: build/app/outputs/flutter-apk/app-release.apk

      - name: Upload AAB
        uses: actions/upload-artifact@v4
        with:
          name: release-aab
          path: build/app/outputs/bundle/release/app-release.aab
```

## 2.3 iOS Build Workflow

```yaml
# .github/workflows/ios.yml
name: iOS Build

on:
  push:
    tags:
      - 'v*'

jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Flutter
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
          channel: 'stable'

      - name: Install dependencies
        run: flutter pub get

      - name: Install CocoaPods
        run: |
          cd ios
          pod install

      - name: Setup signing
        env:
          BUILD_CERTIFICATE_BASE64: ${{ secrets.BUILD_CERTIFICATE_BASE64 }}
          P12_PASSWORD: ${{ secrets.P12_PASSWORD }}
          BUILD_PROVISION_PROFILE_BASE64: ${{ secrets.BUILD_PROVISION_PROFILE_BASE64 }}
          KEYCHAIN_PASSWORD: ${{ secrets.KEYCHAIN_PASSWORD }}
        run: |
          # Create keychain
          security create-keychain -p "$KEYCHAIN_PASSWORD" build.keychain
          security set-keychain-settings -lut 21600 build.keychain
          security unlock-keychain -p "$KEYCHAIN_PASSWORD" build.keychain

          # Import certificate
          echo $BUILD_CERTIFICATE_BASE64 | base64 --decode > certificate.p12
          security import certificate.p12 -k build.keychain -P "$P12_PASSWORD" -T /usr/bin/codesign
          security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$KEYCHAIN_PASSWORD" build.keychain

          # Install provisioning profile
          mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles
          echo $BUILD_PROVISION_PROFILE_BASE64 | base64 --decode > ~/Library/MobileDevice/Provisioning\ Profiles/profile.mobileprovision

      - name: Build iOS
        run: flutter build ios --release --no-codesign

      - name: Archive
        run: |
          cd ios
          xcodebuild -workspace Runner.xcworkspace \
            -scheme Runner \
            -configuration Release \
            -archivePath Runner.xcarchive \
            archive

      - name: Export IPA
        run: |
          cd ios
          xcodebuild -exportArchive \
            -archivePath Runner.xcarchive \
            -exportPath build \
            -exportOptionsPlist ExportOptions.plist
```

---

# 3. Fastlane

## 3.1 iOS Fastlane Setup

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

platform :ios do
  desc "Push to TestFlight"
  lane :beta do
    setup_ci if ENV['CI']
    
    match(
      type: "appstore",
      readonly: true
    )
    
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner",
      export_method: "app-store"
    )
    
    upload_to_testflight(
      skip_waiting_for_build_processing: true
    )
  end

  desc "Push to App Store"
  lane :release do
    setup_ci if ENV['CI']
    
    match(type: "appstore", readonly: true)
    
    build_app(
      workspace: "Runner.xcworkspace",
      scheme: "Runner"
    )
    
    upload_to_app_store(
      skip_metadata: false,
      skip_screenshots: true,
      submit_for_review: true,
      automatic_release: false
    )
  end
end
```

## 3.2 Android Fastlane Setup

```ruby
# android/fastlane/Fastfile
default_platform(:android)

platform :android do
  desc "Deploy to Play Store Internal Track"
  lane :internal do
    gradle(
      task: "bundle",
      build_type: "Release"
    )
    
    upload_to_play_store(
      track: "internal",
      release_status: "draft",
      aab: "../build/app/outputs/bundle/release/app-release.aab"
    )
  end

  desc "Deploy to Play Store Production"
  lane :production do
    gradle(
      task: "bundle",
      build_type: "Release"
    )
    
    upload_to_play_store(
      track: "production",
      rollout: "0.1",
      aab: "../build/app/outputs/bundle/release/app-release.aab"
    )
  end
end
```

## 3.3 Fastlane Match (iOS Code Signing)

```ruby
# Matchfile
git_url("git@github.com:company/certificates.git")
storage_mode("git")
type("appstore")
app_identifier(["com.company.app"])
username("developer@company.com")
```

```bash
# İlk kurulum
fastlane match init
fastlane match appstore

# CI'da kullanım (readonly)
fastlane match appstore --readonly
```

---

# 4. Codemagic

## 4.1 codemagic.yaml

```yaml
# codemagic.yaml
workflows:
  android-workflow:
    name: Android Production
    max_build_duration: 60
    instance_type: mac_mini_m1
    
    environment:
      flutter: stable
      java: 17
      groups:
        - google_credentials
      vars:
        PACKAGE_NAME: "com.company.app"
    
    triggering:
      events:
        - push
      branch_patterns:
        - pattern: 'main'
          include: true
    
    scripts:
      - name: Get packages
        script: flutter pub get
      
      - name: Run tests
        script: flutter test
      
      - name: Build AAB
        script: |
          flutter build appbundle --release \
            --build-number=$BUILD_NUMBER
    
    artifacts:
      - build/**/outputs/**/*.aab
    
    publishing:
      google_play:
        credentials: $GCLOUD_SERVICE_ACCOUNT_CREDENTIALS
        track: internal

  ios-workflow:
    name: iOS Production
    max_build_duration: 60
    instance_type: mac_mini_m1
    
    integrations:
      app_store_connect: ASC_API_KEY
    
    environment:
      flutter: stable
      xcode: latest
      cocoapods: default
    
    scripts:
      - name: Get packages
        script: flutter pub get
      
      - name: Install pods
        script: |
          cd ios
          pod install
      
      - name: Build iOS
        script: |
          flutter build ios --release --no-codesign
      
      - name: Build IPA
        script: |
          xcode-project use-profiles
          xcode-project build-ipa \
            --workspace ios/Runner.xcworkspace \
            --scheme Runner
    
    artifacts:
      - build/ios/ipa/*.ipa
    
    publishing:
      app_store_connect:
        auth: integration
        submit_to_testflight: true
```

---

# 5. Code Signing

## 5.1 Android Keystore Yönetimi

```bash
# Keystore oluştur
keytool -genkey -v \
  -keystore upload-keystore.jks \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000 \
  -alias upload

# Keystore'u Base64'e çevir (CI için)
base64 -i upload-keystore.jks | pbcopy

# Secret olarak sakla
# KEYSTORE_BASE64
# KEYSTORE_PASSWORD
# KEY_PASSWORD
# KEY_ALIAS
```

## 5.2 iOS Certificate Yönetimi

```bash
# P12 dosyası dışa aktar (Keychain'den)
# Distribution certificate > Export

# Provisioning profile indir
# Apple Developer > Profiles > Download

# Base64'e çevir
base64 -i Certificates.p12 | pbcopy
base64 -i profile.mobileprovision | pbcopy
```

---

# 6. Environment Yönetimi

## 6.1 Flavor Configuration

```dart
// lib/config/env.dart
enum Environment { dev, staging, prod }

class EnvConfig {
  static Environment current = Environment.dev;
  
  static String get apiBaseUrl {
    switch (current) {
      case Environment.dev:
        return 'https://dev-api.example.com';
      case Environment.staging:
        return 'https://staging-api.example.com';
      case Environment.prod:
        return 'https://api.example.com';
    }
  }
}
```

## 6.2 Build Flavors

```bash
# Development build
flutter run --flavor dev -t lib/main_dev.dart

# Production build
flutter build apk --flavor prod -t lib/main_prod.dart
```

---

# 7. Versioning

## 7.1 Semantic Versioning

```yaml
# pubspec.yaml
# version: MAJOR.MINOR.PATCH+BUILD_NUMBER
version: 1.2.3+45
```

## 7.2 Otomatik Version Bump

```bash
# CI'da build number otomatik artır
flutter build apk --build-number=$GITHUB_RUN_NUMBER

# Version bump script
#!/bin/bash
CURRENT=$(grep 'version:' pubspec.yaml | sed 's/version: //')
# ... version artırma logic
```

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.0
