import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/translation_keys.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../notifiers/otp_notifier.dart';
import '../notifiers/otp_state.dart';

/// Pantalla OTP — sirve para dos flujos:
///   1. "Olvidé mi contraseña": el usuario ingresa su teléfono, recibe un SMS
///      con el código, lo valida y vuelve al Login con mensaje de éxito.
///   2. Verificación de registro: igual pero tras registrarse.
///
/// El flujo se pasa como query param en la ruta:
///   /otp?flow=recoverPassword
///   /otp?flow=registration
///
/// La pantalla tiene DOS fases visuales:
///   Fase 1 (initial/sendingOtp): campo de teléfono + botón "Enviar código"
///   Fase 2 (otpSent/validating): campo de 6 dígitos + botón "Verificar" + countdown
class OtpPage extends ConsumerStatefulWidget {
  /// Flujo desde el que se abrió esta pantalla.
  final OtpFlow flow;

  /// Teléfono pre-cargado (si llega desde el registro, por ejemplo).
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
  // 6 controllers separados, uno por cada dígito del OTP.
  // Esto permite mover el foco automáticamente al siguiente campo.
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    // Si llegó un teléfono pre-cargado, lo ponemos en el campo
    if (widget.prefilledPhone != null) {
      _phoneController.text = widget.prefilledPhone!;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (final c in _otpControllers) { c.dispose(); }
    for (final f in _otpFocusNodes) { f.dispose(); }
    super.dispose();
  }

  /// Une los 6 campos en un string de 6 dígitos.
  String get _otpCode =>
      _otpControllers.map((c) => c.text).join();

  @override
  Widget build(BuildContext context) {
    // ref.watch reconstruye el widget cuando cambia el estado del Notifier.
    final otpState = ref.watch(otpProvider);

    // ref.listen para side effects: navegar, mostrar snackbar.
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
          // Si había teléfono anterior, lo restauramos en el campo
          if (previousPhone != null) {
            _phoneController.text = previousPhone;
          }

        case _:
          break;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(TrKeys.otpTitle.tr()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildBody(context, otpState),
            ),
          ),
        ),
      ),
    );
  }

  /// Decide qué fase mostrar según el estado actual.
  Widget _buildBody(BuildContext context, OtpState otpState) {
    // Fase 1: pedir teléfono
    if (otpState is OtpStateInitial || otpState is OtpStateSendingOtp) {
      return _PhaseOne(
        phoneController: _phoneController,
        isLoading: otpState is OtpStateSendingOtp,
        onSend: () =>
            ref.read(otpProvider.notifier).sendOtp(_phoneController.text),
      );
    }

    // Fase 2: ingresar código
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

    // success y error se manejan en ref.listen.
    // Mientras el listener actúa, mostramos la fase 1 como fallback.
    return _PhaseOne(
      phoneController: _phoneController,
      isLoading: false,
      onSend: () =>
          ref.read(otpProvider.notifier).sendOtp(_phoneController.text),
    );
  }

  /// Navega según el flujo después de validar el OTP correctamente.
  void _handleSuccess(BuildContext context) {
    switch (widget.flow) {
      case OtpFlow.recoverPassword:
        // Volver al login con un mensaje de éxito.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Contraseña restablecida. Revisa tu correo o SMS.',
            ),
          ),
        );
        context.go(AppRoutes.login);

      case OtpFlow.registration:
        // Registro verificado → ir al home o pending según el caso.
        context.go(AppRoutes.login);
    }
  }
}

// ── Widgets privados ─────────────────────────────────────────────────────────

/// Fase 1: el usuario ingresa su número de teléfono.
class _PhaseOne extends StatelessWidget {
  final TextEditingController phoneController;
  final bool isLoading;
  final VoidCallback onSend;

  const _PhaseOne({
    required this.phoneController,
    required this.isLoading,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Icon(
          Icons.sms_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          'Ingresa tu número de celular',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Te enviaremos un código de verificación por SMS.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        AppTextField(
          controller: phoneController,
          label: 'Número de celular',
          prefixIcon: const Icon(Icons.phone_outlined),
          keyboardType: TextInputType.phone,
          enabled: !isLoading,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => onSend(),
        ),
        const SizedBox(height: 24),
        AppButton(
          label: 'Enviar código',
          isLoading: isLoading,
          onPressed: isLoading ? null : onSend,
        ),
      ],
    );
  }
}

/// Fase 2: el usuario ingresa los 6 dígitos del código OTP.
class _PhaseTwo extends StatelessWidget {
  final String phone;
  final int resendCooldown;
  final bool isLoading;
  final List<TextEditingController> otpControllers;
  final List<FocusNode> otpFocusNodes;
  final VoidCallback onVerify;
  final VoidCallback onResend;
  final VoidCallback onChangePhone;

  const _PhaseTwo({
    required this.phone,
    required this.resendCooldown,
    required this.isLoading,
    required this.otpControllers,
    required this.otpFocusNodes,
    required this.onVerify,
    required this.onResend,
    required this.onChangePhone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 32),
        Icon(
          Icons.lock_open_outlined,
          size: 64,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 24),
        Text(
          TrKeys.otpTitle.tr(),
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Enviamos un código a $phone',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        TextButton(
          onPressed: onChangePhone,
          child: const Text('Cambiar número'),
        ),
        const SizedBox(height: 32),

        // ── 6 campos de un dígito cada uno ─────────────────────────────────
        _OtpInputRow(
          controllers: otpControllers,
          focusNodes: otpFocusNodes,
          enabled: !isLoading,
          onCompleted: onVerify,
        ),

        const SizedBox(height: 32),
        AppButton(
          label: 'Verificar',
          isLoading: isLoading,
          onPressed: isLoading ? null : onVerify,
        ),
        const SizedBox(height: 16),

        // ── Botón reenviar con countdown ────────────────────────────────────
        Center(
          child: resendCooldown > 0
              ? Text(
                  // Muestra "Reenviar en 45s"
                  '${TrKeys.otpResend.tr()} en ${resendCooldown}s',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                )
              : TextButton(
                  onPressed: onResend,
                  child: Text(TrKeys.otpResend.tr()),
                ),
        ),
      ],
    );
  }
}

/// Fila de 6 campos de texto de un dígito cada uno.
/// Al escribir un dígito, el foco pasa automáticamente al siguiente campo.
/// Al borrar, el foco regresa al campo anterior.
class _OtpInputRow extends StatelessWidget {
  final List<TextEditingController> controllers;
  final List<FocusNode> focusNodes;
  final bool enabled;
  final VoidCallback onCompleted;

  const _OtpInputRow({
    required this.controllers,
    required this.focusNodes,
    required this.enabled,
    required this.onCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 44,
          child: TextField(
            controller: controllers[index],
            focusNode: focusNodes[index],
            enabled: enabled,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: [
              // Solo permite un dígito numérico
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: Theme.of(context).textTheme.headlineSmall,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < 5) {
                // Avanzar al siguiente campo
                focusNodes[index + 1].requestFocus();
              } else if (value.isEmpty && index > 0) {
                // Retroceder al campo anterior al borrar
                focusNodes[index - 1].requestFocus();
              }
              // Si se completaron los 6 dígitos, llamar onCompleted
              final code = controllers.map((c) => c.text).join();
              if (code.length == 6) onCompleted();
            },
          ),
        );
      }),
    );
  }
}
