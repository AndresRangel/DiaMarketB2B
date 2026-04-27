import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/auth/domain/entities/user_entity.dart';
import 'package:entregas_b2b/features/auth/domain/repositories/auth_repository.dart';
import 'package:entregas_b2b/features/auth/domain/usecases/register_usecase.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late RegisterUseCase useCase;
  late MockAuthRepository mockRepository;

  // Datos de prueba válidos
  const tUsername = 'nuevocliente';
  const tPassword = 'pass1234';
  const tPhone = '3001234567';
  const tEmail = 'cliente@example.com';
  const tBusinessType = 'TIENDA';
  const tCityId = 'city_001';

  const tUser = UserEntity(
    id: 'u1',
    username: tUsername,
    email: tEmail,
    isApproved: false, // recién registrado → pendiente de aprobación
  );

  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = RegisterUseCase(mockRepository);
  });

  group('RegisterUseCase', () {
    // ── Caso 1: Registro exitoso ────────────────────────────────────────────
    test('should return UserEntity when registration is successful', () async {
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
          businessType: any(named: 'businessType'),
          cityId: any(named: 'cityId'),
          referralCode: any(named: 'referralCode'),
        ),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await useCase(
        username: tUsername,
        password: tPassword,
        phone: tPhone,
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(result, const Right<Failure, UserEntity>(tUser));
      verify(
        () => mockRepository.register(
          username: tUsername,
          password: tPassword,
          phone: tPhone,
          email: tEmail,
          businessType: tBusinessType,
          cityId: tCityId,
          referralCode: null,
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    // ── Caso 2: Username vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when username is empty', () async {
      final result = await useCase(
        username: '',
        password: tPassword,
        phone: tPhone,
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(
        result,
        const Left<Failure, UserEntity>(
          Failure.validation('Usuario requerido', field: 'username'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 3: Contraseña muy corta ────────────────────────────────────────
    test('should return ValidationFailure when password is too short', () async {
      final result = await useCase(
        username: tUsername,
        password: '123', // menos de 4 caracteres
        phone: tPhone,
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(
        result,
        const Left<Failure, UserEntity>(
          Failure.validation('Contraseña muy corta', field: 'password'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 4: Teléfono vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when phone is empty', () async {
      final result = await useCase(
        username: tUsername,
        password: tPassword,
        phone: '',
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(
        result,
        const Left<Failure, UserEntity>(
          Failure.validation('Teléfono requerido', field: 'phone'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 5: Email vacío ─────────────────────────────────────────────────
    test('should return ValidationFailure when email is empty', () async {
      final result = await useCase(
        username: tUsername,
        password: tPassword,
        phone: tPhone,
        email: '',
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(
        result,
        const Left<Failure, UserEntity>(
          Failure.validation('Correo requerido', field: 'email'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 6: Con código de referido ──────────────────────────────────────
    test('should pass referralCode to repository when provided', () async {
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
          businessType: any(named: 'businessType'),
          cityId: any(named: 'cityId'),
          referralCode: any(named: 'referralCode'),
        ),
      ).thenAnswer((_) async => const Right(tUser));

      await useCase(
        username: tUsername,
        password: tPassword,
        phone: tPhone,
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
        referralCode: 'REF123',
      );

      verify(
        () => mockRepository.register(
          username: tUsername,
          password: tPassword,
          phone: tPhone,
          email: tEmail,
          businessType: tBusinessType,
          cityId: tCityId,
          referralCode: 'REF123',
        ),
      ).called(1);
    });

    // ── Caso 7: El servidor falla ───────────────────────────────────────────
    test('should return ServerFailure when repository fails', () async {
      const tFailure = Failure.server('El usuario ya existe', statusCode: 409);
      when(
        () => mockRepository.register(
          username: any(named: 'username'),
          password: any(named: 'password'),
          phone: any(named: 'phone'),
          email: any(named: 'email'),
          businessType: any(named: 'businessType'),
          cityId: any(named: 'cityId'),
          referralCode: any(named: 'referralCode'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(
        username: tUsername,
        password: tPassword,
        phone: tPhone,
        email: tEmail,
        businessType: tBusinessType,
        cityId: tCityId,
      );

      expect(result, const Left<Failure, UserEntity>(tFailure));
    });
  });
}
