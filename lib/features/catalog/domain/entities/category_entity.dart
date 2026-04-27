import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Categoría del catálogo. Estructura de árbol de dos niveles:
///   - Categoría raíz: [parentId] == null (12 categorías padre)
///   - Subcategoría:   [parentId] != null (40 hijas)
///
/// Viene de public.categories_v en Supabase.
@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    required String id,
    required String name,

    /// null = categoría raíz. Si tiene valor = subcategoría hija.
    String? parentId,

    /// Posición de orden para el menú. Puede ser null si no está definido.
    int? sortOrder,

    /// URL de imagen de la categoría desde el CDN. Null si no viene del backend.
    String? imageUrl,

    @Default(true) bool isActive,
  }) = _CategoryEntity;

  const CategoryEntity._();

  /// true si es una categoría raíz (primer nivel del menú).
  bool get isRoot => parentId == null;
}
