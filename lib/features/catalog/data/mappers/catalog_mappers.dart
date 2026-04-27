import '../../domain/entities/brand_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../dtos/brand_dto.dart';
import '../dtos/category_dto.dart';
import '../dtos/product_dto.dart';

extension ProductDtoMapper on ProductDto {
  ProductEntity toEntity() => ProductEntity(
        id: id,
        sku: sku,
        name: name,
        basePrice: basePrice,
        imageUrl: imageUrl,
        brandId: brandId,
        categoryId: categoryId,
        taxRuleId: taxRuleId,
        discount: discount,
        icoAmount: icoAmount,
        isActive: isActive,
      );
}

extension CategoryDtoMapper on CategoryDto {
  CategoryEntity toEntity() => CategoryEntity(
        id: id,
        name: name,
        parentId: parentId,
        sortOrder: sortOrder,
        imageUrl: imageUrl,
        isActive: isActive,
      );
}

extension BrandDtoMapper on BrandDto {
  BrandEntity toEntity() => BrandEntity(
        id: id,
        name: name,
        providerId: providerId,
        isActive: isActive,
      );
}
