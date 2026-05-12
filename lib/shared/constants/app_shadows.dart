import 'package:flutter/widgets.dart';

/// Escala de sombras del proyecto.
///
/// level1/2/4 son constantes (sombras neutras).
/// level3 es método: recibe el color de marca para sombra tintada
/// (estado "seleccionado" / "en carrito").
///
/// Uso:
///   decoration: BoxDecoration(boxShadow: AppShadows.level2)
///   decoration: BoxDecoration(boxShadow: AppShadows.level3(primaryColor))
abstract class AppShadows {
  /// Sin sombra (flat)
  static const List<BoxShadow> none = [];

  /// Level 1 — items de lista, cards secundarias
  static const List<BoxShadow> level1 = [
    BoxShadow(
      color: Color(0x0F000000), // negro 6%
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  /// Level 2 — cards estándar (default para ProductCard)
  static const List<BoxShadow> level2 = [
    BoxShadow(
      color: Color(0x14000000), // negro 8%
      blurRadius: 12,
      offset: Offset(0, 3),
    ),
  ];

  /// Level 4 — modales, FABs, elementos flotantes
  static const List<BoxShadow> level4 = [
    BoxShadow(
      color: Color(0x26000000), // negro 15%
      blurRadius: 24,
      offset: Offset(0, 8),
    ),
  ];

  /// Level 3 — card activa / en carrito (sombra tintada con color de marca)
  static List<BoxShadow> level3(Color brandColor) => [
        BoxShadow(
          color: brandColor.withValues(alpha: 0.18),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];
}
