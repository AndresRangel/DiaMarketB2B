import 'package:freezed_annotation/freezed_annotation.dart';

// Este archivo le dice a Dart que el código generado por freezed
// se encontrará en 'failures.freezed.dart'. build_runner lo crea automáticamente.
part 'failures.freezed.dart';

/// Representa todos los posibles tipos de error de la app.
///
/// En lugar de lanzar excepciones que se propagan sin control,
/// los Use Cases retornan [Either<Failure, T>]:
///   - Left(failure) → algo salió mal
///   - Right(value)  → todo bien, aquí está el resultado
///
/// El uso de [freezed] con [sealed class] garantiza que la UI
/// esté obligada a manejar TODOS los tipos de error en un switch.
@freezed
sealed class Failure with _$Failure {
  /// Error que viene del servidor (código HTTP 4xx / 5xx con mensaje).
  const factory Failure.server(String message, {int? statusCode}) = ServerFailure;

  /// Error de cache (lectura/escritura en Hive falló).
  const factory Failure.cache(String message) = CacheFailure;

  /// Sin conexión a internet o timeout.
  const factory Failure.network(String message) = NetworkFailure;

  /// Datos inválidos antes de llegar al servidor (validación local).
  const factory Failure.validation(String message, {String? field}) = ValidationFailure;

  /// El servidor devolvió 401 — sesión expirada o token inválido.
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;

  /// Cualquier error inesperado no categorizado.
  const factory Failure.unknown(String message) = UnknownFailure;
}
