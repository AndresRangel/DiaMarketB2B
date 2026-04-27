import 'package:freezed_annotation/freezed_annotation.dart';

part 'branch_entity.freezed.dart';

/// Sucursal de entrega del cliente (S14).
///
/// Cada sucursal tiene su propia lista de precios y condiciones.
/// El usuario selecciona una al momento del checkout.
@freezed
abstract class BranchEntity with _$BranchEntity {
  const factory BranchEntity({
    required String id,
    required String code,
    required String name,

    /// Dirección física de la sucursal.
    String? address,

    /// Ciudad / municipio.
    String? city,

    String? phone,

    /// Lista de precios asociada a esta sucursal.
    String? priceListId,

    /// Si es la sucursal por defecto del cliente.
    @Default(false) bool isDefault,
  }) = _BranchEntity;
}
