import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/catalog/domain/entities/product_entity.dart';
import 'package:entregas_b2b/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:entregas_b2b/features/catalog/domain/usecases/get_products_usecase.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late GetProductsUseCase useCase;
  late MockCatalogRepository mockRepository;

  const tProduct = ProductEntity(
    id: '1',
    sku: 'SKU001',
    name: 'Agua Cristal 500ml',
    basePrice: 1500,
  );
  final tProducts = [tProduct];
  const tFailure = Failure.server('Error del servidor', statusCode: 500);

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetProductsUseCase(mockRepository);
  });

  group('GetProductsUseCase', () {
    test('should return list of products when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getProducts(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Right(tProducts));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, List<ProductEntity>>(tProducts));
      verify(() => mockRepository.getProducts(limit: 50, offset: 0)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getProducts(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, List<ProductEntity>>(tFailure));
    });

    test('should pass custom limit and offset to repository', () async {
      // Arrange
      when(() => mockRepository.getProducts(
            limit: any(named: 'limit'),
            offset: any(named: 'offset'),
          )).thenAnswer((_) async => Right(tProducts));

      // Act
      await useCase(limit: 20, offset: 40);

      // Assert
      verify(() => mockRepository.getProducts(limit: 20, offset: 40)).called(1);
    });
  });
}
