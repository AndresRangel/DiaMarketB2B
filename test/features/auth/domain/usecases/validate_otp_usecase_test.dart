import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/auth/domain/repositories/auth_repository.dart';
import 'package:entregas_b2b/features/auth/domain/usecases/validate_otp_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late ValidateOtpUseCase useCase;
  late MockAuthRepository mockRepository;

  const tPhone = '3001234567';
  const tCode = '123456';

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = ValidateOtpUseCase(mockRepository);
  });

  group('ValidateOtpUseCase', () {
    // ── Caso 1: OTP válido ──────────────────────────────────────────────────
    test('should return true when OTP is valid', () async {
      when(
        () => mockRepository.validateOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => const Right(true));

      final result = await useCase(phone: tPhone, code: tCode);

      expect(result, const Right<Failure, bool>(true));
      verify(
        () => mockRepository.validateOtp(phone: tPhone, code: tCode),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // ── Caso 2: OTP incorrecto (servidor dice false) ────────────────────────
    test('should return false when OTP is incorrect', () async {
      when(
        () => mockRepository.validateOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => const Right(false));

      final result = await useCase(phone: tPhone, code: tCode);

      expect(result, const Right<Failure, bool>(false));
    });

    // ── Caso 3: Teléfono vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when phone is empty', () async {
      final result = await useCase(phone: '', code: tCode);

      expect(
        result,
        const Left<Failure, bool>(
          Failure.validation('Teléfono requerido', field: 'phone'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 4: Código de menos de 6 dígitos ───────────────────────────────
    test('should return ValidationFailure when code has less than 6 digits',
        () async {
      final result = await useCase(phone: tPhone, code: '123');

      expect(
        result,
        const Left<Failure, bool>(
          Failure.validation('El código debe tener 6 dígitos', field: 'code'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 5: Código de más de 6 dígitos ─────────────────────────────────
    test('should return ValidationFailure when code has more than 6 digits',
        () async {
      final result = await useCase(phone: tPhone, code: '1234567');

      expect(
        result,
        const Left<Failure, bool>(
          Failure.validation('El código debe tener 6 dígitos', field: 'code'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 6: El servidor falla ───────────────────────────────────────────
    test('should return ServerFailure when repository fails', () async {
      const tFailure = Failure.server('Código expirado', statusCode: 400);
      when(
        () => mockRepository.validateOtp(
          phone: any(named: 'phone'),
          code: any(named: 'code'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(phone: tPhone, code: tCode);

      expect(result, const Left<Failure, bool>(tFailure));
    });
  });
}
