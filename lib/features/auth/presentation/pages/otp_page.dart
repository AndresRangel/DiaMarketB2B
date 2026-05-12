import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../notifiers/otp_notifier.dart';
import '../notifiers/otp_state.dart';

class OtpPage extends ConsumerStatefulWidget {
  final OtpFlow flow;
  final String? prefilledPhone;

  const OtpPage({
    super.key,
    this.flow = OtpFlow.recoverPassword,
    this.prefilledPhone,
  });

  @override
  ConsumerState<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage> {
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    if (widget.prefilledPhone != null) {
      _phoneController.text = widget.prefilledPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    final otpState = ref.watch(otpProvider);
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    ref.listen<OtpState>(otpProvider, (previous, next) {
      switch (next) {
        case OtpStateSuccess():
          _handleSuccess(context);

        case OtpStateError(:final message, :final previousPhone):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          if (previousPhone != null) {
            _phoneController.text = previousPhone;
          }

        case _:
          break;
      }
    });

    final isPhase1 =
        otpState is OtpStateInitial || otpState is OtpStateSendingOtp;

    return Scaffold(
      backgroundColor: isDesktop ? config.theme.backgroundColor : primary,
      body: isDesktop
          ? _buildDesktop(context, otpState, config, primary, isPhase1)
          : _buildMobile(context, otpState, config, primary, isPhase1),
    );
  }

  Color _primaryDark(Color primary) {
    final hsl = HSLColor.fromColor(primary);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  // ── Mobile ────────────────────────────────────────────────────────────────

  Widget _buildMobile(BuildContext context, OtpState otpState,
      dynamic config, Color primary, bool isPhase1) {
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
            // Header con icono + título
            Padding(
              padding: EdgeInsets.fromLTRB(
                  AppSpacing.xs, topPad + AppSpacing.sm,
                  AppSpacing.base, AppSpacing.lg),
              child: Row(
                children: [
                  _CircleButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isPhase1
                            ? 'Verificar número'
                            : TrKeys.otpTitle.tr(),
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        isPhase1
                            ? 'Te enviaremos un código SMS'
                            : 'Revisa tu teléfono',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Card blanca
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
                  child: _buildBody(context, otpState, primary,
                      config.theme.textSecondaryColor as Color,
                      config.theme.surfaceColor as Color),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── Desktop ───────────────────────────────────────────────────────────────

  Widget _buildDesktop(BuildContext context, OtpState otpState,
      dynamic config, Color primary, bool isPhase1) {
    return Row(
      children: [
        // Panel izquierdo — marca
        Expanded(
          flex: 5,
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxl),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isPhase1
                                ? Icons.phone_outlined
                                : Icons.lock_open_outlined,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          isPhase1
                              ? 'Verifica tu\nnúmero'
                              : 'Ingresa el\ncódigo',
                          style: AppTextStyles.displayLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          isPhase1
                              ? 'Recibirás un SMS con\nun código de 6 dígitos'
                              : 'El código fue enviado\na tu número de celular',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white.withValues(alpha: 0.80),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        ...[
                          (Icons.security_outlined, 'Verificación segura'),
                          (Icons.sms_outlined, 'Código por SMS'),
                          (Icons.timer_outlined, 'Válido por 5 minutos'),
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
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            _CircleButton(
                              icon: Icons.arrow_back_ios_new_rounded,
                              onTap: () => context.pop(),
                              color: primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.base),
                        _buildBody(
                          context,
                          otpState,
                          primary,
                          config.theme.textSecondaryColor as Color,
                          config.theme.surfaceColor as Color,
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

  // ── Contenido según fase ──────────────────────────────────────────────────

  Widget _buildBody(BuildContext context, OtpState otpState,
      Color primary, Color textSecondary, Color surfaceColor) {
    if (otpState is OtpStateInitial || otpState is OtpStateSendingOtp) {
      return _PhaseOne(
        phoneController: _phoneController,
        isLoading: otpState is OtpStateSendingOtp,
        primaryColor: primary,
        textSecondary: textSecondary,
        onSend: () =>
            ref.read(otpProvider.notifier).sendOtp(_phoneController.text),
      );
    }

    if (otpState is OtpStateOtpSent || otpState is OtpStateValidating) {
      final phone = otpState is OtpStateOtpSent
          ? otpState.phone
          : _phoneController.text;
      final cooldown =
          otpState is OtpStateOtpSent ? otpState.resendCooldown : 0;

      return _PhaseTwo(
        phone: phone,
        resendCooldown: cooldown,
        isLoading: otpState is OtpStateValidating,
        otpControllers: _otpControllers,
        otpFocusNodes: _otpFocusNodes,
        primaryColor: primary,
        textSecondary: textSecondary,
        surfaceColor: surfaceColor,
        onVerify: () => ref.read(otpProvider.notifier).validateOtp(
              phone: phone,
              code: _otpCode,
              flow: widget.flow,
            ),
        onResend: () =>
            ref.read(otpProvider.notifier).sendOtp(_phoneController.text),
        onChangePhone: () => ref.read(otpProvider.notifier).resetToInitial(),
      );
    }

    return _PhaseOne(
      phoneController: _phoneController,
      isLoading: false,
      primaryColor: primary,
      textSecondary: textSecondary,
      onSend: () =>
          ref.read(otpProvider.notifier).sendOtp(_phoneController.text),
    );
  }

  void _handleSuccess(BuildContext context) {
    switch (widget.flow) {
      case OtpFlow.recoverPassword:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contraseña restablecida. Revisa tu correo o SMS.'),
          ),
        );
        context.go(AppRoutes.login);

      case OtpFlow.registration:
        context.go(AppRoutes.login);
    }
  }
}

// ── Fase 1 — ingresar teléfono ────────────────────────────────────────────────

class _PhaseOne extends StatelessWidget {
  const _PhaseOne({
    required this.phoneController,
    required this.isLoading,
    required this.primaryColor,
    required this.textSecondary,
    required this.onSend,
  });

  final TextEditingController phoneController;
  final bool isLoading;
  final Color primaryColor;
  final Color textSecondary;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ícono en círculo primario
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.phone_outlined,
                size: 32, color: primaryColor),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text(
          'Ingresa tu número',
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Te enviaremos un código de verificación por SMS.',
          style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xl),

        AppTextField(
          controller: phoneController,
          label: 'Número de celular',
          prefixIcon: const Icon(Icons.phone_outlined),
          keyboardType: TextInputType.phone,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSend(),
        ),
        const SizedBox(height: AppSpacing.lg),

        AppButton(
          label: 'Enviar código',
          isLoading: isLoading,
          onPressed: isLoading ? null : onSend,
          isFullWidth: true,
        ),
      ],
    );
  }
}

// ── Fase 2 — ingresar código OTP ──────────────────────────────────────────────

class _PhaseTwo extends StatelessWidget {
  const _PhaseTwo({
    required this.phone,
    required this.resendCooldown,
    required this.isLoading,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.primaryColor,
    required this.textSecondary,
    required this.surfaceColor,
    required this.onVerify,
    required this.onResend,
    required this.onChangePhone,
  });

  final String phone;
  final int resendCooldown;
  final bool isLoading;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final Color primaryColor;
  final Color textSecondary;
  final Color surfaceColor;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangePhone;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Ícono
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_open_outlined,
                size: 32, color: primaryColor),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),

        Text(
          TrKeys.otpTitle.tr(),
          style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          'Enviamos un código a',
          style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              phone,
              style: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            GestureDetector(
              onTap: onChangePhone,
              child: Text(
                'Cambiar',
                style: AppTextStyles.labelMedium.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xl),

        // Cajas OTP temáticas
        _OtpBoxRow(
          controllers: otpControllers,
          focusNodes: otpFocusNodes,
          enabled: !isLoading,
          primaryColor: primaryColor,
          textSecondary: textSecondary,
          surfaceColor: surfaceColor,
          onCompleted: onVerify,
        ),

        const SizedBox(height: AppSpacing.xl),

        AppButton(
          label: 'Verificar código',
          isLoading: isLoading,
          onPressed: isLoading ? null : onVerify,
          isFullWidth: true,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Reenviar con countdown pill
        Center(
          child: resendCooldown > 0
              ? Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.xs + 2),
                  decoration: BoxDecoration(
                    color: textSecondary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.timer_outlined,
                          size: 14,
                          color: textSecondary.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        'Reenviar en ${resendCooldown}s',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: textSecondary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                )
              : TextButton(
                  onPressed: onResend,
                  style: TextButton.styleFrom(
                      foregroundColor: primaryColor),
                  child: Text(
                    TrKeys.otpResend.tr(),
                    style: AppTextStyles.labelMedium.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

// ── Cajas OTP 56×56px con borde temático ─────────────────────────────────────

class _OtpBoxRow extends StatelessWidget {
  const _OtpBoxRow({
    required this.controllers,
    required this.focusNodes,
    required this.enabled,
    required this.primaryColor,
    required this.textSecondary,
    required this.surfaceColor,
    required this.onCompleted,
  });

  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool enabled;
  final Color primaryColor;
  final Color textSecondary;
  final Color surfaceColor;
  final VoidCallback onCompleted;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return _OtpBox(
          controller: controllers[index],
          focusNode: focusNodes[index],
          enabled: enabled,
          primaryColor: primaryColor,
          textSecondary: textSecondary,
          surfaceColor: surfaceColor,
          onChanged: (value) {
            if (value.isNotEmpty && index < 5) {
              focusNodes[index + 1].requestFocus();
            } else if (value.isEmpty && index > 0) {
              focusNodes[index - 1].requestFocus();
            }
            final code = controllers.map((c) => c.text).join();
            if (code.length == 6) onCompleted();
          },
        );
      }),
    );
  }
}

class _OtpBox extends StatefulWidget {
  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.primaryColor,
    required this.textSecondary,
    required this.surfaceColor,
    required this.onChanged,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final Color primaryColor;
  final Color textSecondary;
  final Color surfaceColor;
  final ValueChanged<String> onChanged;

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _focused = widget.focusNode.hasFocus);
  }

  @override
  void dispose() {
    widget.focusNode.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.controller.text.isNotEmpty;
    final active = _focused || hasValue;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: 48,
      height: 56,
      decoration: BoxDecoration(
        color: active
            ? widget.primaryColor.withValues(alpha: 0.06)
            : widget.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: _focused
              ? widget.primaryColor
              : hasValue
                  ? widget.primaryColor.withValues(alpha: 0.40)
                  : widget.textSecondary.withValues(alpha: 0.20),
          width: _focused ? 2 : 1.5,
        ),
        boxShadow: _focused
            ? [
                BoxShadow(
                  color: widget.primaryColor.withValues(alpha: 0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                )
              ]
            : null,
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: widget.focusNode,
        enabled: widget.enabled,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        style: AppTextStyles.titleMedium.copyWith(
          color: widget.primaryColor,
          fontWeight: FontWeight.w700,
        ),
        decoration: const InputDecoration(
          counterText: '',
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: widget.onChanged,
      ),
    );
  }
}

// ── Botón circular ────────────────────────────────────────────────────────────

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isOnPrimary = color == null;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isOnPrimary
              ? Colors.white.withValues(alpha: 0.15)
              : (color!).withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 16,
          color: isOnPrimary ? Colors.white : color,
        ),
      ),
    );
  }
}
