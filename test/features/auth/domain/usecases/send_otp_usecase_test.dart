import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/auth/domain/repositories/auth_repository.dart';
import 'package:entregas_b2b/features/auth/domain/usecases/send_otp_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SendOtpUseCase useCase;
  late MockAuthRepository mockRepository;

  const tPhone = '3001234567';

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = SendOtpUseCase(mockRepository);
  });

  group('SendOtpUseCase', () {
    // ── Caso 1: SMS enviado exitosamente ────────────────────────────────────
    test('should return Right(void) when OTP is sent successfully', () async {
      // void se representa como Right(null) en fpdart
      when(
        () => mockRepository.sendOtp(any()),
      ).thenAnswer((_) async => const Right(null));

      final result = await useCase(tPhone);

      expect(result, const Right<Failure, void>(null));
      verify(() => mockRepository.sendOtp(tPhone)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // ── Caso 2: Teléfono vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when phone is empty', () async {
      final result = await useCase('');

      expect(
        result,
        const Left<Failure, void>(
          Failure.validation('Teléfono requerido', field: 'phone'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 3: Teléfono solo espacios ─────────────────────────────────────
    test('should return ValidationFailure when phone is only spaces', () async {
      final result = await useCase('   ');

      expect(
        result,
        const Left<Failure, void>(
          Failure.validation('Teléfono requerido', field: 'phone'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 4: El Use Case aplica trim() al teléfono ──────────────────────
    test('should trim phone before calling repository', () async {
      when(
        () => mockRepository.sendOtp(any()),
      ).thenAnswer((_) async => const Right(null));

      await useCase('  3001234567  ');

      // El repositorio debe recibir el teléfono SIN espacios
      verify(() => mockRepository.sendOtp('3001234567')).called(1);
    });

    // ── Caso 5: El servidor falla ───────────────────────────────────────────
    test('should return NetworkFailure when there is no connection', () async {
      const tFailure = Failure.network('Sin conexión');
      when(
        () => mockRepository.sendOtp(any()),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(tPhone);

      expect(result, const Left<Failure, void>(tFailure));
    });
  });
}
