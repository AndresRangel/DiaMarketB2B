import 'package:flutter/widgets.dart';

/// Escala tipográfica del proyecto.
///
/// Estos estilos definen SOLO tamaño, peso, altura de línea y espaciado.
/// Color y fontFamily siempre se aplican en el widget con .copyWith():
///
///   Text(
///     'Precio',
///     style: AppTextStyles.priceDisplay.copyWith(
///       color: primaryColor,
///       fontFamily: fontFamily,
///     ),
///   )
///
/// Esto mantiene la compatibilidad con el sistema white-label (colores y fuente
/// vienen del ThemeNotifier, no están hardcodeados aquí).
abstract class AppTextStyles {
  // ── Pantallas y títulos grandes ──────────────────────────────────────────

  /// 28sp / w700 — Heros, montos grandes, pantallas de éxito
  static const TextStyle displayLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
  );

  // ── Títulos ──────────────────────────────────────────────────────────────

  /// 20sp / w700 — Título de página, nombre de producto en detalle
  static const TextStyle titleLarge = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: -0.3,
  );

  /// 17sp / w600 — Encabezados de sección, títulos de card
  static const TextStyle titleMedium = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.25,
    letterSpacing: -0.2,
  );

  /// 15sp / w600 — Subtítulos, etiquetas de sección
  static const TextStyle titleSmall = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.1,
  );

  // ── Cuerpo ───────────────────────────────────────────────────────────────

  /// 15sp / w400 — Texto de cuerpo principal, descripciones
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// 13sp / w400 — Texto secundario, filas de tabla, info complementaria
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  // ── Etiquetas ────────────────────────────────────────────────────────────

  /// 13sp / w600 — Botones primarios, etiquetas importantes
  static const TextStyle labelLarge = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.0,
    letterSpacing: 0.2,
  );

  /// 12sp / w500 — Chips, badges, etiquetas secundarias
  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.2,
  );

  /// 11sp / w500 — Captions, timestamps, notas al pie
  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.0,
    letterSpacing: 0.3,
  );

  // ── Precios (B2B — siempre prominentes) ─────────────────────────────────

  /// 18sp / w700 — Precio unitario principal (ProductDetailPage, sticky bar)
  static const TextStyle priceDisplay = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.2,
  );

  /// 15sp / w700 — Precio en ProductCard (grid)
  static const TextStyle priceMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: -0.1,
  );

  /// 13sp / w600 — Filas de desglose (IVA, descuento, ICO)
  static const TextStyle priceSmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0,
  );

  // ── Nombre de producto en grid ───────────────────────────────────────────

  /// 13sp / w500 — Nombre en ProductCard (grid). Subido de 12sp.
  static const TextStyle productName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );

  /// 11sp / w500 — Nombre en FeaturedProductCard (scroll horizontal)
  static const TextStyle productNameSmall = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 1.3,
    letterSpacing: 0,
  );
}
