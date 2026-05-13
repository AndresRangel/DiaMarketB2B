import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../notifiers/auth_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _configLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initialize());
  }

  Future<void> _initialize() async {
    final countryCode =
        WidgetsBinding.instance.platformDispatcher.locale.countryCode ?? 'CO';
    await ref.read(themeProvider.notifier).loadConfig(countryCode);
    if (mounted) setState(() => _configLoaded = true);
    await Future.delayed(const Duration(seconds: 2));
    await ref.read(authProvider.notifier).initialize();
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(themeProvider);
    final isFallback = identical(config, RemoteAppConfig.fallback);
    if (isFallback && !_configLoaded) return const _NeutralSplash();
    return _BrandedSplash(config: config);
  }
}

// ── Splash neutro — antes de que llegue la config ────────────────────────────
// Gradiente slate oscuro neutral — sin colores de marca pero con presencia visual.

class _NeutralSplash extends StatefulWidget {
  const _NeutralSplash();

  @override
  State<_NeutralSplash> createState() => _NeutralSplashState();
}

class _NeutralSplashState extends State<_NeutralSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _scale;

  static const _dark = Color(0xFF1A2535);
  static const _mid  = Color(0xFF243447);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_dark, _mid],
          ),
        ),
        child: Stack(
          children: [
            // Círculos decorativos sutiles
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.04),
                ),
              ),
            ),

            // Contenido central animado
            FadeTransition(
              opacity: _fade,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),

                    ScaleTransition(
                      scale: _scale,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(28),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.12),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(
                          Icons.shopping_bag_outlined,
                          size: 48,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    Text(
                      'Configurando tu experiencia',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.90),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Esto solo toma un momento...',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.50),
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(height: 44),

                    _LoadingDots(
                      color: Colors.white.withValues(alpha: 0.60),
                    ),

                    const Spacer(),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: Text(
                        'Powered by B2B Platform',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.25),
                          fontSize: 11,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Splash branded — con config del backend ───────────────────────────────────

class _BrandedSplash extends StatefulWidget {
  const _BrandedSplash({required this.config});
  final RemoteAppConfig config;

  @override
  State<_BrandedSplash> createState() => _BrandedSplashState();
}

class _BrandedSplashState extends State<_BrandedSplash>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _slide = Tween<double>(begin: 0.06, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color get _primaryDark {
    final hsl = HSLColor.fromColor(widget.config.theme.primaryColor);
    return hsl
        .withLightness((hsl.lightness - 0.15).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final primary = widget.config.theme.primaryColor;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primary, _primaryDark],
          ),
        ),
        child: Stack(
          children: [
            // Círculos decorativos
            Positioned(
              top: -80,
              right: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              bottom: -100,
              left: -100,
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),

            // Contenido centrado con animación
            FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, _slide.value),
                  end: Offset.zero,
                ).animate(_controller),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      // Logo
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: widget.config.branding.splashLogoUrl.isNotEmpty
                            ? CachedNetworkImage(
                                imageUrl:
                                    widget.config.branding.splashLogoUrl,
                                fit: BoxFit.contain,
                                placeholder: (_, _) => Icon(
                                  Icons.store_rounded,
                                  size: 72,
                                  color: Colors.white.withValues(alpha: 0.7),
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
                        widget.config.branding.appName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'Portal de compras B2B',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.70),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),

                      const Spacer(),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 56),
                        child: _LoadingDots(
                          color: Colors.white.withValues(alpha: 0.70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dots de carga animados ────────────────────────────────────────────────────

class _LoadingDots extends StatefulWidget {
  const _LoadingDots({required this.color});
  final Color color;

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // Cada dot se activa en su turno con un offset de fase
            final phase = ((_controller.value * 3) - i).clamp(0.0, 1.0);
            final scale = phase < 0.5
                ? 0.6 + (phase * 0.8)
                : 1.0 - ((phase - 0.5) * 0.8);

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8 * scale,
              height: 8 * scale,
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.4 + (scale * 0.6)),
                shape: BoxShape.circle,
              ),
            );
          }),
        );
      },
    );
  }
}
