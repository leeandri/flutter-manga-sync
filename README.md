# MangaSync — Flutter Clean Architecture Application

[![CI/CD Pipeline](https://github.com/leeandri/flutter_manga_sync/actions/workflows/ci.yml/badge.svg)](https://github.com/leeandri/flutter_manga_sync/actions)

MangaSync is a high-performance, cross-platform Flutter application for browsing manga catalogs, managing personal favorites, and accessing offline content. Built with **Clean Architecture (Feature-First)**, **Riverpod**, **Dio**, and **Hive**.

## 🌟 Key Features

- **Authentication & Security**: Secure user login, session management, and JWT persistence using `FlutterSecureStorage` with interceptor-based authorization (powered by `reqres.in`).
- **Manga Catalog Browsing**: Real-time manga retrieval powered by the Kitsu REST API.
- **Multi-Screen REST API Integration**:
  - **Catalog Screen**: Paginated listing of top-rated and trending manga.
  - **Search & Filter Screen**: Live querying and filtering of manga titles via REST API.
  - **Detail Screen**: Detailed metadata view including synopsis, cover art, and ratings fetched dynamically.
- **Internationalization (i18n)**: Multi-language support (English and French) using Flutter `AppLocalizations` `.arb` files and a dynamic `LanguageSelector` widget.
- **Offline-First Capabilities**: Complete local caching layer powered by Hive, allowing seamless browsing and access to cached content and favorites without internet connectivity.
- **Favorites Management**: Local persistence for offline bookmarked manga with safe deserialization handling raw Hive maps.

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** principles structured by **Feature-First** with explicit layer separation (`data`, `domain`, `presentation`):

```text
lib/
├── core/
│   ├── constants/       # API endpoints and configuration keys
│   ├── errors/          # Custom Failure classes (ServerFailure, NetworkFailure)
│   ├── network/         # Dio HTTP client setup and AuthInterceptor
│   ├── storage/         # SecureStorageService wrapper
│   ├── theme/           # App design tokens and material themes
│   └── widgets/         # Shared UI components (LanguageSelector)
├── features/
│   ├── auth/            # Authentication feature
│   │   ├── data/        # AuthRepositoryImpl & AuthRemoteDataSource
│   │   ├── domain/      # Auth entities and use cases
│   │   └── presentation/# Login/Register screens and AuthNotifier
│   └── manga/           # Manga catalog & offline favorites feature
│       ├── data/        # MangaRepositoryImpl & MangaLocalDataSource
│       ├── domain/      # Manga entity & MangaRepository interface
│       └── presentation/# Catalog, Detail, Favorites, and Search screens
├── l10n/                # Internationalization ARB files (app_en.arb, app_fr.arb)
└── main.dart            # Hive initialization, Riverpod Scope setup, and App entry point
```

## 🌐 APIs & Localization

1. **Authentication API (`reqres.in`)**: Handles user login, registration, and session token generation. Tokens are stored securely using `FlutterSecureStorage`.
2. **Primary Data API (`Kitsu REST API`)**: Serves real-time manga metadata, catalog lists, and search queries (`https://kitsu.io/api/edge`).
3. **Internationalization (i18n)**: Supports English (`en`) and French (`fr`) locales configured in `l10n.yaml`. Language switching is driven by Riverpod state management.

## 🔄 Offline-First Strategy & Failure Handling

1. **Remote Fetch**: When online, data is fetched via Dio from the REST API endpoints.
2. **Local Sync**: Data is cached in Hive (`manga_cache_box`) on successful requests.
3. **Offline Fallback**: If a network request fails (`DioException`), `MangaRepositoryImpl` catches the error and serves cached data from Hive.
4. **Failure Mapping**: Exceptions are mapped to domain-level `Failure` types (`NetworkFailure`, `ServerFailure`) with clear messages displayed in the UI via SnackBars or dedicated error screens.

## 🛠️ Tech Stack & Dependencies

| Category             | Library / Package                                                                                                                    | Purpose                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------ |
| **Framework**        | [Flutter](https://flutter.dev)                                                                                                       | Cross-platform UI toolkit                        |
| **State Management** | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)                                                                        | Declarative reactive state management            |
| **Networking**       | [dio](https://pub.dev/packages/dio)                                                                                                  | HTTP client with interceptors                    |
| **Local Database**   | [hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter)                                        | High-performance NoSQL offline key-value storage |
| **Secure Storage**   | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)                                                            | Encrypted key-value persistence for Auth JWTs    |
| **Localization**     | [flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)                    | i18n support with ARB files                      |
| **Testing**          | [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-package.html) & [mockito](https://pub.dev/packages/mockito) | Unit testing & mock generation                   |

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.x or higher)
- Dart SDK (3.x or higher)
- Android Studio / VS Code with Flutter extensions

### Installation Steps

1. **Clone the repository**:
   ```bash
   git clone [https://github.com/your-username/flutter_manga_sync.git](https://github.com/your-username/flutter_manga_sync.git)
   cd flutter_manga_sync
   ```
2. **Install dependencies**:
   ```bash
   flutter pub get
   ```
3. **Generate code and mocks**:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
4. **Run static analysis**:
   ```bash
   flutter analyze
   ```
5. **Execute test suite**:
   ```bash
   flutter test
   ```
6. **Launch the application**:
   ```bash
   flutter run
   ```

## 🧪 Testing Suite & CI/CD Pipeline

### Unit & Repository Testing

The application includes unit tests covering repository implementations, authorization interceptors, and local persistence fallback strategies:

- `test/features/manga/data/repositories/manga_repository_impl_test.dart`: Validates remote data fetching, offline Hive caching fallback, and `NetworkFailure` handling.
- `test/features/auth/auth_repository_test.dart`: Validates authentication login/register flows and secure JWT token persistence.
- `test/core/network/auth_interceptor_test.dart`: Validates dynamic Bearer token injection into HTTP headers and 401 response handling.

Run all unit tests with coverage:

```bash
flutter test --coverage
```
