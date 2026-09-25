# Flutter Manga Sync (`flutter_manga_sync`)

A full-stack, offline-first Flutter application demonstrating **Clean Architecture**, **Feature-First structure**, **Riverpod state management**, **Dio network handling with JWT interceptors**, and **Hive local storage caching**.

---

## 🌟 Features

- **Authentication Flow**: Login, Registration, and Logout with secure client-side JWT token storage using `FlutterSecureStorage`.
- **Manga Catalog Screen (REST API)**: Fetches trending manga data from the live [Kitsu API](https://kitsu.io/api/edge).
- **Manga Detail Screen**: Displays detailed synopsis, poster artwork, and title information with real-time state toggles.
- **Offline Favorites Screen (Hive Persisted)**: Bookmark favorite manga locally and access them seamlessly without an active internet connection.
- **Offline-First Data Strategy**: Automatic network fetch with graceful Hive cache fallback when offline or on network failure.
- **Network Error Handling**: Custom `Failure` domain mapping with friendly user-facing error UI and retry mechanisms.
- **Unit Testing**: Repository layer unit tests utilizing `mocktail` covering Success, Offline Cache Fallback, and Server Failure scenarios.

---

## 🏗️ Architecture & Project Structure

The project strictly adheres to **Clean Architecture** principles combined with a **Feature-First** structure.

```text
lib/
├── core/
│   ├── errors/          # Custom Failure domain exceptions & functional Result handling
│   ├── network/         # Dio HTTP client setup & AuthInterceptor (JWT injection)
│   └── storage/         # SecureStorageService wrapper with graceful platform fallback
│
└── features/
    ├── auth/            # Auth Feature (Login & Register screens, Auth State notifier)
    │   └── presentation/
    │       └── screens/
    │           ├── login_screen.dart
    │           └── register_screen.dart
    │
    └── manga/           # Manga Feature
        ├── data/
        │   ├── datasources/   # Remote (Kitsu REST API) & Local (Hive Box)
        │   ├── models/        # MangaModel JSON serialization
        │   └── repositories/  # MangaRepositoryImpl (Offline-first data layer)
        ├── domain/
        │   ├── entities/      # Pure domain Manga entity
        │   └── repositories/  # Abstract MangaRepository contract
        └── presentation/
            ├── providers/     # Riverpod StateNotifier, StateProvider & AsyncValue
            └── screens/       # MangaCatalogScreen, MangaDetailScreen, MangaFavoritesScreen
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
