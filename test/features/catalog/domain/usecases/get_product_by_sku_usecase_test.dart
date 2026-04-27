import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/catalog/domain/entities/product_entity.dart';
import 'package:entregas_b2b/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:entregas_b2b/features/catalog/domain/usecases/get_product_by_sku_usecase.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late GetProductBySkuUseCase useCase;
  late MockCatalogRepository mockRepository;

  const tSku = 'SKU001';
  const tProduct = ProductEntity(
    id: '1',
    sku: tSku,
    name: 'Agua Cristal 500ml',
    basePrice: 1500,
    taxRuleId: 1,
  );
  const tFailure = Failure.server('Error del servidor', statusCode: 500);

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetProductBySkuUseCase(mockRepository);
  });

  group('GetProductBySkuUseCase', () {
    test('should return product when SKU exists', () async {
      // Arrange
      when(() => mockRepository.getProductBySku(any()))
          .thenAnswer((_) async => const Right(tProduct));

      // Act
      final result = await useCase(tSku);

      // Assert
      expect(result, const Right<Failure, ProductEntity?>(tProduct));
      verify(() => mockRepository.getProductBySku(tSku)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return Right(null) when SKU not found', () async {
      // Arrange
      when(() => mockRepository.getProductBySku(any()))
          .thenAnswer((_) async => const Right(null));

      // Act
      final result = await useCase(tSku);

      // Assert
      // Right(null) no es error — SKU inexistente es negocio normal, no fallo.
      expect(result, const Right<Failure, ProductEntity?>(null));
    });

    test('should return ValidationFailure when SKU is empty', () async {
      // Act
      final result = await useCase('');

      // Assert
      expect(
        result,
        const Left<Failure, ProductEntity?>(
          Failure.validation('SKU requerido'),
        ),
      );
      verifyZeroInteractions(mockRepository);
    });

    test('should return ValidationFailure when SKU is whitespace only', () async {
      // Act
      final result = await useCase('   ');

      // Assert
      expect(result.isLeft(), isTrue);
      verifyZeroInteractions(mockRepository);
    });

    test('should trim whitespace from SKU before querying repository', () async {
      // Arrange
      when(() => mockRepository.getProductBySku(any()))
          .thenAnswer((_) async => const Right(tProduct));

      // Act
      await useCase('  $tSku  ');

      // Assert — repositorio recibe SKU sin espacios
      verify(() => mockRepository.getProductBySku(tSku)).called(1);
    });

    test('should return ServerFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getProductBySku(any()))
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(tSku);

      // Assert
      expect(result, const Left<Failure, ProductEntity?>(tFailure));
    });
  });
}
