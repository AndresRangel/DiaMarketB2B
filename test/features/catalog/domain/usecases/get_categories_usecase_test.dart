import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/catalog/domain/entities/category_entity.dart';
import 'package:entregas_b2b/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:entregas_b2b/features/catalog/domain/usecases/get_categories_usecase.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late GetCategoriesUseCase useCase;
  late MockCatalogRepository mockRepository;

  const tCategory = CategoryEntity(id: 'cat1', name: 'Bebidas');
  const tCategoryChild = CategoryEntity(
    id: 'cat2',
    name: 'Bebidas - Gaseosas',
    parentId: 'cat1',
  );
  final tCategories = [tCategory, tCategoryChild];
  const tFailure = Failure.network('Sin conexión');

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetCategoriesUseCase(mockRepository);
  });

  group('GetCategoriesUseCase', () {
    test('should return list of categories when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => Right(tCategories));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, List<CategoryEntity>>(tCategories));
      verify(() => mockRepository.getCategories()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return NetworkFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, List<CategoryEntity>>(tFailure));
    });

    test('should return empty list when catalog has no categories', () async {
      // Arrange
      when(() => mockRepository.getCategories())
          .thenAnswer((_) async => const Right([]));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Right<Failure, List<CategoryEntity>>([]));
    });
  });
}
