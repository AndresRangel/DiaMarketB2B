import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/theme/theme_notifier.dart';
import '../constants/app_radius.dart';

/// Caja con efecto shimmer (skeleton loading).
///
/// Colores derivados del tema dinámico — compatible con cualquier
/// configuración de branding del backend.
///
/// Uso:
///   ShimmerBox(height: 20, width: 120)   // width fija
///   ShimmerBox(height: 20)               // width = double.infinity
///   ShimmerBox(height: 40, radius: AppRadius.full)  // badge / avatar
class ShimmerBox extends ConsumerWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.radius = AppRadius.sm,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final baseColor = theme.theme.textSecondaryColor.withValues(alpha: 0.12);
    final highlightColor = theme.theme.surfaceColor;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          // El paquete shimmer requiere un color sólido en el child
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
