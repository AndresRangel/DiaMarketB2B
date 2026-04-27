import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_dto.g.dart';
part 'branch_dto.freezed.dart';

/// DTO de sucursal tal como lo devuelve S14.
/// Nota: nombres de campo son PLACEHOLDER hasta confirmar con backend.
@freezed
abstract class BranchDto with _$BranchDto {
  const factory BranchDto({
    required String id,
    @JsonKey(name: 'codigo') required String code,
    @JsonKey(name: 'nombre') required String name,
    @JsonKey(name: 'direccion') String? address,
    @JsonKey(name: 'ciudad') String? city,
    @JsonKey(name: 'telefono') String? phone,
    @JsonKey(name: 'id_lista_precios') String? priceListId,
    @JsonKey(name: 'es_principal') @Default(false) bool isDefault,
  }) = _BranchDto;

  factory BranchDto.fromJson(Map<String, dynamic> json) =>
      _$BranchDtoFromJson(json);
}
