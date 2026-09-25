import 'package:flutter_manga_sync/features/auth/data/auth_repository.dart';
import 'package:flutter_manga_sync/features/auth/presentation/providers/auth_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_provider_test.mocks.dart';

@GenerateMocks([AuthRepository])
void main() {
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
  });

  group('AuthNotifier Unit Tests', () {
    test('login calls repository login method', () async {
      when(mockAuthRepository.login('eve.holt@reqres.in', 'cityslicka'))
          .thenAnswer((_) async => 'QpwL5tke4Pnpja7X4');

      final notifier = AuthNotifier(mockAuthRepository);
      await notifier.login('eve.holt@reqres.in', 'cityslicka');

      verify(mockAuthRepository.login('eve.holt@reqres.in', 'cityslicka'))
          .called(1);
    });

    test('register calls repository register method', () async {
      when(mockAuthRepository.register('eve.holt@reqres.in', 'pistol'))
          .thenAnswer((_) async => 'QpwL5tke4Pnpja7X4');

      final notifier = AuthNotifier(mockAuthRepository);
      await notifier.register('eve.holt@reqres.in', 'pistol');

      verify(mockAuthRepository.register('eve.holt@reqres.in', 'pistol'))
          .called(1);
    });
  });
}
