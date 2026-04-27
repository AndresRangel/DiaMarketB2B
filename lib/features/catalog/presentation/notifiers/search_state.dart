import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/product_entity.dart';

part 'search_state.freezed.dart';

@freezed
sealed class SearchState with _$SearchState {
  /// Sin query activa — pantalla inicial con sugerencias o vacía.
  const factory SearchState.initial() = SearchStateInitial;

  /// Debounce corriendo o request en vuelo.
  const factory SearchState.loading() = SearchStateLoading;

  /// Resultados encontrados.
  const factory SearchState.results(List<ProductEntity> products) =
      SearchStateResults;

  /// Query válida pero sin resultados.
  const factory SearchState.empty(String query) = SearchStateEmpty;

  /// Error de red o servidor.
  const factory SearchState.error(String message) = SearchStateError;
}
