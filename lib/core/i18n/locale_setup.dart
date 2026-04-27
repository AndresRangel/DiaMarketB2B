import 'package:flutter/material.dart';

/// Configuración central de idiomas soportados por la app.
///
/// Se usa en dos lugares:
/// 1. En main_*.dart para envolver la app con EasyLocalization
/// 2. En el MaterialApp para registrar los locales soportados
class LocaleSetup {
  /// Ruta donde están los archivos JSON de traducción.
  /// Debe coincidir con lo declarado en pubspec.yaml (assets/translations/).
  static const translationsPath = 'assets/translations';

  /// Idioma por defecto si el dispositivo no tiene uno soportado.
  static const fallbackLocale = Locale('es', 'CO');

  /// Todos los idiomas que la app soporta.
  /// Cada entrada debe tener su archivo JSON en assets/translations/.
  static const supportedLocales = [
    Locale('es', 'CO'), // Español Colombia — idioma principal
    Locale('es', 'MX'), // Español México
    Locale('en', 'US'), // Inglés
    Locale('pt', 'BR'), // Portugués Brasil
  ];
}
