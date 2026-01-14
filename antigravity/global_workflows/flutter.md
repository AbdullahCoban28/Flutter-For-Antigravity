---
name: flutter
description: Kapsamlı Flutter geliştirme rehberi. Proje yapısı, widget best practices, state management, routing, API entegrasyonu ve platform özellikleri.
metadata:
  skillport:
    category: development
    tags:
      - flutter
      - dart
      - mobile
      - ios
      - android
      - cross-platform
---

# Flutter Geliştirme Becerisi

> Android ve iOS için tek kod tabanıyla yüksek performanslı mobil uygulamalar geliştirme rehberi.
> 2025 en iyi uygulamaları, Clean Architecture ve performans optimizasyonları.

---

# 📋 İçindekiler

1. [Proje Kurulumu](#1-proje-kurulumu)
2. [Proje Yapısı (Clean Architecture)](#2-proje-yapısı-clean-architecture)
3. [Widget Best Practices](#3-widget-best-practices)
4. [Routing (GoRouter)](#4-routing-gorouter)
5. [API Entegrasyonu (Dio)](#5-api-entegrasyonu-dio)
6. [Dependency Injection](#6-dependency-injection)
7. [Error Handling](#7-error-handling)
8. [Platform Özellikleri](#8-platform-özellikleri)
9. [Localization (Çoklu Dil)](#9-localization-çoklu-dil)
10. [Kontrol Listesi](#10-kontrol-listesi)
11. [Yapılmaması Gerekenler](#11-yapılmaması-gerekenler)
12. [Yapılması Gerekenler](#12-yapılması-gerekenler)

---

# 1. Proje Kurulumu

## 1.1 Yeni Proje Oluşturma

```bash
# Flutter projesi oluştur
flutter create --org com.example my_app
cd my_app

# Platform desteği ekle
flutter create --platforms=android,ios .

# Bağımlılıkları yükle
flutter pub get

# Cihazları listele
flutter devices

# Uygulamayı çalıştır
flutter run
```

## 1.2 Temel Paketler

```yaml
# pubspec.yaml
dependencies:
  flutter:
    sdk: flutter
  
  # State Management
  flutter_riverpod: ^2.4.0
  
  # Routing
  go_router: ^13.0.0
  
  # Network
  dio: ^5.4.0
  retrofit: ^4.1.0
  
  # Local Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  hive_flutter: ^1.1.0
  
  # Dependency Injection
  get_it: ^7.6.0
  injectable: ^2.3.0
  
  # Utils
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0
  intl: ^0.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Code Generation
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
  retrofit_generator: ^8.1.0
  injectable_generator: ^2.4.0
  
  # Testing
  mocktail: ^1.0.0
  bloc_test: ^9.1.0
  
  # Linting
  flutter_lints: ^3.0.0
```

## 1.3 analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  errors:
    invalid_annotation_target: ignore
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_final_locals
    - avoid_print
    - require_trailing_commas
    - prefer_single_quotes
```

---

# 2. Proje Yapısı (Clean Architecture)

```
lib/
├── main.dart                      # Uygulama giriş noktası
├── app/                           # Uygulama konfigürasyonu
│   ├── app.dart                   # MaterialApp wrapper
│   ├── router.dart                # GoRouter konfigürasyonu
│   └── di.dart                    # Dependency Injection setup
│
├── core/                          # Paylaşılan kod
│   ├── constants/
│   │   ├── app_constants.dart
│   │   └── api_constants.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_colors.dart
│   │   └── app_text_styles.dart
│   ├── utils/
│   │   ├── extensions.dart
│   │   └── validators.dart
│   ├── widgets/                   # Paylaşılan widget'lar
│   │   ├── app_button.dart
│   │   ├── app_text_field.dart
│   │   └── loading_overlay.dart
│   └── errors/
│       ├── failures.dart
│       └── exceptions.dart
│
├── features/                      # Feature modülleri
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   ├── auth_remote_datasource.dart
│   │   │   │   └── auth_local_datasource.dart
│   │   │   ├── models/
│   │   │   │   └── user_model.dart
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user.dart
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart
│   │   │   └── usecases/
│   │   │       ├── login_usecase.dart
│   │   │       └── logout_usecase.dart
│   │   └── presentation/
│   │       ├── providers/
│   │       │   └── auth_provider.dart
│   │       ├── screens/
│   │       │   ├── login_screen.dart
│   │       │   └── register_screen.dart
│   │       └── widgets/
│   │           └── login_form.dart
│   │
│   └── home/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
└── l10n/                          # Localization
    ├── app_en.arb
    └── app_tr.arb
```

---

# 3. Widget Best Practices

## 3.1 Const Constructor Kullanımı

```dart
// ✅ DOĞRU: const constructor
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final String label;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }
}

// Kullanım
const AppButton(label: 'Submit', onPressed: null); // const ile oluşturulabilir
```

## 3.2 Widget Composition

```dart
// ❌ YANLIŞ: Tek büyük widget
class UserProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Avatar kodu (50 satır)
          // Info kodu (30 satır)
          // Actions kodu (40 satır)
        ],
      ),
    );
  }
}

// ✅ DOĞRU: Küçük widget'lara böl
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key, required this.user});
  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _UserAvatar(imageUrl: user.avatarUrl),
          _UserInfo(user: user),
          _UserActions(userId: user.id),
        ],
      ),
    );
  }
}

class _UserAvatar extends StatelessWidget {
  const _UserAvatar({required this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 50,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null ? const Icon(Icons.person) : null,
    );
  }
}
```

## 3.3 Key Kullanımı

```dart
// Liste elemanlarında key zorunlu
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ItemCard(
      key: ValueKey(item.id), // ✅ Benzersiz key
      item: item,
    );
  },
);

// AnimatedList için GlobalKey
final _listKey = GlobalKey<AnimatedListState>();
```

---

# 4. Routing (GoRouter)

## 4.1 Router Konfigürasyonu

```dart
// app/router.dart
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;
    final isLoginRoute = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginRoute) {
      return '/login';
    }
    if (isLoggedIn && isLoginRoute) {
      return '/';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/user/:id',
      name: 'userDetail',
      builder: (context, state) {
        final userId = state.pathParameters['id']!;
        return UserDetailScreen(userId: userId);
      },
    ),
    ShellRoute(
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
      ],
    ),
  ],
  errorBuilder: (context, state) => ErrorScreen(error: state.error),
);
```

## 4.2 Navigation

```dart
// Navigasyon işlemleri
context.go('/home');                    // Replace
context.push('/user/123');              // Push
context.pop();                          // Pop
context.goNamed('userDetail', pathParameters: {'id': '123'});

// Query parameters
context.go('/search?q=flutter');
final query = GoRouterState.of(context).uri.queryParameters['q'];
```

---

# 5. API Entegrasyonu (Dio)

## 5.1 Dio Client Setup

```dart
// core/network/dio_client.dart
import 'package:dio/dio.dart';

class DioClient {
  late final Dio _dio;

  DioClient({required String baseUrl, required SecureStorage storage}) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Content-Type': 'application/json'},
    ));

    _dio.interceptors.addAll([
      _AuthInterceptor(storage),
      _LoggingInterceptor(),
      _ErrorInterceptor(),
    ]);
  }

  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? queryParams}) {
    return _dio.get(path, queryParameters: queryParams);
  }

  Future<Response<T>> post<T>(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }
}

class _AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  _AuthInterceptor(this._storage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await _storage.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
```

## 5.2 Retrofit ile API Tanımlama

```dart
// features/auth/data/datasources/auth_api.dart
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_api.g.dart';

@RestApi()
abstract class AuthApi {
  factory AuthApi(Dio dio, {String baseUrl}) = _AuthApi;

  @POST('/auth/login')
  Future<LoginResponse> login(@Body() LoginRequest request);

  @POST('/auth/register')
  Future<RegisterResponse> register(@Body() RegisterRequest request);

  @POST('/auth/refresh')
  Future<TokenResponse> refreshToken(@Body() RefreshRequest request);

  @GET('/auth/me')
  Future<UserResponse> getCurrentUser();
}
```

---

# 6. Dependency Injection

## 6.1 GetIt + Injectable Setup

```dart
// app/di.dart
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
```

```dart
// Servis kaydı
@lazySingleton
class AuthRepository {
  final AuthApi _api;
  final AuthLocalDataSource _local;

  AuthRepository(this._api, this._local);
}

@module
abstract class NetworkModule {
  @lazySingleton
  Dio get dio => Dio();

  @lazySingleton
  AuthApi authApi(Dio dio) => AuthApi(dio);
}
```

---

# 7. Error Handling

## 7.1 Result Pattern

```dart
// core/utils/result.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Failure<T>;
}

// Kullanım
Future<Result<User>> getUser(String id) async {
  try {
    final response = await _api.getUser(id);
    return Result.success(response.toEntity());
  } on DioException catch (e) {
    return Result.failure(ServerFailure(e.message ?? 'Server error'));
  } catch (e) {
    return Result.failure(UnexpectedFailure(e.toString()));
  }
}

// Widget'da kullanım
final result = await getUser('123');
result.when(
  success: (user) => showUser(user),
  failure: (failure) => showError(failure.message),
);
```

---

# 8. Platform Özellikleri

## 8.1 Platform Kontrolü

```dart
import 'dart:io' show Platform;

if (Platform.isIOS) {
  // iOS özel kod
} else if (Platform.isAndroid) {
  // Android özel kod
}

// Platform-specific widget
Platform.isIOS
    ? CupertinoButton(child: Text('iOS'), onPressed: () {})
    : ElevatedButton(child: Text('Android'), onPressed: () {});
```

## 8.2 Permission Handling

```dart
import 'package:permission_handler/permission_handler.dart';

Future<bool> requestCameraPermission() async {
  final status = await Permission.camera.request();
  
  if (status.isGranted) {
    return true;
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }
  return false;
}
```

---

# 9. Localization (Çoklu Dil)

## 9.1 Setup

```yaml
# pubspec.yaml
flutter:
  generate: true

# l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
```

```json
// lib/l10n/app_en.arb
{
  "@@locale": "en",
  "appTitle": "My App",
  "welcome": "Welcome, {name}!",
  "@welcome": {
    "placeholders": {
      "name": {"type": "String"}
    }
  }
}
```

## 9.2 Kullanım

```dart
// MaterialApp'te
MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
);

// Widget'da
Text(AppLocalizations.of(context)!.welcome('Abdullah'));
```

---

# 10. Kontrol Listesi

Her Flutter projesinde:

- [ ] Clean Architecture uygulandı
- [ ] Const constructor'lar kullanıldı
- [ ] Widget'lar küçük parçalara bölündü
- [ ] State management entegre edildi
- [ ] Error handling implement edildi
- [ ] Routing yapılandırıldı
- [ ] Dependency Injection kuruldu
- [ ] Localization eklendi
- [ ] Platform-specific kod izole edildi
- [ ] `flutter analyze` hatasız

---

# 11. Yapılmaması Gerekenler

❌ setState'i karmaşık state için kullanma
❌ Build metodunda async işlem yapma
❌ Context'i async gap sonrası kullanma
❌ Büyük widget'lar oluşturma (>100 satır)
❌ Key kullanmadan liste oluşturma
❌ print() kullanma (logger kullan)
❌ Hardcoded string kullanma
❌ Platform.isX yerine kIsWeb kullanmayı unutma

---

# 12. Yapılması Gerekenler

✅ Her widget için const constructor
✅ ListView.builder lazy loading için
✅ RepaintBoundary pahalı widget'lar için
✅ Isolate CPU-intensive işler için
✅ flutter analyze düzenli çalıştır
✅ Integration test kritik akışlar için
✅ Golden test UI değişiklikleri için
✅ ProGuard/obfuscation release build için

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.0
