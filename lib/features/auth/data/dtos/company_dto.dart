import 'package:freezed_annotation/freezed_annotation.dart';

part 'company_dto.g.dart';
part 'company_dto.freezed.dart';

/// Modelo de empresa tal como lo devuelve el backend (dentro de S01).
@freezed
abstract class CompanyDto with _$CompanyDto {
  const factory CompanyDto({
    required String id,
    required String code,
    required String name,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _CompanyDto;

  factory CompanyDto.fromJson(Map<String, dynamic> json) =>
      _$CompanyDtoFromJson(json);
}
