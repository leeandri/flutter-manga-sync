import 'package:flutter_manga_sync/core/errors/failures.dart';
import 'package:flutter_manga_sync/core/storage/secure_storage_service.dart';
import 'package:flutter_manga_sync/features/auth/data/auth_repository.dart';
import 'package:flutter_manga_sync/features/manga/presentation/providers/manga_providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late AuthStateNotifier authStateNotifier;
  late MockAuthRepository mockAuthRepository;
  late MockSecureStorageService mockSecureStorageService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSecureStorageService = MockSecureStorageService();
    when(() => mockSecureStorageService.getToken())
        .thenAnswer((_) async => null);

    authStateNotifier = AuthStateNotifier(
      mockSecureStorageService,
      mockAuthRepository,
    );
  });

  group('AuthStateNotifier Tests', () {
    test('checkAuthStatus sets state to true when token exists', () async {
      when(() => mockSecureStorageService.getToken())
          .thenAnswer((_) async => 'valid_token');

      await authStateNotifier.checkAuthStatus();

      expect(authStateNotifier.state, true);
      verify(() => mockSecureStorageService.getToken()).called(2);
    });

    test('checkAuthStatus sets state to false when token is null', () async {
      when(() => mockSecureStorageService.getToken())
          .thenAnswer((_) async => null);

      await authStateNotifier.checkAuthStatus();

      expect(authStateNotifier.state, false);
      verify(() => mockSecureStorageService.getToken()).called(2);
    });

    test('login calls storage and sets state to true', () async {
      when(() => mockSecureStorageService.saveToken('new_token'))
          .thenAnswer((_) async => {});

      await authStateNotifier.login('new_token');

      expect(authStateNotifier.state, true);
      verify(() => mockSecureStorageService.saveToken('new_token')).called(1);
    });

    test('logout calls auth repository and sets state to false', () async {
      when(() => mockAuthRepository.logout())
          .thenAnswer((_) async => const Success(null));

      await authStateNotifier.logout();

      expect(authStateNotifier.state, false);
      verify(() => mockAuthRepository.logout()).called(1);
    });
  });
}
