import 'package:flutter/material.dart';

import 'breakpoints.dart';

/// Extensiones de BuildContext para diseño responsive.
///
/// Uso:
/// ```dart
/// if (context.isMobile) { ... }
///
/// ConstrainedBox(
///   constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
/// )
/// ```
extension ResponsiveContext on BuildContext {
  /// True si el ancho de la pantalla es de móvil (< 600px)
  bool get isMobile => MediaQuery.sizeOf(this).width < Breakpoints.mobile;

  /// True si el ancho está entre móvil y tablet
  bool get isTablet =>
      MediaQuery.sizeOf(this).width >= Breakpoints.mobile &&
      MediaQuery.sizeOf(this).width < Breakpoints.tablet;

  /// True si es desktop o más grande
  bool get isDesktop => MediaQuery.sizeOf(this).width >= Breakpoints.tablet;

  /// Ancho máximo recomendado para contenido textual (forms, login, perfil, etc.)
  ///
  /// En móvil retorna infinity (ocupa todo el ancho).
  /// En desktop/web limita a 600px y centra el contenido.
  /// Esto evita que los formularios queden ridículamente estirados en web
  /// sin afectar para nada la experiencia móvil.
  double get contentMaxWidth => isDesktop ? 600 : double.infinity;

  /// Ancho máximo para páginas de catálogo, listas y contenido amplio.
  ///
  /// En móvil retorna infinity. En desktop limita a 1400px centrado.
  double get catalogMaxWidth => isDesktop ? 1400 : double.infinity;
}
