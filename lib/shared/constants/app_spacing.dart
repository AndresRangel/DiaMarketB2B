import 'package:flutter/widgets.dart';

/// Escala de espaciado del proyecto. Base: 4px.
///
/// Usar siempre estos tokens en lugar de números literales.
/// Incorrecto: SizedBox(height: 10) o EdgeInsets.all(6)
/// Correcto:   SizedBox(height: AppSpacing.sm) o EdgeInsets.all(AppSpacing.md)
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;

  // Helpers de EdgeInsets frecuentes
  static const EdgeInsets cardPadding = EdgeInsets.all(base);
  static const EdgeInsets cardPaddingH = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets cardPaddingV = EdgeInsets.symmetric(vertical: base);
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: base);
  static const EdgeInsets listItemPadding =
      EdgeInsets.symmetric(horizontal: base, vertical: sm);
}
