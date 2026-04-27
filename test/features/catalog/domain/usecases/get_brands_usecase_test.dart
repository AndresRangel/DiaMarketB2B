import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

import 'package:entregas_b2b/core/error/failures.dart';
import 'package:entregas_b2b/features/catalog/domain/entities/brand_entity.dart';
import 'package:entregas_b2b/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:entregas_b2b/features/catalog/domain/usecases/get_brands_usecase.dart';

class MockCatalogRepository extends Mock implements CatalogRepository {}

void main() {
  late GetBrandsUseCase useCase;
  late MockCatalogRepository mockRepository;

  const tBrand = BrandEntity(id: 'b1', name: 'Postobón');
  const tBrand2 = BrandEntity(id: 'b2', name: 'Cristal');
  final tBrands = [tBrand, tBrand2];
  const tFailure = Failure.network('Sin conexión');

  setUp(() {
    mockRepository = MockCatalogRepository();
    useCase = GetBrandsUseCase(mockRepository);
  });

  group('GetBrandsUseCase', () {
    test('should return list of brands when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.getBrands(
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => Right(tBrands));

      // Act
      final result = await useCase();

      // Assert
      expect(result, Right<Failure, List<BrandEntity>>(tBrands));
      verify(() => mockRepository.getBrands(limit: 100, query: null)).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should pass query to repository when provided', () async {
      // Arrange
      when(() => mockRepository.getBrands(
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => Right([tBrand]));

      // Act
      await useCase(query: 'Postobon');

      // Assert
      verify(() =>
              mockRepository.getBrands(limit: 100, query: 'Postobon'))
          .called(1);
    });

    test('should pass custom limit to repository', () async {
      // Arrange
      when(() => mockRepository.getBrands(
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => Right(tBrands));

      // Act
      await useCase(limit: 20);

      // Assert
      verify(() => mockRepository.getBrands(limit: 20, query: null)).called(1);
    });

    test('should return NetworkFailure when repository fails', () async {
      // Arrange
      when(() => mockRepository.getBrands(
            limit: any(named: 'limit'),
            query: any(named: 'query'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase();

      // Assert
      expect(result, const Left<Failure, List<BrandEntity>>(tFailure));
    });
  });
}
