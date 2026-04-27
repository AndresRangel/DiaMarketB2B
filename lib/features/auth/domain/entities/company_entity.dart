import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_entity.freezed.dart';

/// Representa una empresa disponible para el usuario autenticado.
///
/// Tras el login, el servidor puede devolver una o varias empresas.
/// Si hay más de una, la app muestra un selector antes de entrar al Home.
/// La empresa seleccionada determina: catálogo, precios, tema visual y sucursales.
@freezed
abstract class CompanyEntity with _$CompanyEntity {
  const factory CompanyEntity({
    required String id,

    /// Código interno de la empresa en el ERP (ej. "001", "DIA")
    required String code,

    required String name,

    /// URL del logo de esta empresa — puede ser diferente al branding global
    String? logoUrl,
  }) = _CompanyEntity;
}
