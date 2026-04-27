import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/catalog/domain/entities/product_entity.dart';
import 'package:entregas_b2b/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:entregas_b2b/features/catalog/domain/usecases/search_products_usecase.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late SearchProductsUseCase useCase;
  late MockCatalogRepository mockRepository;

  const tQuery = 'Agua';
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
    useCase = SearchProductsUseCase(mockRepository);
  });

  group('SearchProductsUseCase', () {
    test('should return products when query matches results', () async {
      // Arrange
      when(() => mockRepository.searchProducts(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => Right(tProducts));

      // Act
      final result = await useCase(query: tQuery);

      // Assert
      expect(result, Right<Failure, List<ProductEntity>>(tProducts));
      verify(() =>
              mockRepository.searchProducts(query: tQuery, limit: 20))
          .called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return empty list when no products match query', () async {
      // Arrange
      when(() => mockRepository.searchProducts(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase(query: tQuery);

      // Assert
      // Lista vacía es Right([]) — no es un error, simplemente no hay resultados.
      expect(result, const Right<Failure, List<ProductEntity>>([]));
    });

    test('should return ValidationFailure when query is empty', () async {
      // Act
      final result = await useCase(query: '');

      // Assert
      expect(
        result,
        const Left<Failure, List<ProductEntity>>(
          Failure.validation('Término de búsqueda requerido'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when query is whitespace only', () async {
      // Act
      final result = await useCase(query: '   ');

      // Assert
      expect(result.isLeft(), isTrue);
      verifyZeroInteractions(mockRepository);
    });

    test('should trim whitespace from query before searching', () async {
      // Arrange
      when(() => mockRepository.searchProducts(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => Right(tProducts));

      // Act
      await useCase(query: '  $tQuery  ');

      // Assert — repositorio recibe query sin espacios
      verify(() =>
              mockRepository.searchProducts(query: tQuery, limit: 20))
          .called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.searchProducts(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(query: tQuery);

      // Assert
      expect(result, const Left<Failure, List<ProductEntity>>(tFailure));
    });

    test('should pass custom limit to repository', () async {
      // Arrange
      when(() => mockRepository.searchProducts(
            query: any(named: 'query'),
            limit: any(named: 'limit'),
          )).thenAnswer((_) async => Right(tProducts));

      // Act
      await useCase(query: tQuery, limit: 50);

      // Assert
      verify(() =>
              mockRepository.searchProducts(query: tQuery, limit: 50))
          .called(1);
    });
  });
}
