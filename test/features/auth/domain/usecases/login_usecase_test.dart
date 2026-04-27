// Los tests de Use Cases son Dart puro — sin Flutter, sin widgets.
// Solo necesitamos flutter_test para el runner y mocktail para los mocks.
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/auth/domain/entities/auth_session_entity.dart';
import 'package:entregas_b2b/features/auth/domain/entities/company_entity.dart';
import 'package:entregas_b2b/features/auth/domain/entities/user_entity.dart';
import 'package:entregas_b2b/features/auth/domain/repositories/auth_repository.dart';
import 'package:entregas_b2b/features/auth/domain/usecases/login_usecase.dart';

// ── Mock del repositorio ──────────────────────────────────────────────────────
// Mocktail crea un "doble" del repositorio que podemos programar:
// "cuando llamen a login() con estos datos, retorna esto".
// Así el test no toca la red ni el disco — es 100% predecible y rápido.
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // ── Variables compartidas entre todos los tests ───────────────────────────
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  // Datos de prueba — prefijo 't' para distinguirlos de variables de producción
  const tUsername = 'testuser';
  const tPassword = 'password123';

  final tUser = const UserEntity(
    id: '1',
    username: tUsername,
    email: 'test@example.com',
  );

  final tCompany = const CompanyEntity(
    id: 'c1',
    name: 'Empresa Test',
    code: 'EMP001',
  );

  final tSession = AuthSessionEntity(
    user: tUser,
    sessionToken: 'token_abc123',
    companies: [tCompany],
    selectedCompany: tCompany,
  );

  // setUp se ejecuta ANTES de cada test individual.
  // Garantiza que cada test empieza con un estado limpio.
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  // group agrupa tests relacionados bajo un nombre común.
  // En el output verás: "LoginUseCase > should return session..."
  group('LoginUseCase', () {
    // ── Caso 1: Happy path ──────────────────────────────────────────────────
    test('should return AuthSession when credentials are valid', () async {
      // Arrange: programar el mock para que retorne la sesión cuando
      // llamen a login() con cualquier username y password.
      // any(named: 'username') significa "acepta cualquier valor para el parámetro username"
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          fcmToken: any(named: 'fcmToken'),
          imei: any(named: 'imei'),
          companyCode: any(named: 'companyCode'),
        ),
      ).thenAnswer((_) async => Right(tSession));

      // Act: ejecutar el Use Case con datos válidos
      final result = await useCase(
        username: tUsername,
        password: tPassword,
      );

      // Assert: verificar que retornó Right con la sesión esperada
      expect(result, Right<Failure, AuthSessionEntity>(tSession));

      // Verificar que el repositorio fue llamado exactamente 1 vez
      // con los parámetros correctos (trim() ya aplicado)
      verify(
        () => mockRepository.login(
          username: tUsername,
          password: tPassword,
          fcmToken: null,
          imei: null,
          companyCode: null,
        ),
      ).called(1);

      // Verificar que no hubo ninguna otra llamada al repositorio
      verifyNoMoreInteractions(mockRepository);
    });

    // ── Caso 2: Username vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when username is empty', () async {
      // Act: llamar con username vacío
      final result = await useCase(username: '', password: tPassword);

      // Assert: debe retornar Left con ValidationFailure
      expect(
        result,
        const Left<Failure, AuthSessionEntity>(
          Failure.validation('Usuario requerido', field: 'username'),
        ),
      );

      // El repositorio NO debe ser llamado si la validación falla
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 3: Username solo espacios ─────────────────────────────────────
    test('should return ValidationFailure when username is only spaces',
        () async {
      final result = await useCase(username: '   ', password: tPassword);

      expect(
        result,
        const Left<Failure, AuthSessionEntity>(
          Failure.validation('Usuario requerido', field: 'username'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 4: Password vacío ──────────────────────────────────────────────
    test('should return ValidationFailure when password is empty', () async {
      final result = await useCase(username: tUsername, password: '');

      expect(
        result,
        const Left<Failure, AuthSessionEntity>(
          Failure.validation('Contraseña requerida', field: 'password'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    // ── Caso 5: El servidor falla ───────────────────────────────────────────
    test('should return ServerFailure when repository returns ServerFailure',
        () async {
      // Arrange: el mock simula que el servidor respondió con error 401
      const tFailure = Failure.server('Usuario o contraseña incorrectos', statusCode: 401);
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          fcmToken: any(named: 'fcmToken'),
          imei: any(named: 'imei'),
          companyCode: any(named: 'companyCode'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(username: tUsername, password: tPassword);

      // Assert
      expect(result, const Left<Failure, AuthSessionEntity>(tFailure));
      verify(
        () => mockRepository.login(
          username: tUsername,
          password: tPassword,
          fcmToken: null,
          imei: null,
          companyCode: null,
        ),
      ).called(1);
    });

    // ── Caso 6: Sin conexión ────────────────────────────────────────────────
    test('should return NetworkFailure when there is no connection', () async {
      const tFailure = Failure.network('Sin conexión');
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          fcmToken: any(named: 'fcmToken'),
          imei: any(named: 'imei'),
          companyCode: any(named: 'companyCode'),
        ),
      ).thenAnswer((_) async => const Left(tFailure));

      final result = await useCase(username: tUsername, password: tPassword);

      expect(result, const Left<Failure, AuthSessionEntity>(tFailure));
    });

    // ── Caso 7: El Use Case aplica trim() al username ───────────────────────
    test('should trim username before calling repository', () async {
      when(
        () => mockRepository.login(
          username: any(named: 'username'),
          password: any(named: 'password'),
          fcmToken: any(named: 'fcmToken'),
          imei: any(named: 'imei'),
          companyCode: any(named: 'companyCode'),
        ),
      ).thenAnswer((_) async => Right(tSession));

      // Llamamos con espacios al inicio y al final
      await useCase(username: '  testuser  ', password: tPassword);

      // Verificamos que el repositorio recibió el username SIN espacios
      verify(
        () => mockRepository.login(
          username: 'testuser', // ← sin espacios
          password: tPassword,
          fcmToken: null,
          imei: null,
          companyCode: null,
        ),
      ).called(1);
    });
  });
}
