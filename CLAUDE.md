# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Run app on connected device/simulator
flutter run

# Build
flutter build ios
flutter build apk

# Analyze
dart analyze

# Format
dart format .

# Run tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Regenerate launcher icons / splash
dart run flutter_launcher_icons
dart run flutter_native_splash:create

# Get dependencies
flutter pub get
```

## Architecture

**StyleHub** (`package:dx`) is a Flutter fashion social media + e-commerce app. Backend: `https://style-hub-social-media-be-d369dfc7ce40.herokuapp.com/`.

### Layer structure

```
lib/
├── Authentication/         # Auth screens + models (Login, Signup, ForgetPassword, CompleteProfile)
├── E-Commerce/             # E-commerce screens (Home, Shop, Cart, Checkout, etc.)
├── Social-Media/           # Feed, user profile, shared layout (BLoC/Cubit)
│   ├── feed/               # FeedCubit, FeedService, FeedPage, post widgets
│   ├── user/               # AuthorModel, user profile service
│   └── shared/             # MainLayout (bottom nav), StylehubAppBar
├── Widgets/                # Shared reusable widgets
├── cache/cache_helper.dart # SharedPreferences wrapper (CacheHelper)
├── repositories/           # UserRepository — single repo for all auth/user API calls
└── core/
    ├── api/                # ApiConsumer (abstract), DioConsumer (impl), ApiClient, interceptors, endpoints
    ├── errors/             # ErrorModel, exceptions
    ├── navigation/         # NavigationService — global navigator key for imperative navigation
    ├── services/           # GetIt service locator (setupServiceLocator)
    ├── theme/appstyles.dart# AppStyles — all shared TextStyle, ButtonStyle, InputBorder
    ├── validators/         # Form field validators
    └── functions/          # Utilities (e.g., uploadImageToApi)
```

### Dependency injection

`GetIt` is used as service locator. All registrations are in `lib/core/services/service_locator.dart`. Call `getIt<T>()` to resolve. Registered singletons: `Dio`, `DioConsumer`, `UserRepository`, `FeedService`.

### API layer — two access patterns

There are two ways to call the API:

1. **Auth/user flows** — use `getIt<UserRepository>()` which calls `getIt<DioConsumer>()` (implements `ApiConsumer`).
2. **Social-Media feature services** (e.g. `FeedService`) — use `ApiClient.instance` which is a thin accessor that returns the same `getIt<Dio>()` singleton directly.

Both share the same `Dio` instance so `ApiInterceptors` (QueuedInterceptor) applies to both: auto Bearer-token injection, silent 401 token refresh via `UserRepository.refreshtoken()`, and redirect to `LogIn` on session expiry.

All API keys and endpoint paths are constants in `lib/core/api/endpoints.dart` — use `ApiKey.*` and `Endpoints.*` instead of raw strings.

### Post-login navigation flow

After a successful login, `LogIn` routes based on `Usermodel.isProfileComplete` and `role`:

- `isProfileComplete == true` → `MainLayout` (pushAndRemoveUntil, clears back stack)
- `isProfileComplete == false && role == "USER"` → `UserCompleteProfile`
- `isProfileComplete == false && role == "BRAND"` → `BrandCompleteProfile`

`MainLayout` is a 5-tab bottom nav (`IndexedStack`): Feed, Shop, Messages, Search, Profile.

### Social-Media state management

The Social-Media layer uses **flutter_bloc** (Cubit). `FeedCubit` manages paginated feed loading with states: `initial`, `loading`, `refreshing`, `loadingMore`, `success`, `failure`. Pagination is offset-based (`limit=10`). New Social-Media features should follow the same Cubit + Service pattern.

### Auth tokens

Stored in `SharedPreferences` via `CacheHelper` under `ApiKey.accessToken` and `ApiKey.refreshToken`. Auth screens use `StatefulWidget`/`setState` (no BLoC).

### Navigation

Uses `NavigationService.navigatorKey` (global key) set on `MaterialApp`. Imperative navigation via `NavigationService.navigatorKey.currentState?.push(...)`.

### Responsive sizing

All sizing uses `flutter_screenutil` with design size **440×956**. Always use `.sp` for font sizes, `.w`/`.h` for widths/heights, `.r` for border radii, `.dg` for symmetric padding.

### Two user roles

The app supports two roles: `USER` and `BRAND`. Role is passed at login/signup and determines which complete-profile flow runs (`userCompleteProfile` vs `brandCompleteProfile`).
