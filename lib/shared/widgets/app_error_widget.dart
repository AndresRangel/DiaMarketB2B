import 'package:flutter/material.dart';

/// Widget de error con mensaje y botón "Reintentar".
///
/// Se usa dentro del .when() de un AsyncValue cuando hay error:
/// ```dart
/// catalogState.when(
///   loading: () => const LoadingIndicator(),
///   error: (e, _) => AppErrorWidget(
///     message: e.toString(),
///     onRetry: () => ref.read(catalogNotifierProvider.notifier).refresh(),
///   ),
///   data: (products) => ProductList(products),
/// )
/// ```
class AppErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                // 'Reintentar' — se conectará con TrKeys.retry.tr() en Bloque 10
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
