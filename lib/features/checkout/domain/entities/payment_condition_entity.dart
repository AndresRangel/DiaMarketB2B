import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_condition_entity.freezed.dart';

/// Condición de pago disponible para el cliente (S24).
///
/// Ej: "Contado", "30 días", "60 días".
/// Cada cliente puede tener condiciones distintas según su cartera.
@freezed
abstract class PaymentConditionEntity with _$PaymentConditionEntity {
  const factory PaymentConditionEntity({
    required String id,
    required String code,
    required String name,

    /// Plazo en días. 0 = contado.
    @Default(0) int days,

    String? description,
  }) = _PaymentConditionEntity;

  const PaymentConditionEntity._();

  /// True si es pago inmediato (contado).
  bool get isCash => days == 0;

  /// Label legible: "Contado" o "30 días".
  String get displayLabel => isCash ? name : '$name ($days días)';
}
