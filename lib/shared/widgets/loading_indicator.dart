import 'package:flutter/material.dart';

/// Spinner de carga centrado en pantalla.
///
/// Se usa dentro del .when() de un AsyncValue de Riverpod:
/// ```dart
/// catalogState.when(
///   loading: () => const LoadingIndicator(),
///   error: (e, _) => AppErrorWidget(...),
///   data: (products) => ProductList(products),
/// )
/// ```
class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
