/// Define los dos ambientes posibles de la app.
enum AppEnvironment { qa, prod }

/// Configuración central del ambiente de ejecución.
///
/// Cada flavor (QA / PROD) crea la app con una instancia distinta de esta clase.
/// Toda la app accede al ambiente activo a través de [AppConfig.current].
class AppConfig {
  final AppEnvironment env;
  final String apiBaseUrl;
  final String firebaseProjectId;
  final String appName;

  /// Clave anónima de Supabase.
  ///
  /// Es segura en código cliente — está diseñada para estar expuesta.
  /// Los permisos reales se controlan con Row Level Security (RLS) en el backend.
  final String supabaseAnonKey;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
    required this.firebaseProjectId,
    required this.appName,
    required this.supabaseAnonKey,
  });

  // ── Ambientes predefinidos ───────────────────────────────────────────────

  static const qa = AppConfig(
    env: AppEnvironment.qa,
    apiBaseUrl: 'https://yffvbmpngcrgcknimnjc.supabase.co',
    firebaseProjectId: 'dia-market-qa',
    appName: 'Dia B2B QA',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlmZnZibXBuZ2NyZ2NrbmltbmpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0MzAzNzksImV4cCI6MjA5MTAwNjM3OX0.4FUIEua1oqTHowr3vbrrdHeQf1A-ZPRjV9CQU70hsO8',
  );

  static const prod = AppConfig(
    env: AppEnvironment.prod,
    apiBaseUrl: 'https://yffvbmpngcrgcknimnjc.supabase.co',
    firebaseProjectId: 'dia-market-prod',
    appName: 'Dia Market B2B',
    supabaseAnonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InlmZnZibXBuZ2NyZ2NrbmltbmpjIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU0MzAzNzksImV4cCI6MjA5MTAwNjM3OX0.4FUIEua1oqTHowr3vbrrdHeQf1A-ZPRjV9CQU70hsO8',
  );

  // ── Instancia activa ─────────────────────────────────────────────────────

  /// La configuración del ambiente actualmente en uso.
  /// Se asigna una sola vez al arrancar la app (en main_qa.dart o main_prod.dart).
  static late final AppConfig current;

  // ── Helpers ──────────────────────────────────────────────────────────────

  bool get isQa => env == AppEnvironment.qa;
  bool get isProd => env == AppEnvironment.prod;
}
