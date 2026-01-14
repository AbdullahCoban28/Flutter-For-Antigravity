---
name: flutter-testing
description: Flutter test stratejileri. Widget testing, golden testing, integration testing ve mocking patterns.
metadata:
  skillport:
    category: quality
    tags:
      - flutter
      - testing
      - widget-test
      - golden-test
      - integration-test
---

# Flutter Testing Becerisi

> Flutter uygulamalarında kapsamlı test stratejileri.
> Widget, Golden ve Integration testleri ile kalite güvencesi.

---

# 📋 İçindekiler

1. [Test Piramidi (Flutter)](#1-test-piramidi-flutter)
2. [Unit Testing](#2-unit-testing)
3. [Widget Testing](#3-widget-testing)
4. [Golden Testing](#4-golden-testing)
5. [Integration Testing](#5-integration-testing)
6. [Mocking (Mocktail)](#6-mocking-mocktail)
7. [Provider/Riverpod Testing](#7-providerriverpod-testing)
8. [Kontrol Listesi](#8-kontrol-listesi)

---

# 1. Test Piramidi (Flutter)

```
         / \
        /E2E\  ← Integration tests (Real devices, slow)
       /─────\
      / WIDGET\ ← Widget tests (Fast, UI logic)
     /─────────\
    /   UNIT    \ ← Unit tests (Fastest, pure logic)
   /─────────────\
```

| Tip | Hız | Kapsam | Dosya |
|-----|-----|--------|-------|
| **Unit** | ⚡⚡⚡ | İş mantığı, servisler | `*_test.dart` |
| **Widget** | ⚡⚡ | UI bileşenleri | `*_test.dart` |
| **Integration** | ⚡ | Tam uygulama akışı | `integration_test/` |

---

# 2. Unit Testing

## 2.1 Temel Unit Test

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const email = 'test@example.com';
    const password = 'password123';
    final user = User(id: '1', email: email);

    test('should return User when login is successful', () async {
      // Arrange
      when(() => mockRepository.login(email, password))
          .thenAnswer((_) async => Result.success(user));

      // Act
      final result = await useCase(email, password);

      // Assert
      expect(result, Result.success(user));
      verify(() => mockRepository.login(email, password)).called(1);
    });

    test('should return Failure when login fails', () async {
      // Arrange
      when(() => mockRepository.login(email, password))
          .thenAnswer((_) async => Result.failure(ServerFailure('Invalid credentials')));

      // Act
      final result = await useCase(email, password);

      // Assert
      expect(result, isA<Failure>());
    });
  });
}
```

---

# 3. Widget Testing

## 3.1 Temel Widget Test

```dart
// test/features/auth/presentation/widgets/login_form_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LoginForm', () {
    testWidgets('should display email and password fields', (tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: LoginForm()),
        ),
      );

      // Assert
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
    });

    testWidgets('should show validation error for empty email', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoginForm())),
      );

      // Tap submit without entering email
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text('Email is required'), findsOneWidget);
    });

    testWidgets('should call onSubmit with correct values', (tester) async {
      String? submittedEmail;
      String? submittedPassword;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: LoginForm(
              onSubmit: (email, password) {
                submittedEmail = email;
                submittedPassword = password;
              },
            ),
          ),
        ),
      );

      // Enter email
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@example.com',
      );

      // Enter password
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      // Submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(submittedEmail, 'test@example.com');
      expect(submittedPassword, 'password123');
    });
  });
}
```

## 3.2 Widget Test Helpers

```dart
// test/helpers/pump_app.dart
extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp(Widget widget) async {
    await pumpWidget(
      MaterialApp(
        home: Scaffold(body: widget),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }

  Future<void> pumpAppWithProviders(Widget widget) async {
    await pumpWidget(
      ProviderScope(
        overrides: [],
        child: MaterialApp(home: widget),
      ),
    );
  }
}
```

---

# 4. Golden Testing

## 4.1 Golden Test Yazma

```dart
// test/features/home/presentation/screens/home_screen_golden_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen Golden Tests', () {
    testWidgets('matches golden file', (tester) async {
      // Set fixed size for consistency
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const MaterialApp(home: HomeScreen()),
      );

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_screen.png'),
      );
    });

    testWidgets('matches golden file - dark mode', (tester) async {
      tester.view.physicalSize = const Size(375, 812);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.dark(),
          home: const HomeScreen(),
        ),
      );

      await expectLater(
        find.byType(HomeScreen),
        matchesGoldenFile('goldens/home_screen_dark.png'),
      );
    });
  });
}
```

## 4.2 Golden Testleri Güncelleme

```bash
# Golden dosyalarını oluştur/güncelle
flutter test --update-goldens

# Sadece golden testleri çalıştır
flutter test --tags=golden

# CI'da golden testleri çalıştır
flutter test
```

---

# 5. Integration Testing

## 5.1 Integration Test Setup

```dart
// integration_test/app_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow', () {
    testWidgets('user can login successfully', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to login
      expect(find.text('Login'), findsOneWidget);

      // Enter credentials
      await tester.enterText(
        find.byKey(const Key('emailField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('passwordField')),
        'password123',
      );

      // Submit
      await tester.tap(find.byKey(const Key('loginButton')));
      await tester.pumpAndSettle();

      // Verify navigation to home
      expect(find.text('Welcome'), findsOneWidget);
    });
  });
}
```

## 5.2 Integration Test Çalıştırma

```bash
# Android emulator'da
flutter test integration_test/app_test.dart

# iOS simulator'da
flutter test integration_test/app_test.dart -d iPhone

# Tüm integration testleri
flutter test integration_test/
```

---

# 6. Mocking (Mocktail)

## 6.1 Mock Oluşturma

```dart
import 'package:mocktail/mocktail.dart';

// Mock sınıfı
class MockAuthRepository extends Mock implements AuthRepository {}
class MockDio extends Mock implements Dio {}

// Fake sınıfı (when registerFallbackValue gerektiğinde)
class FakeLoginRequest extends Fake implements LoginRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeLoginRequest());
  });

  // ...
}
```

## 6.2 Verify Kullanımı

```dart
test('should call repository with correct parameters', () async {
  // Arrange
  when(() => mockRepository.login(any(), any()))
      .thenAnswer((_) async => Result.success(user));

  // Act
  await useCase('email', 'password');

  // Assert
  verify(() => mockRepository.login('email', 'password')).called(1);
  verifyNoMoreInteractions(mockRepository);
});
```

---

# 7. Provider/Riverpod Testing

## 7.1 Provider Override

```dart
testWidgets('shows user data', (tester) async {
  final mockUser = User(id: '1', name: 'Test User');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => AsyncValue.data(mockUser)),
      ],
      child: const MaterialApp(home: ProfileScreen()),
    ),
  );

  expect(find.text('Test User'), findsOneWidget);
});
```

---

# 8. Kontrol Listesi

- [ ] Unit test coverage >80%
- [ ] Kritik widget'lar için widget testleri
- [ ] UI değişiklikleri için golden testler
- [ ] Ana akışlar için integration testler
- [ ] Mocktail ile izole testler
- [ ] CI/CD'de testler otomatik çalışıyor
- [ ] Test raporları oluşturuluyor

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.0
