# Changelog

All notable changes to this project will be documented in this file.

## [1.0.0] - 2026-10-06

### Added

- Complete unit test suite (`test/unit_tests/unit_test.dart`) covering entities, JSON parsing, and failures.
- Widget test suite (`test/widget_tests/widgets_test.dart`) testing core UI components.
- End-to-end integration tests (`integration_test/app_test.dart`).
- Full internationalization support with `app_en.arb` and `app_fr.arb`.
- Accessibility enhancements using `Semantics` widgets for UI interactive elements.

### Changed

- Updated `README.md` with CI badge, i18n instructions, and project architecture details.

## [0.2.0] - 2026-09-25

### Added

- Complete authentication flow with registration, mock fallbacks, and JWT storage.
- Integration of `getMangaListUseCase` with clean architecture layers and updated return types.
- Favorites management with local offline persistence using Hive.

### Fixed

- Mock and provider test suite compilation errors and return type mismatches.
- Resolved static analysis warnings and enhanced overall test coverage.

## [0.1.0] - 2026-09-01

### Added

- Initial project setup with Flutter, Clean Architecture (Feature-First), and Riverpod.
- Base UI design and navigation routing.
- Remote data source integration using Dio and Kitsu REST API.
