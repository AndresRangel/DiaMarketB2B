import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../notifiers/auth_notifier.dart';

/// Pantalla de arranque de la app.
///
/// Responsabilidades:
/// 1. Muestra la identidad visual mientras la app se inicializa.
/// 2. Lanza en paralelo la carga del tema (S43) y la verificación de sesión.
/// 3. NO navega manualmente — el guard del GoRouter detecta el cambio de
///    AuthState y redirige automáticamente a /home o /login.
///
/// ConsumerStatefulWidget nos da acceso a ref Y al ciclo de vida del widget
/// (initState, dispose), que necesitamos para disparar la inicialización.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  // true cuando loadConfig() ya terminó (con éxito o fallo).
  // Controla qué splash se muestra: neutro (cargando) vs branded (config lista).
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    await ref.read(themeProvider.notifier).loadConfig('');

    // Config lista (o fallback si falló) → cambiamos al splash branded.
    if (mounted) setState(() => _configLoaded = true);

    await Future.delayed(const Duration(seconds: 2));

    await ref.read(authProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(themeProvider);

    // Si config sigue siendo el fallback puro Y loadConfig() aún no terminó
    // (primer arranque sin cache) → splash neutro sin marca.
    // En todos los demás casos (cache preloaded, config ya llegó) → branded.
    // identical() porque RemoteAppConfig no es freezed — compara referencia.
    // RemoteAppConfig.fallback es const, ThemeNotifier.build() devuelve la misma
    // instancia cuando no hay cache → identical() es true solo en ese caso.
    final isFallback = identical(config, RemoteAppConfig.fallback);
    if (isFallback && !_configLoaded) return const _NeutralSplash();

    return _BrandedSplash(config: config);
  }
}

// ── Splash neutro ─────────────────────────────────────────────────────────────
// Se muestra ANTES de que llegue la config del backend.
// Diseño intencional: blanco, sin colores de marca, sin nombre de cliente.
class _NeutralSplash extends StatelessWidget {
  const _NeutralSplash();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ── Contenido central ──────────────────────────────────────────────
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Ícono genérico: bolsa de compras con tono neutro gris-azulado.
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: Color(0xFF90A4AE),
                  ),
                ),

                const SizedBox(height: 32),

                // Texto principal
                const Text(
                  'Configurando tu experiencia',
                  style: TextStyle(
                    color: Color(0xFF37474F),
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),

                const SizedBox(height: 8),

                // Subtexto
                const Text(
                  'Esto solo toma un momento...',
                  style: TextStyle(
                    color: Color(0xFF90A4AE),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 40),

                // Progress indicator delgado y ancho
                SizedBox(
                  width: 200,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: const LinearProgressIndicator(
                      minHeight: 3,
                      backgroundColor: Color(0xFFECEFF1),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF78909C),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Versión / branding mínimo al pie ──────────────────────────────
          const Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              'Powered by B2B Platform',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFFB0BEC5),
                fontSize: 11,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Splash branded ────────────────────────────────────────────────────────────
// Se muestra DESPUÉS de que la config del backend está lista.
// Usa colores, logo y nombre del cliente.
class _BrandedSplash extends StatelessWidget {
  const _BrandedSplash({required this.config});

  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: config.theme.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo del cliente desde CDN. Fallback: ícono genérico blanco.
            SizedBox(
              width: 160,
              height: 160,
              child: config.branding.splashLogoUrl.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: config.branding.splashLogoUrl,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 2,
                      ),
                      errorWidget: (_, _, _) => Icon(
                        Icons.store_rounded,
                        size: 72,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    )
                  : Icon(
                      Icons.store_rounded,
                      size: 72,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
            ),

            const SizedBox(height: 24),

            Text(
              config.branding.appName,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 56),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withValues(alpha: 0.7),
                ),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
