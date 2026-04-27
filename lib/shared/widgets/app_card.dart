import 'package:flutter/material.dart';

/// Contenedor con sombra y bordes redondeados.
/// Base para tarjetas de productos, pedidos, resúmenes, etc.
///
/// Uso:
/// ```dart
/// AppCard(
///   child: ProductCardContent(product: product),
/// )
///
/// // Con tap:
/// AppCard(
///   onTap: () => context.go(AppRoutes.productDetail),
///   child: ProductCardContent(product: product),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      // El color por defecto toma surfaceColor del tema activo
      color: color ?? Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}
