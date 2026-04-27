import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Caja con efecto shimmer (skeleton loading).
///
/// Uso:
///   ShimmerBox(height: 20, width: 120)         // width fija
///   ShimmerBox(height: 20)                      // width = double.infinity
///   ShimmerBox(height: 20, radius: 50)          // círculo si width == height
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.radius = 8,
  });

  final double height;
  final double width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
