import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_entity.freezed.dart';

/// Marca de un producto del catálogo.
/// Viene de public.brands_v en Supabase (817 registros).
@freezed
abstract class BrandEntity with _$BrandEntity {
  const factory BrandEntity({
    required String id,
    required String name,

    /// FK hacia proveedor. Puede ser null si la marca no tiene proveedor asignado.
    String? providerId,

    @Default(true) bool isActive,
  }) = _BrandEntity;
}
