import 'package:flutter/widgets.dart';

/// Escala de border radius del proyecto.
///
/// Usar siempre estos tokens en lugar de números literales.
/// Incorrecto: BorderRadius.circular(14)
/// Correcto:   BorderRadius.circular(AppRadius.md)
abstract class AppRadius {
  static const double xs = 4;    // Tags, chips compactos
  static const double sm = 8;    // Inputs, botones compactos, chips de filtro
  static const double md = 12;   // Cards estándar, botones principales
  static const double lg = 16;   // Cards destacadas, bottom sheets
  static const double xl = 20;   // Banners, contenedores hero
  static const double full = 999; // Pills, badges, avatares

  // Helpers de BorderRadius frecuentes
  static BorderRadius get cardMd => BorderRadius.circular(md);
  static BorderRadius get cardLg => BorderRadius.circular(lg);
  static BorderRadius get pill => BorderRadius.circular(full);
  static BorderRadius get chipSm => BorderRadius.circular(sm);
}
