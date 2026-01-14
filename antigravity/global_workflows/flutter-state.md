---
name: flutter-state
description: Flutter state management rehberi. Provider, Riverpod, BLoC/Cubit patterns ve karşılaştırma.
metadata:
  skillport:
    category: development
    tags:
      - flutter
      - state-management
      - riverpod
      - bloc
      - provider
---

# Flutter State Management Becerisi

> Flutter uygulamalarında state yönetimi stratejileri.
> Provider, Riverpod, BLoC ve kullanım senaryoları.

---

# 📋 İçindekiler

1. [State Management Seçimi](#1-state-management-seçimi)
2. [Riverpod](#2-riverpod)
3. [BLoC/Cubit](#3-bloccubit)
4. [Provider (Legacy)](#4-provider-legacy)
5. [Karşılaştırma Tablosu](#5-karşılaştırma-tablosu)
6. [Best Practices](#6-best-practices)

---

# 1. State Management Seçimi

| Senaryo | Önerilen |
|---------|----------|
| Yeni proje, temiz başlangıç | **Riverpod** |
| Mevcut Provider projesi | Provider veya geçiş |
| Büyük ekip, strict patterns | **BLoC** |
| Reactive programming | BLoC + Streams |
| Basit uygulama | Provider veya StatefulWidget |

---

# 2. Riverpod

## 2.1 Setup

```dart
// main.dart
void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}
```

## 2.2 Provider Türleri

```dart
// Basit değer
final counterProvider = StateProvider<int>((ref) => 0);

// Async veri
final userProvider = FutureProvider<User>((ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
});

// Stream
final messagesProvider = StreamProvider<List<Message>>((ref) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.watchMessages();
});

// Notifier (Complex state)
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() => const AuthState.initial();

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await ref.read(authRepositoryProvider).login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  void logout() {
    ref.read(authRepositoryProvider).logout();
    state = const AuthState.initial();
  }
}
```

## 2.3 Widget'da Kullanım

```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
      data: (user) => Text('Welcome, ${user.name}'),
    );
  }
}

// StatefulWidget ile
class CounterScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends ConsumerState<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    final count = ref.watch(counterProvider);
    
    return ElevatedButton(
      onPressed: () => ref.read(counterProvider.notifier).state++,
      child: Text('Count: $count'),
    );
  }
}
```

---

# 3. BLoC/Cubit

## 3.1 Cubit (Basit)

```dart
// State
@freezed
class CounterState with _$CounterState {
  const factory CounterState({
    @Default(0) int count,
  }) = _CounterState;
}

// Cubit
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());

  void increment() => emit(state.copyWith(count: state.count + 1));
  void decrement() => emit(state.copyWith(count: state.count - 1));
}

// Widget
class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CounterCubit(),
      child: BlocBuilder<CounterCubit, CounterState>(
        builder: (context, state) {
          return Text('Count: ${state.count}');
        },
      ),
    );
  }
}
```

## 3.2 BLoC (Event-Based)

```dart
// Events
@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.loginRequested(String email, String password) = LoginRequested;
  const factory AuthEvent.logoutRequested() = LogoutRequested;
}

// State
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

// BLoC
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc(this._repository) : super(const AuthState.initial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());
    try {
      final user = await _repository.login(event.email, event.password);
      emit(AuthState.authenticated(user));
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _repository.logout();
    emit(const AuthState.unauthenticated());
  }
}
```

## 3.3 BLoC Widget Patterns

```dart
// BlocListener - Side effects (navigation, snackbar)
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    state.whenOrNull(
      authenticated: (_) => context.go('/home'),
      error: (message) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      ),
    );
  },
  child: LoginForm(),
);

// BlocConsumer - Listen + Build
BlocConsumer<AuthBloc, AuthState>(
  listener: (context, state) {
    // Side effects
  },
  builder: (context, state) {
    return state.maybeWhen(
      loading: () => const CircularProgressIndicator(),
      orElse: () => LoginForm(),
    );
  },
);

// BlocSelector - Partial rebuild
BlocSelector<UserBloc, UserState, String>(
  selector: (state) => state.user.name,
  builder: (context, name) => Text(name),
);
```

---

# 4. Provider (Legacy)

```dart
// ChangeNotifier
class CartNotifier extends ChangeNotifier {
  final List<CartItem> _items = [];
  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(Product product) {
    _items.add(CartItem(product: product, quantity: 1));
    notifyListeners();
  }
}

// Setup
ChangeNotifierProvider(
  create: (_) => CartNotifier(),
  child: MyApp(),
);

// Consume
final cart = context.watch<CartNotifier>();
final cart = Provider.of<CartNotifier>(context);
context.read<CartNotifier>().addItem(product); // Mutate
```

---

# 5. Karşılaştırma Tablosu

| Özellik | Riverpod | BLoC | Provider |
|---------|----------|------|----------|
| **Öğrenme eğrisi** | Orta | Yüksek | Düşük |
| **Boilerplate** | Az | Çok | Orta |
| **Test edilebilirlik** | ⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Scalability** | Yüksek | Çok yüksek | Orta |
| **Code generation** | Opsiyonel | Opsiyonel | Yok |
| **Async desteği** | Native | Stream | Manuel |
| **DevTools** | ✅ | ✅ | ✅ |

---

# 6. Best Practices

## 6.1 State Immutability

```dart
// ✅ DOĞRU: Immutable state (Freezed)
@freezed
class UserState with _$UserState {
  const factory UserState({
    required User user,
    @Default(false) bool isLoading,
  }) = _UserState;
}

// ❌ YANLIŞ: Mutable state
class UserState {
  User user;
  bool isLoading;
}
```

## 6.2 Separation of Concerns

```dart
// ✅ DOĞRU: İş mantığı ayrı
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase _loginUseCase;
  // UseCase içinde repository çağrısı
}

// ❌ YANLIŞ: Bloc içinde API çağrısı
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final Dio _dio; // Directly calling API
}
```

---

**Son Güncelleme:** Aralık 2025
**Versiyon:** 1.0
