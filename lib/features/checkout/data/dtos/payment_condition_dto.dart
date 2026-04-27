import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_condition_dto.g.dart';
part 'payment_condition_dto.freezed.dart';

/// DTO de condición de pago tal como lo devuelve S24.
/// Nota: nombres de campo son PLACEHOLDER hasta confirmar con backend.
@freezed
abstract class PaymentConditionDto with _$PaymentConditionDto {
  const factory PaymentConditionDto({
    required String id,
    @JsonKey(name: 'codigo') required String code,
    @JsonKey(name: 'nombre') required String name,
    @JsonKey(name: 'dias') @Default(0) int days,
    @JsonKey(name: 'descripcion') String? description,
  }) = _PaymentConditionDto;

  factory PaymentConditionDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentConditionDtoFromJson(json);
}
