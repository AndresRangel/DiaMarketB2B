import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/auth/domain/repositories/auth_repository.dart';
import 'package:entregas_b2b/features/auth/domain/usecases/recover_password_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RecoverPasswordUseCase useCase;
  late MockAuthRepository mockRepository;

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RecoverPasswordUseCase(mockRepository);
  });

  group('RecoverPasswordUseCase', () {
    // ── Caso 1: Con username ────────────────────────────────────────────────
    test('should call repository when username is provided', () async {
      when(
        () => mockRepository.recoverPassword(
          username: any(named: 'username'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(username: 'testuser');

      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.recoverPassword(
          username: 'testuser',
          email: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // ── Caso 2: Con email ───────────────────────────────────────────────────
    test('should call repository when email is provided', () async {
      when(
        () => mockRepository.recoverPassword(
          username: any(named: 'username'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(email: 'test@example.com');

      expect(result, const Right<Failure, void>(null));
      verify(
        () => mockRepository.recoverPassword(
          username: null,
          email: 'test@example.com',
        ),
      ).called(1);
    });

    // ── Caso 3: Con ambos (username y email) ────────────────────────────────
    test('should call repository when both username and email are provided',
        () async {
      when(
        () => mockRepository.recoverPassword(
          username: any(named: 'username'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(
        username: 'testuser',
        email: 'test@example.com',
      );

      expect(result, const Right<Failure, void>(null));
    });

    // ── Caso 4: Sin ninguno de los dos ─────────────────────────────────────
    test('should return ValidationFailure when both username and email are empty',
        () async {
      final result = await useCase();

      expect(
        result,
        const Left<Failure, void>(
          Failure.validation('Ingresa tu usuario o correo electrónico'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 5: Ambos son espacios ──────────────────────────────────────────
    test('should return ValidationFailure when both are only spaces', () async {
      final result = await useCase(username: '   ', email: '   ');

      expect(
        result,
        const Left<Failure, void>(
          Failure.validation('Ingresa tu usuario o correo electrónico'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 6: El servidor falla ───────────────────────────────────────────
    test('should return ServerFailure when repository fails', () async {
      const tFailure = Failure.server('Usuario no encontrado', statusCode: 404);
      when(
        () => mockRepository.recoverPassword(
          username: any(named: 'username'),
          email: any(named: 'email'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(username: 'testuser');

      expect(result, const Left<Failure, void>(tFailure));
    });
  });
}
