import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.g.dart';
part 'category_dto.freezed.dart';

/// Modelo de categoría tal como lo devuelve Supabase (public.categories_v).
@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String id,
    required String name,
    @JsonKey(name: 'parent_id') String? parentId,
    @JsonKey(name: 'sort_order') int? sortOrder,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
