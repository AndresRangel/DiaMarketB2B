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
import '../notifiers/register_notifier.dart';
import '../notifiers/register_state.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _referralController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  String? _selectedBusinessType;
  static const _businessTypes = [
    'TIENDA',
    'MINIMARKET',
    'RESTAURANTE',
    'CAFETERIA',
    'OTRO',
  ];

  final String _cityId = 'default';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _referralController.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerState = ref.watch(registerProvider);
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    ref.listen<RegisterState>(registerProvider, (previous, next) {
      switch (next) {
        case RegisterStateSuccess():
          context.go(AppRoutes.pendingApproval);

        case RegisterStateError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          ref.read(registerProvider.notifier).clearError();

        case _:
          break;
      }
    });

    final isLoading = registerState is RegisterStateLoading;

    return Scaffold(
      backgroundColor: isDesktop ? config.theme.backgroundColor : primary,
      body: isDesktop
          ? _buildDesktop(context, primary, config, isLoading)
          : _buildMobile(context, primary, config, isLoading),
    );
  }

  Color _primaryDark(Color primary) {
    final hsl = HSLColor.fromColor(primary);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  // ── Mobile ────────────────────────────────────────────────────────────────

  Widget _buildMobile(BuildContext context, Color primary,
      dynamic config, bool isLoading) {
    final topPad = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primary, _primaryDark(primary)],
            ),
          ),
        ),
        Column(
          children: [
            // Header compacto con botón atrás
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.xs, topPad + AppSpacing.sm,
                  AppSpacing.base, AppSpacing.md),
              child: Row(
                children: [
                  _BackButton(onTap: () => context.pop()),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Crear cuenta',
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Solicitud pendiente de aprobación',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card blanca con el form
            Expanded(
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
                      AppSpacing.xl, AppSpacing.xxl),
                  child: _FormBody(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    confirmPasswordController: _confirmPasswordController,
                    phoneController: _phoneController,
                    emailController: _emailController,
                    referralController: _referralController,
                    passwordFocus: _passwordFocus,
                    confirmPasswordFocus: _confirmPasswordFocus,
                    phoneFocus: _phoneFocus,
                    emailFocus: _emailFocus,
                    selectedBusinessType: _selectedBusinessType,
                    businessTypes: _businessTypes,
                    isLoading: isLoading,
                    primaryColor: primary,
                    surfaceColor: config.theme.surfaceColor as Color,
                    textSecondary: config.theme.textSecondaryColor as Color,
                    onBusinessTypeChanged: (v) =>
                        setState(() => _selectedBusinessType = v),
                    onSubmit: _onSubmit,
                    onLoginTap: () => context.pop(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Desktop ───────────────────────────────────────────────────────────────

  Widget _buildDesktop(BuildContext context, Color primary,
      dynamic config, bool isLoading) {
    return Row(
      children: [
        // Panel izquierdo — marca
        Expanded(
          flex: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, _primaryDark(primary)],
              ),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: -60,
                  right: -60,
                  child: Container(
                    width: 200,
                    height: 200,
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
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.store_rounded,
                              size: 36, color: Colors.white),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          'Únete a nuestra\nred de distribución',
                          style: AppTextStyles.titleLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Completa el formulario y nuestro\nequipo aprobará tu cuenta.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.80),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        ...[
                          (Icons.inventory_2_outlined, 'Catálogo completo'),
                          (Icons.local_offer_outlined, 'Precios mayoristas'),
                          (Icons.receipt_long_outlined, 'Gestión de pedidos'),
                        ].map((b) => Padding(
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

        // Panel derecho — formulario
        Expanded(
          flex: 5,
          child: Container(
            color: config.theme.backgroundColor as Color,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _BackButton(onTap: () => context.pop(), onLight: true, primaryColor: primary),
                        const SizedBox(height: AppSpacing.base),
                        _FormBody(
                          usernameController: _usernameController,
                          passwordController: _passwordController,
                          confirmPasswordController:
                              _confirmPasswordController,
                          phoneController: _phoneController,
                          emailController: _emailController,
                          referralController: _referralController,
                          passwordFocus: _passwordFocus,
                          confirmPasswordFocus: _confirmPasswordFocus,
                          phoneFocus: _phoneFocus,
                          emailFocus: _emailFocus,
                          selectedBusinessType: _selectedBusinessType,
                          businessTypes: _businessTypes,
                          isLoading: isLoading,
                          primaryColor: primary,
                          surfaceColor: config.theme.surfaceColor as Color,
                          textSecondary:
                              config.theme.textSecondaryColor as Color,
                          onBusinessTypeChanged: (v) =>
                              setState(() => _selectedBusinessType = v),
                          onSubmit: _onSubmit,
                          onLoginTap: () => context.pop(),
                        ),
                      ],
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

  void _onSubmit() {
    ref.read(registerProvider.notifier).register(
          username: _usernameController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          phone: _phoneController.text,
          email: _emailController.text,
          businessType: _selectedBusinessType ?? '',
          cityId: _cityId,
          referralCode: _referralController.text.isEmpty
              ? null
              : _referralController.text,
        );
  }
}

// ── Formulario compartido mobile/desktop ──────────────────────────────────────

class _FormBody extends StatelessWidget {
  const _FormBody({
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.phoneController,
    required this.emailController,
    required this.referralController,
    required this.passwordFocus,
    required this.confirmPasswordFocus,
    required this.phoneFocus,
    required this.emailFocus,
    required this.selectedBusinessType,
    required this.businessTypes,
    required this.isLoading,
    required this.primaryColor,
    required this.surfaceColor,
    required this.textSecondary,
    required this.onBusinessTypeChanged,
    required this.onSubmit,
    required this.onLoginTap,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final TextEditingController referralController;
  final FocusNode passwordFocus;
  final FocusNode confirmPasswordFocus;
  final FocusNode phoneFocus;
  final FocusNode emailFocus;
  final String? selectedBusinessType;
  final List<String> businessTypes;
  final bool isLoading;
  final Color primaryColor;
  final Color surfaceColor;
  final Color textSecondary;
  final ValueChanged<String?> onBusinessTypeChanged;
  final VoidCallback onSubmit;
  final VoidCallback onLoginTap;

  final _borderRadius = const BorderRadius.all(Radius.circular(12));

  InputDecoration _fieldDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20,
          color: textSecondary.withValues(alpha: 0.55)),
      filled: true,
      fillColor: surfaceColor,
      contentPadding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(
            color: textSecondary.withValues(alpha: 0.15)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(
            color: textSecondary.withValues(alpha: 0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: _borderRadius,
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
      labelStyle: TextStyle(
          color: textSecondary.withValues(alpha: 0.55), fontSize: 14),
      floatingLabelStyle: TextStyle(
          color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Crea tu cuenta',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Tu solicitud quedará pendiente de aprobación.',
          style: AppTextStyles.bodyMedium.copyWith(
              color: textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),

        AppTextField(
          controller: usernameController,
          label: TrKeys.username.tr(),
          prefixIcon: const Icon(Icons.person_outline),
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => passwordFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: passwordController,
          label: TrKeys.password.tr(),
          prefixIcon: const Icon(Icons.lock_outline),
          isPassword: true,
          enabled: !isLoading,
          focusNode: passwordFocus,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => confirmPasswordFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: confirmPasswordController,
          label: 'Confirmar contraseña',
          prefixIcon: const Icon(Icons.lock_outline),
          isPassword: true,
          enabled: !isLoading,
          focusNode: confirmPasswordFocus,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => phoneFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: phoneController,
          label: 'Teléfono celular',
          prefixIcon: const Icon(Icons.phone_outlined),
          keyboardType: TextInputType.phone,
          enabled: !isLoading,
          focusNode: phoneFocus,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => emailFocus.requestFocus(),
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: emailController,
          label: 'Correo electrónico',
          prefixIcon: const Icon(Icons.email_outlined),
          keyboardType: TextInputType.emailAddress,
          enabled: !isLoading,
          focusNode: emailFocus,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.md),

        // Dropdown tipo negocio — misma decoración que AppTextField
        DropdownButtonFormField<String>(
          initialValue: selectedBusinessType,
          decoration: _fieldDecoration('Tipo de negocio', Icons.store_outlined),
          dropdownColor: surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          items: businessTypes
              .map((type) => DropdownMenuItem(
                    value: type,
                    child: Text(type,
                        style: AppTextStyles.bodyMedium),
                  ))
              .toList(),
          onChanged: isLoading ? null : onBusinessTypeChanged,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: referralController,
          label: 'Código de referido (opcional)',
          prefixIcon: const Icon(Icons.card_giftcard_outlined),
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: AppSpacing.xl),

        AppButton(
          label: TrKeys.register.tr(),
          isLoading: isLoading,
          onPressed: isLoading ? null : onSubmit,
          isFullWidth: true,
        ),
        const SizedBox(height: AppSpacing.xl),

        Row(
          children: [
            Expanded(
              child: Divider(
                  color: textSecondary.withValues(alpha: 0.20)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md),
              child: Text(
                '¿Ya tienes cuenta?',
                style: AppTextStyles.labelSmall.copyWith(
                    color: textSecondary),
              ),
            ),
            Expanded(
              child: Divider(
                  color: textSecondary.withValues(alpha: 0.20)),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton(
          onPressed: onLoginTap,
          style: OutlinedButton.styleFrom(
            foregroundColor: primaryColor,
            side: BorderSide(
                color: primaryColor.withValues(alpha: 0.50)),
            padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
          ),
          child: Text(
            'Iniciar sesión',
            style: AppTextStyles.labelMedium.copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Botón atrás circular ──────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  const _BackButton({
    required this.onTap,
    this.onLight = false,
    this.primaryColor,
  });

  final VoidCallback onTap;
  final bool onLight;
  final Color? primaryColor;

  @override
  Widget build(BuildContext context) {
    final bg = onLight
        ? (primaryColor ?? Colors.black).withValues(alpha: 0.08)
        : Colors.white.withValues(alpha: 0.15);
    final iconColor =
        onLight ? (primaryColor ?? Colors.black) : Colors.white;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            size: 16, color: iconColor),
      ),
    );
  }
}
