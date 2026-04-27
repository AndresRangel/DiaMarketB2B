import 'package:flutter/material.dart';

/// Datos de marca: logo, nombre de la app, URLs de imágenes.
/// El backend los entrega en el servicio S43.
class BrandingData {
  final String appName;
  final String logoUrl;
  final String logoLightUrl;
  final String faviconUrl;
  final String splashLogoUrl;

  const BrandingData({
    required this.appName,
    required this.logoUrl,
    required this.logoLightUrl,
    required this.faviconUrl,
    required this.splashLogoUrl,
  });

  /// Valores por defecto mientras carga la config del backend.
  static const fallback = BrandingData(
    appName: 'B2B App',
    logoUrl: '',
    logoLightUrl: '',
    faviconUrl: '',
    splashLogoUrl: '',
  );

  factory BrandingData.fromJson(Map<String, dynamic> json) => BrandingData(
        appName: json['appName'] as String? ?? fallback.appName,
        logoUrl: json['logoUrl'] as String? ?? '',
        logoLightUrl: json['logoLightUrl'] as String? ?? '',
        faviconUrl: json['faviconUrl'] as String? ?? '',
        splashLogoUrl: json['splashLogoUrl'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {
        'appName': appName,
        'logoUrl': logoUrl,
        'logoLightUrl': logoLightUrl,
        'faviconUrl': faviconUrl,
        'splashLogoUrl': splashLogoUrl,
      };
}

/// Paleta de colores de la app.
/// Todos los widgets deben leer sus colores desde aquí, nunca hardcodearlos.
class AppThemeData {
  final Color primaryColor;
  final Color primaryDarkColor;
  final Color primaryLightColor;
  final Color accentColor;
  final Color secondaryColor;
  final Color errorColor;
  final Color warningColor;
  final Color successColor;
  final Color backgroundColor;
  final Color surfaceColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;
  final Color buttonTextColor;
  final String fontFamily;

  const AppThemeData({
    required this.primaryColor,
    required this.primaryDarkColor,
    required this.primaryLightColor,
    required this.accentColor,
    required this.secondaryColor,
    required this.errorColor,
    required this.warningColor,
    required this.successColor,
    required this.backgroundColor,
    required this.surfaceColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
    required this.buttonTextColor,
    required this.fontFamily,
  });

  /// Colores neutros como fallback cuando el backend no responde.
  static const fallback = AppThemeData(
    primaryColor: Color(0xFF1E3A5F),
    primaryDarkColor: Color(0xFF0F2440),
    primaryLightColor: Color(0xFF2E5A8F),
    accentColor: Color(0xFFFF6B35),
    secondaryColor: Color(0xFF4CAF50),
    errorColor: Color(0xFFE53935),
    warningColor: Color(0xFFFFA726),
    successColor: Color(0xFF66BB6A),
    backgroundColor: Color(0xFFF5F7FA),
    surfaceColor: Color(0xFFFFFFFF),
    textPrimaryColor: Color(0xFF1A1A2E),
    textSecondaryColor: Color(0xFF666666),
    buttonTextColor: Color(0xFFFFFFFF),
    fontFamily: 'Roboto',
  );

  Map<String, dynamic> toJson() => {
        'primaryColor': _colorToHex(primaryColor),
        'primaryDarkColor': _colorToHex(primaryDarkColor),
        'primaryLightColor': _colorToHex(primaryLightColor),
        'accentColor': _colorToHex(accentColor),
        'secondaryColor': _colorToHex(secondaryColor),
        'errorColor': _colorToHex(errorColor),
        'warningColor': _colorToHex(warningColor),
        'successColor': _colorToHex(successColor),
        'backgroundColor': _colorToHex(backgroundColor),
        'surfaceColor': _colorToHex(surfaceColor),
        'textPrimaryColor': _colorToHex(textPrimaryColor),
        'textSecondaryColor': _colorToHex(textSecondaryColor),
        'buttonTextColor': _colorToHex(buttonTextColor),
        'fontFamily': fontFamily,
      };

  static String _colorToHex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  factory AppThemeData.fromJson(Map<String, dynamic> json) => AppThemeData(
        primaryColor: _hexToColor(json['primaryColor'], fallback.primaryColor),
        primaryDarkColor:
            _hexToColor(json['primaryDarkColor'], fallback.primaryDarkColor),
        primaryLightColor:
            _hexToColor(json['primaryLightColor'], fallback.primaryLightColor),
        accentColor: _hexToColor(json['accentColor'], fallback.accentColor),
        secondaryColor:
            _hexToColor(json['secondaryColor'], fallback.secondaryColor),
        errorColor: _hexToColor(json['errorColor'], fallback.errorColor),
        warningColor: _hexToColor(json['warningColor'], fallback.warningColor),
        successColor: _hexToColor(json['successColor'], fallback.successColor),
        backgroundColor:
            _hexToColor(json['backgroundColor'], fallback.backgroundColor),
        surfaceColor: _hexToColor(json['surfaceColor'], fallback.surfaceColor),
        textPrimaryColor:
            _hexToColor(json['textPrimaryColor'], fallback.textPrimaryColor),
        textSecondaryColor: _hexToColor(
            json['textSecondaryColor'], fallback.textSecondaryColor),
        buttonTextColor:
            _hexToColor(json['buttonTextColor'], fallback.buttonTextColor),
        fontFamily:
            json['fontFamily'] as String? ?? fallback.fontFamily,
      );

  /// Convierte un string hex "#RRGGBB" a un objeto Color de Flutter.
  static Color _hexToColor(dynamic hex, Color fallback) {
    if (hex is! String) return fallback;
    try {
      final cleaned = hex.replaceAll('#', '');
      return Color(int.parse('FF$cleaned', radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}

/// Configuración de idioma y moneda.
class LocaleConfig {
  final String defaultLocale;
  final List<String> supportedLocales;
  final String defaultCurrency;
  final String currencySymbol;
  final int currencyDecimals;
  final String thousandSeparator;
  final String decimalSeparator;

  const LocaleConfig({
    required this.defaultLocale,
    required this.supportedLocales,
    required this.defaultCurrency,
    required this.currencySymbol,
    required this.currencyDecimals,
    required this.thousandSeparator,
    required this.decimalSeparator,
  });

  static const fallback = LocaleConfig(
    defaultLocale: 'es_CO',
    supportedLocales: ['es_CO'],
    defaultCurrency: 'COP',
    currencySymbol: '\$',
    currencyDecimals: 0,
    thousandSeparator: '.',
    decimalSeparator: ',',
  );

  Map<String, dynamic> toJson() => {
        'defaultLocale': defaultLocale,
        'supportedLocales': supportedLocales,
        'defaultCurrency': defaultCurrency,
        'currencySymbol': currencySymbol,
        'currencyDecimals': currencyDecimals,
        'thousandSeparator': thousandSeparator,
        'decimalSeparator': decimalSeparator,
      };

  factory LocaleConfig.fromJson(Map<String, dynamic> json) => LocaleConfig(
        defaultLocale:
            json['defaultLocale'] as String? ?? fallback.defaultLocale,
        supportedLocales: (json['supportedLocales'] as List<dynamic>?)
                ?.cast<String>() ??
            fallback.supportedLocales,
        defaultCurrency:
            json['defaultCurrency'] as String? ?? fallback.defaultCurrency,
        currencySymbol:
            json['currencySymbol'] as String? ?? fallback.currencySymbol,
        currencyDecimals:
            json['currencyDecimals'] as int? ?? fallback.currencyDecimals,
        thousandSeparator:
            json['thousandSeparator'] as String? ?? fallback.thousandSeparator,
        decimalSeparator:
            json['decimalSeparator'] as String? ?? fallback.decimalSeparator,
      );
}

/// Feature flags — controlan qué módulos están activos para este cliente.
/// Antes de renderizar un módulo opcional, siempre verificar su flag.
class FeatureFlags {
  final bool enableZiroPayment;
  final bool enableLoyaltyPoints;
  final bool enableCoupons;
  final bool enableNews;
  final bool enableSmsOtp;
  final bool enablePreRegistration;

  const FeatureFlags({
    required this.enableZiroPayment,
    required this.enableLoyaltyPoints,
    required this.enableCoupons,
    required this.enableNews,
    required this.enableSmsOtp,
    required this.enablePreRegistration,
  });

  /// Por defecto todos los módulos activos.
  static const fallback = FeatureFlags(
    enableZiroPayment: true,
    enableLoyaltyPoints: true,
    enableCoupons: true,
    enableNews: true,
    enableSmsOtp: true,
    enablePreRegistration: true,
  );

  factory FeatureFlags.fromJson(Map<String, dynamic> json) => FeatureFlags(
        enableZiroPayment:
            json['enableZiroPayment'] as bool? ?? fallback.enableZiroPayment,
        enableLoyaltyPoints: json['enableLoyaltyPoints'] as bool? ??
            fallback.enableLoyaltyPoints,
        enableCoupons:
            json['enableCoupons'] as bool? ?? fallback.enableCoupons,
        enableNews: json['enableNews'] as bool? ?? fallback.enableNews,
        enableSmsOtp: json['enableSmsOtp'] as bool? ?? fallback.enableSmsOtp,
        enablePreRegistration: json['enablePreRegistration'] as bool? ??
            fallback.enablePreRegistration,
      );
}

/// Modelo completo que agrupa toda la configuración remota del cliente.
/// Este es el estado que guarda el [ThemeNotifier].
class RemoteAppConfig {
  final BrandingData branding;
  final AppThemeData theme;
  final LocaleConfig locale;
  final FeatureFlags features;

  const RemoteAppConfig({
    required this.branding,
    required this.theme,
    required this.locale,
    required this.features,
  });

  /// Configuración fallback completa. Se usa si el backend no responde
  /// y no hay nada guardado en cache.
  static const fallback = RemoteAppConfig(
    branding: BrandingData.fallback,
    theme: AppThemeData.fallback,
    locale: LocaleConfig.fallback,
    features: FeatureFlags.fallback,
  );

  Map<String, dynamic> toJson() => {
        'branding': branding.toJson(),
        'theme': theme.toJson(),
        'locale': locale.toJson(),
        'features': {
          'enableZiroPayment': features.enableZiroPayment,
          'enableLoyaltyPoints': features.enableLoyaltyPoints,
          'enableCoupons': features.enableCoupons,
          'enableNews': features.enableNews,
          'enableSmsOtp': features.enableSmsOtp,
          'enablePreRegistration': features.enablePreRegistration,
        },
      };

  factory RemoteAppConfig.fromJson(Map<String, dynamic> json) =>
      RemoteAppConfig(
        branding: BrandingData.fromJson(
            json['branding'] as Map<String, dynamic>? ?? {}),
        theme: AppThemeData.fromJson(
            json['theme'] as Map<String, dynamic>? ?? {}),
        locale: LocaleConfig.fromJson(
            json['locale'] as Map<String, dynamic>? ?? {}),
        features: FeatureFlags.fromJson(
            json['features'] as Map<String, dynamic>? ?? {}),
      );

  /// Convierte el tema a un [ThemeData] de Flutter para pasarlo al MaterialApp.
  ThemeData toMaterialTheme() => ThemeData(
        primaryColor: theme.primaryColor,
        colorScheme: ColorScheme.light(
          primary: theme.primaryColor,
          secondary: theme.accentColor,
          error: theme.errorColor,
          surface: theme.surfaceColor,
        ),
        scaffoldBackgroundColor: theme.backgroundColor,
        fontFamily: theme.fontFamily,
      );
}
