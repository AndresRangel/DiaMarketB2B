import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand_dto.g.dart';
part 'brand_dto.freezed.dart';

/// Modelo de marca tal como lo devuelve Supabase (public.brands_v).
@freezed
abstract class BrandDto with _$BrandDto {
  const factory BrandDto({
    required String id,
    required String name,
    @JsonKey(name: 'provider_id') String? providerId,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
  }) = _BrandDto;

  factory BrandDto.fromJson(Map<String, dynamic> json) =>
      _$BrandDtoFromJson(json);
}
