# Flutter Manga Sync (`flutter_manga_sync`)

`flutter_manga_sync` is a production-grade, offline-first mobile application built with **Flutter** and **Dart**. The project demonstrates a rigorous implementation of **Clean Architecture** coupled with a **Feature-First folder structure**, robust **Riverpod 2.0 state management**, network isolation using **Dio with custom JWT Interceptors**, local persistence via **Hive**, and full **Repository-layer unit testing with Mocktail**.

---

## 🌟 Comprehensive Features

### 1. Robust Authentication & Session Persistence

- **Token-Based Authentication**: Complete Login, Register, and Logout flows backed by secure token management using `FlutterSecureStorage`.
- **Automated Authorization Headers**: Built-in `AuthInterceptor` attached to the primary `Dio` HTTP client to automatically inject `Authorization: Bearer <token>` into outgoing network headers.
- **Linux/Desktop Keyring Resilience**: Includes a graceful in-memory token fallback mechanism for environments where system keyrings (`libsecret`) are locked or restricted.

### 2. Multi-Screen Data Experience (3 Primary Views)

- **Manga Catalog Screen (Live REST API)**: Fetches and displays a dynamic feed of trending manga entities directly from the public [Kitsu API](https://kitsu.io/api/edge/manga).
- **Manga Detail Screen**: Presents deep entity information including full synopses, canonical poster artwork, and real-time interactive bookmark toggles.
- **Offline Favorites Screen (Hive Persisted)**: A dedicated collection screen retrieving locally bookmarked manga entities instantly, operating independently of network connectivity.

### 3. Offline-First Resilience & Error Mapping

- **Smart Local Caching**: Every remote API fetch is cached locally via Hive. Should the device disconnect or the API encounter an outage, the repository automatically falls back to cached records.
- **Explicit Domain Error Handling**: Network failures and timeouts are caught and transformed into typed `Failure` domain objects (`ServerFailure`, `CacheFailure`), delivering clean, user-facing error UI notifications with retry mechanisms.

### 4. Enterprise-Grade Testing

- **Unit Testing**: Comprehensive test suite covering `MangaRepositoryImpl` using `mocktail` to verify API success payloads, offline cache fallback behavior, and dual-failure handling scenarios.

---

## 🏗️ Architecture & Project Structure

The project strictly adheres to **Clean Architecture** principles combined with a **Feature-First** structure.

```text
lib/
├── core/
│   ├── constants/       # Global API endpoints and storage keys
│   ├── errors/          # Custom Failure domain exceptions & functional Result handling
│   ├── network/         # Dio HTTP client configuration & AuthInterceptor setup
│   └── storage/         # SecureStorageService wrapper with desktop keyring fallback
│
└── features/
    ├── auth/            # Auth Feature Module
    │   ├── data/        # AuthRepository & authentication services
    │   └── presentation/
    │       ├── providers/ # AuthNotifier state management
    │       └── screens/   # LoginScreen & RegisterScreen UI views
    │
    └── manga/           # Manga Feature Module
        ├── data/
        │   ├── datasources/   # MangaRemoteDataSource (Kitsu API) & MangaLocalDataSource (Hive)
        │   ├── models/        # MangaModel JSON serialization with dynamic map casting
        │   └── repositories/  # MangaRepositoryImpl (Offline-first orchestration)
        ├── domain/
        │   ├── entities/      # Pure Domain Manga entity
        │   └── repositories/  # Abstract MangaRepository interface contract
        └── presentation/
            ├── providers/     # Riverpod StateNotifiers, StateProviders & AsyncValue handling
            └── screens/       # MangaCatalogScreen, MangaDetailScreen & MangaFavoritesScreen
```

## 🌐 API & External Services

- **Manga API**: [Kitsu API v1](https://kitsu.io/api/edge/manga)
- **HTTP Client**: `Dio` configured with an `AuthInterceptor` to inject `Authorization: Bearer <token>` into outgoing request headers.
- **Local Persistence**: `Hive` key-value database for caching manga list models and user offline favorites.
- **Secure Token Storage**: `FlutterSecureStorage` (with in-memory fallback handling for Linux desktop keyrings).

## 🚀 Getting Started

Prerequisites

Ensure you have the following installed on your development machine:

    Flutter SDK: >=3.13.2

    Dart SDK: >=3.0.0

    Git

## Installation & Setup

### 1. Clone the repository:

```text
    git clone git@github.com:leeandri/flutter-manga-sync.git
    cd flutter_manga_sync
```

### 2. Install dependencies:

```text
    flutter pub get
```

### 3. Run code generation (if applicable):

```text
    flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Running Unit Tests

The repository unit tests verify data fetching success, offline cache retrieval, and error states using mocktail.
To run the test suite:

```text
    flutter test
```

Expected output:

```text
    00:02 +3: All tests passed!
```

### 5. Run the application:

```text
    flutter run
```

## 🔐 Authentication Credentials (Demo)

Since the app uses a simulated local JWT flow integrated with an interceptor:

Email: Any valid email format (e.g., user@example.com)

Password: Any password (minimum 6 characters)

## 📄 License

Distributed under the MIT License. See LICENSE for more information.
