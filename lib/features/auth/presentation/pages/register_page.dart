import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/translation_keys.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../notifiers/register_notifier.dart';
import '../notifiers/register_state.dart';

/// Pantalla de pre-registro de nuevo cliente (S04).
///
/// Tras un registro exitoso, el servidor crea la cuenta en estado
/// "pendiente de aprobación". La app navega a PendingApprovalPage.
/// El distribuidor aprueba el cliente manualmente en su sistema.
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

  // Para mover el foco entre campos al presionar "siguiente" en el teclado
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  // Tipo de negocio seleccionado en el dropdown
  // TODO: cuando llegue S40 (tipos de negocio), cargar desde el servidor
  String? _selectedBusinessType;
  static const _businessTypes = [
    'TIENDA',
    'MINIMARKET',
    'RESTAURANTE',
    'CAFETERIA',
    'OTRO',
  ];

  // Ciudad — placeholder hasta que llegue S16 (ciudades)
  // Por ahora usamos un string fijo; en Fase 8 se conecta al selector real
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

    // ref.listen para side effects: navegar a PendingApproval o mostrar error
    ref.listen<RegisterState>(registerProvider, (previous, next) {
      switch (next) {
        case RegisterStateSuccess():
          // Registro exitoso → ir a pantalla de aprobación pendiente
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
      appBar: AppBar(
        title: Text(TrKeys.register.tr()),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Crea tu cuenta',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tu solicitud quedará pendiente de aprobación por el distribuidor.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 32),

                  // ── Campos del formulario ─────────────────────────────────
                  AppTextField(
                    controller: _usernameController,
                    label: TrKeys.username.tr(),
                    prefixIcon: const Icon(Icons.person_outline),
                    enabled: !isLoading,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _passwordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _passwordController,
                    label: TrKeys.password.tr(),
                    prefixIcon: const Icon(Icons.lock_outline),
                    isPassword: true,
                    enabled: !isLoading,
                    focusNode: _passwordFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _confirmPasswordFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _confirmPasswordController,
                    label: 'Confirmar contraseña',
                    prefixIcon: const Icon(Icons.lock_outline),
                    isPassword: true,
                    enabled: !isLoading,
                    focusNode: _confirmPasswordFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _phoneFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _phoneController,
                    label: 'Teléfono celular',
                    prefixIcon: const Icon(Icons.phone_outlined),
                    keyboardType: TextInputType.phone,
                    enabled: !isLoading,
                    focusNode: _phoneFocus,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) => _emailFocus.requestFocus(),
                  ),
                  const SizedBox(height: 16),

                  AppTextField(
                    controller: _emailController,
                    label: 'Correo electrónico',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    enabled: !isLoading,
                    focusNode: _emailFocus,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 16),

                  // ── Tipo de negocio (dropdown) ────────────────────────────
                  DropdownButtonFormField<String>(
                    initialValue: _selectedBusinessType,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de negocio',
                      prefixIcon: Icon(Icons.store_outlined),
                      border: OutlineInputBorder(),
                    ),
                    items: _businessTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          ),
                        )
                        .toList(),
                    onChanged: isLoading
                        ? null
                        : (value) =>
                            setState(() => _selectedBusinessType = value),
                  ),
                  const SizedBox(height: 16),

                  // ── Código de referido (opcional) ─────────────────────────
                  AppTextField(
                    controller: _referralController,
                    label: 'Código de referido (opcional)',
                    prefixIcon: const Icon(Icons.card_giftcard_outlined),
                    enabled: !isLoading,
                    textInputAction: TextInputAction.done,
                  ),
                  const SizedBox(height: 32),

                  AppButton(
                    label: TrKeys.register.tr(),
                    isLoading: isLoading,
                    onPressed: isLoading ? null : _onSubmit,
                  ),
                  const SizedBox(height: 16),

                  Center(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: const Text('¿Ya tienes cuenta? Inicia sesión'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
