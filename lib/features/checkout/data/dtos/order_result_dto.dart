import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_result_dto.g.dart';
part 'order_result_dto.freezed.dart';

/// DTO de respuesta de S19 (crear pedido).
/// Nota: nombres de campo son PLACEHOLDER hasta confirmar con backend.
@freezed
abstract class OrderResultDto with _$OrderResultDto {
  const factory OrderResultDto({
    @JsonKey(name: 'id_pedido') required String orderId,
    @JsonKey(name: 'numero_pedido') required String orderNumber,
    @JsonKey(name: 'total_confirmado') required double confirmedTotal,
    @JsonKey(name: 'mensaje') String? message,
  }) = _OrderResultDto;

  factory OrderResultDto.fromJson(Map<String, dynamic> json) =>
      _$OrderResultDtoFromJson(json);
}
