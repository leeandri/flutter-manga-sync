# Flutter Manga Sync

A high-performance, cross-platform Flutter application for browsing manga catalogs, managing personal favorites, and accessing offline content. Built with **Clean Architecture (Feature-First)**, **Riverpod**, **Dio**, and **Hive**.

---

## 🌟 Key Features

- **Authentication & Security**: Secure user login, session management, and JWT persistence using `FlutterSecureStorage` with interceptor-based authorization.
- **Manga Catalog Browsing**: Real-time manga retrieval powered by the Kitsu REST API.
- **Multi-Screen REST API Integration**:
  - **Catalog Screen**: Paginated listing of top-rated and trending manga.
  - **Search & Filter Screen**: Live querying and filtering of manga titles via REST API.
  - **Detail Screen**: Detailed metadata view including synopsis, cover art, and ratings fetched dynamically.
- **Offline-First Capabilities**: Complete local caching layer powered by Hive, allowing seamless browsing and access to cached content and favorites without internet connectivity.
- **Favorites Management**: Local persistence for offline bookmarked manga.

---

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** principles structured by **Feature-First**:

```
lib/
├── core/
│   ├── constants/       # API endpoints and configuration keys
│   ├── errors/          # Custom Failure and Exception mappings
│   ├── network/         # Dio HTTP client setup and AuthInterceptor
│   ├── storage/         # SecureStorageService wrapper
│   └── theme/           # App design tokens and material themes
├── features/
│   ├── auth/            # Authentication domain, data, and UI logic
│   │   ├── data/        # AuthRepository & AuthRemoteDataSource
│   │   ├── domain/      # Auth entities and use cases
│   │   └── presentation/# Login/Register screens and AuthNotifier
│   └── manga/           # Manga feature slice
│       ├── data/        # MangaRepositoryImpl & MangaLocalDataSource
│       ├── domain/      # Manga entity & MangaRepository interface
│       └── presentation/# Catalog, Detail, and Search screens & Riverpod providers
└── main.dart            # Hive initialization, Riverpod Scope setup, and App entry point

```

## 🛠️ Tech Stack & Dependencies

| Category             | Library / Package                                                                                                                    | Purpose                                          |
| -------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------ |
| **Framework**        | [Flutter](https://flutter.dev)                                                                                                       | Cross-platform UI toolkit                        |
| **State Management** | [flutter_riverpod](https://pub.dev/packages/flutter_riverpod)                                                                        | Declarative reactive state management            |
| **Networking**       | [dio](https://pub.dev/packages/dio)                                                                                                  | HTTP client with interceptors                    |
| **Local Database**   | [hive](https://pub.dev/packages/hive) & [hive_flutter](https://pub.dev/packages/hive_flutter)                                        | High-performance NoSQL offline key-value storage |
| **Secure Storage**   | [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage)                                                            | Encrypted key-value persistence for Auth JWTs    |
| **Testing**          | [flutter_test](https://api.flutter.dev/flutter/flutter_test/flutter_test-package.html) & [mockito](https://pub.dev/packages/mockito) | Unit testing & mock generation                   |

## 🔄 Offline-First Strategy & Data Flow

1. **Remote Fetch**: When online, data is fetched via Dio from the REST API endpoints.
2. **Local Sync**: Retrieved data is serialized and stored in Hive boxes (`manga_cache_box`).
3. **Fallback Logic**: If network failure occurs (`DioException`), `MangaRepositoryImpl` catches the error and reads directly from Hive local cache.
4. **Favorites**: User favorites are persisted independently in `manga_favorites_box` and accessible completely offline.

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

## 🧪 Testing Suite

The application includes unit and repository tests using `flutter_test` and `mockito`:

- `test/features/manga/manga_repository_test.dart`: Repository tests for API fetching, caching, and offline fallback.
- `test/features/auth/auth_repository_test.dart`: Auth flow and token handling tests.
- `test/core/network/auth_interceptor_test.dart`: Authorization header injection unit tests.

To run all tests with coverage:

```bash
flutter test --coverage
```

## ⚙️ Continuous Integration (CI/CD)

Automated testing and analysis are configured via GitHub Actions (`.github/workflows/ci.yml`). Every commit pushed to `main` or `dev` triggers:

- Code linting & static analysis (`flutter analyze`)
- Mock generation check
- Unit test execution (`flutter test`)
- Android APK build verification
