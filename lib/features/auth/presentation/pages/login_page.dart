import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/translation_keys.dart';
import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/company_entity.dart';
import '../notifiers/login_notifier.dart';
import '../notifiers/login_state.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginProvider);
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    ref.listen<LoginState>(loginProvider, (previous, next) {
      switch (next) {
        case LoginStateSuccess(:final session):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Login exitoso — ${session.user.email ?? session.user.username}',
              ),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 4),
            ),
          );
          break;

        case LoginStateNeedsCompanySelection(:final companies):
          _showCompanySelector(context, companies);

        case LoginStateError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          ref.read(loginProvider.notifier).clearError();

        case _:
          break;
      }
    });

    return Scaffold(
      backgroundColor: isDesktop ? config.theme.backgroundColor : primary,
      body: isDesktop
          ? _DesktopLayout(
              config: config,
              loginState: loginState,
              usernameController: _usernameController,
              passwordController: _passwordController,
              passwordFocusNode: _passwordFocusNode,
              onLogin: () => ref.read(loginProvider.notifier).login(
                    _usernameController.text,
                    _passwordController.text,
                  ),
            )
          : _MobileLayout(
              config: config,
              loginState: loginState,
              usernameController: _usernameController,
              passwordController: _passwordController,
              passwordFocusNode: _passwordFocusNode,
              onLogin: () => ref.read(loginProvider.notifier).login(
                    _usernameController.text,
                    _passwordController.text,
                  ),
            ),
    );
  }

  void _showCompanySelector(
      BuildContext context, List<CompanyEntity> companies) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CompanySelectorSheet(
        companies: companies,
        primaryColor: ref.read(themeProvider).theme.primaryColor,
        onSelect: (company) {
          Navigator.of(context).pop();
          ref.read(loginProvider.notifier).selectCompany(company);
        },
      ),
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────
// Gradiente primario arriba (logo + bienvenida) → panel blanco sube desde abajo.

class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.config,
    required this.loginState,
    required this.usernameController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onLogin,
  });

  final dynamic config;
  final LoginState loginState;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onLogin;

  Color get _primaryDark {
    final hsl = HSLColor.fromColor(config.theme.primaryColor);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final primary = config.theme.primaryColor as Color;
    final topPad = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // ── Gradiente de fondo ─────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, _primaryDark],
            ),
          ),
        ),

        // ── Contenido ─────────────────────────────────────────────
        Column(
          children: [
            // Zona de marca (logo + bienvenida)
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    AppSpacing.xl, topPad + AppSpacing.xl,
                    AppSpacing.xl, AppSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _LogoWidget(
                      branding: config.branding,
                      size: 80,
                      onPrimary: true,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      config.branding.appName as String,
                      style: AppTextStyles.titleLarge.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'Portal de compras B2B',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Panel blanco con el formulario
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: config.theme.surfaceColor as Color,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.xl),
                    topRight: Radius.circular(AppRadius.xl),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 24,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xl, AppSpacing.xl,
                      AppSpacing.xl, AppSpacing.xl),
                  child: _FormContent(
                    config: config,
                    loginState: loginState,
                    usernameController: usernameController,
                    passwordController: passwordController,
                    passwordFocusNode: passwordFocusNode,
                    onLogin: onLogin,
                    showTitle: true,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Desktop layout ────────────────────────────────────────────────────────────
// Dos columnas: panel de marca izquierda | formulario derecha.

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.config,
    required this.loginState,
    required this.usernameController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onLogin,
  });

  final dynamic config;
  final LoginState loginState;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onLogin;

  Color get _primaryDark {
    final hsl = HSLColor.fromColor(config.theme.primaryColor);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final primary = config.theme.primaryColor as Color;

    return Row(
      children: [
        // ── Panel izquierdo — marca ────────────────────────────────
        Expanded(
          flex: 5,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, _primaryDark],
              ),
            ),
            child: Stack(
              children: [
                // Círculos decorativos de fondo
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -80,
                  left: -80,
                  child: Container(
                    width: 320,
                    height: 320,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),

                // Contenido centrado
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _LogoWidget(
                          branding: config.branding,
                          size: 96,
                          onPrimary: true,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          config.branding.appName as String,
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Portal de compras B2B',
                          style: AppTextStyles.titleSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.80),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        // Bullets de propuesta de valor
                        ..._bullets.map((b) => Padding(
                              padding: const EdgeInsets.only(
                                  bottom: AppSpacing.sm),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(b.$1,
                                      size: 16,
                                      color: Colors.white
                                          .withValues(alpha: 0.70)),
                                  const SizedBox(width: AppSpacing.sm),
                                  Text(
                                    b.$2,
                                    style: AppTextStyles.bodyMedium
                                        .copyWith(
                                      color: Colors.white
                                          .withValues(alpha: 0.80),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Panel derecho — formulario ─────────────────────────────
        Expanded(
          flex: 4,
          child: Container(
            color: config.theme.backgroundColor as Color,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      color: config.theme.surfaceColor as Color,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: _FormContent(
                      config: config,
                      loginState: loginState,
                      usernameController: usernameController,
                      passwordController: passwordController,
                      passwordFocusNode: passwordFocusNode,
                      onLogin: onLogin,
                      showTitle: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  static const _bullets = [
    (Icons.inventory_2_outlined, 'Catálogo completo en línea'),
    (Icons.local_offer_outlined, 'Precios y promociones exclusivas'),
    (Icons.receipt_long_outlined, 'Historial de pedidos'),
  ];
}

// ── Formulario compartido (mobile y desktop) ──────────────────────────────────

class _FormContent extends StatelessWidget {
  const _FormContent({
    required this.config,
    required this.loginState,
    required this.usernameController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.onLogin,
    this.showTitle = false,
  });

  final dynamic config;
  final LoginState loginState;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final VoidCallback onLogin;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final isLoading = loginState is LoginStateLoading;
    final primary = config.theme.primaryColor as Color;
    final textPrimary = config.theme.textPrimaryColor as Color;
    final textSecondary = config.theme.textSecondaryColor as Color;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showTitle) ...[
          Text(
            'Iniciar sesión',
            style: AppTextStyles.titleLarge.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ingresa tus credenciales para continuar',
            style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],

        AppTextField(
          controller: usernameController,
          label: TrKeys.username.tr(),
          prefixIcon: const Icon(Icons.person_outline),
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: passwordController,
          label: TrKeys.password.tr(),
          prefixIcon: const Icon(Icons.lock_outline),
          isPassword: true,
          enabled: !isLoading,
          focusNode: passwordFocusNode,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) {
            if (!isLoading) onLogin();
          },
        ),

        // Olvidé contraseña — alineado a la derecha
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(AppRoutes.otp),
            style: TextButton.styleFrom(
              foregroundColor: primary,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
            ),
            child: Text(
              TrKeys.forgotPassword.tr(),
              style: AppTextStyles.labelMedium.copyWith(
                color: primary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        const SizedBox(height: AppSpacing.sm),
        AppButton(
          label: TrKeys.login.tr(),
          isLoading: isLoading,
          onPressed: isLoading ? null : onLogin,
          isFullWidth: true,
        ),

        const SizedBox(height: AppSpacing.xl),

        // Divisor + registro
        Row(
          children: [
            Expanded(
              child: Divider(
                color: textSecondary.withValues(alpha: 0.20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md),
              child: Text(
                '¿No tienes cuenta?',
                style: AppTextStyles.labelSmall.copyWith(
                    color: textSecondary),
              ),
            ),
            Expanded(
              child: Divider(
                color: textSecondary.withValues(alpha: 0.20),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: () => context.push(AppRoutes.register),
          style: OutlinedButton.styleFrom(
            foregroundColor: primary,
            side: BorderSide(color: primary.withValues(alpha: 0.50)),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: Text(
            TrKeys.register.tr(),
            style: AppTextStyles.labelMedium.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Logo widget ───────────────────────────────────────────────────────────────

class _LogoWidget extends ConsumerWidget {
  const _LogoWidget({
    required this.branding,
    required this.size,
    required this.onPrimary,
  });

  final dynamic branding;
  final double size;
  final bool onPrimary;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logoUrl = (branding.logoLightUrl as String).isNotEmpty
        ? branding.logoLightUrl as String
        : branding.logoUrl as String;

    if (logoUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: logoUrl,
        height: size,
        fit: BoxFit.contain,
        placeholder: (_, _) => SizedBox(height: size),
        errorWidget: (_, _, _) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: onPrimary
            ? Colors.white.withValues(alpha: 0.20)
            : Theme.of(context).colorScheme.primary.withValues(alpha: 0.10),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.store_rounded,
        size: size * 0.5,
        color: onPrimary
            ? Colors.white
            : Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

// ── Company selector sheet ────────────────────────────────────────────────────

class _CompanySelectorSheet extends StatelessWidget {
  const _CompanySelectorSheet({
    required this.companies,
    required this.primaryColor,
    required this.onSelect,
  });

  final List<CompanyEntity> companies;
  final Color primaryColor;
  final void Function(CompanyEntity) onSelect;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(AppRadius.xl),
          topRight: Radius.circular(AppRadius.xl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.md,
          AppSpacing.base, AppSpacing.base + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          Text(
            'Selecciona tu empresa',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Tu cuenta tiene acceso a múltiples empresas',
            style: AppTextStyles.bodyMedium.copyWith(
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.55),
            ),
          ),
          const SizedBox(height: AppSpacing.base),

          ...companies.map((company) => _CompanyTile(
                company: company,
                primaryColor: primaryColor,
                onTap: () => onSelect(company),
              )),
        ],
      ),
    );
  }
}

class _CompanyTile extends StatefulWidget {
  const _CompanyTile({
    required this.company,
    required this.primaryColor,
    required this.onTap,
  });

  final CompanyEntity company;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  State<_CompanyTile> createState() => _CompanyTileState();
}

class _CompanyTileState extends State<_CompanyTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final initial = widget.company.name.isNotEmpty
        ? widget.company.name[0].toUpperCase()
        : 'E';

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.primaryColor.withValues(alpha: 0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hovered
                  ? widget.primaryColor.withValues(alpha: 0.25)
                  : Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            children: [
              // Avatar con inicial
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.primaryColor.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: AppTextStyles.titleSmall.copyWith(
                      color: widget.primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.company.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (widget.company.code.isNotEmpty)
                      Text(
                        widget.company.code,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withValues(alpha: 0.50),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
