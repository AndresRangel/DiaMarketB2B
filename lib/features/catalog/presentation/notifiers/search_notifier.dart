import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/error/failures.dart';
import 'catalog_notifier.dart';
import 'search_state.dart';

part 'search_notifier.g.dart';

// keepAlive: persiste en memoria mientras la app esté abierta (survives navigation).
@Riverpod(keepAlive: true)
class RecentSearches extends _$RecentSearches {
  @override
  List<String> build() => [];

  void add(String query) {
    final q = query.trim();
    if (q.isEmpty) return;
    state = [q, ...state.where((s) => s != q)].take(6).toList();
  }

  void remove(String query) =>
      state = state.where((s) => s != query).toList();

  void clearAll() => state = [];
}

@riverpod
class SearchNotifier extends _$SearchNotifier {
  Timer? _debounce;

  @override
  SearchState build() {
    // Cancela el timer pendiente si el provider se destruye.
    ref.onDispose(() => _debounce?.cancel());
    return const SearchState.initial();
  }

  void search(String query) {
    _debounce?.cancel();

    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    // Espera 400ms desde el último keystroke antes de ir a la red.
    state = const SearchState.loading();
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      // Guarda el query final (debounced), no cada letra parcial.
      ref.read(recentSearchesProvider.notifier).add(query.trim());
      final useCase = ref.read(searchProductsUseCaseProvider);
      final result = await useCase(query: query.trim());

      state = result.fold(
        (failure) => SearchState.error(failure.when(
          server: (msg, _) => msg,
          cache: (msg) => msg,
          network: (_) => 'Sin conexión. Verifica tu internet.',
          validation: (msg, _) => msg,
          unauthorized: (_) => 'Sin autorización.',
          unknown: (msg) => msg,
        )),
        (products) => products.isEmpty
            ? SearchState.empty(query.trim())
            : SearchState.results(products),
      );
    });
  }

  void clear() {
    _debounce?.cancel();
    state = const SearchState.initial();
  }
}
