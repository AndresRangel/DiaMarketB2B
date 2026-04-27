import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/i18n/translation_keys.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_text_field.dart';
import '../../domain/entities/company_entity.dart';
import '../notifiers/login_notifier.dart';
import '../notifiers/login_state.dart';

/// Pantalla de login.
///
/// Esta es la View — es "tonta" a propósito:
///   - NO valida campos (eso lo hace LoginNotifier)
///   - NO llama a APIs (eso lo hace LoginNotifier → LoginUseCase → Repositorio)
///   - Solo muestra el estado y delega acciones al Notifier
///
/// Equivalente GetX: la LoginView/LoginPage que tenías con Obx(() => ...) y
/// llamadas directas al controller con `Get.find<LoginController>().login()`.
/// Aquí lo hacemos con ref.watch() y ref.read() respectivamente.
///
/// Es ConsumerStatefulWidget (con estado interno) porque necesita
/// TextEditingController y FocusNode, que son objetos de UI atados al
/// ciclo de vida del widget — por eso viven en la View, no en el Notifier.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // TextEditingController: solo gestiona el texto del campo en pantalla.
  // No tiene lógica de negocio — por eso vive aquí, no en el Notifier.
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    // Liberar recursos cuando la pantalla desaparece.
    _usernameController.dispose();
    _passwordController.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch reconstruye este widget cada vez que loginState cambia.
    // Equivalente GetX: Obx(() => ...) alrededor del widget.
    final loginState = ref.watch(loginProvider);

    // ref.listen reacciona a cambios SIN reconstruir el widget.
    // Es el lugar correcto para side effects: navegar, mostrar snackbar, diálogos.
    // Equivalente GetX: ever(controller.state, (state) { Get.to(...) })
    ref.listen<LoginState>(loginProvider, (previous, next) {
      switch (next) {
        case LoginStateSuccess(:final session):
          // [TEMP] Snackbar de confirmación mientras se construyen las pantallas.
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '✅ Login exitoso — ${session.user.email ?? session.user.username}',
              ),
              backgroundColor: Colors.green.shade700,
              duration: const Duration(seconds: 4),
            ),
          );
          // El guard del router redirige automáticamente al home.
          break;

        case LoginStateNeedsCompanySelection(:final companies):
          // Múltiples empresas → mostrar selector modal.
          _showCompanySelector(context, companies);

        case LoginStateError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
          // Limpiar el error del Notifier para que no se muestre de nuevo
          // si el widget se reconstruye por otro motivo.
          ref.read(loginProvider.notifier).clearError();

        case _:
          break;
      }
    });

    // ConstrainedBox: limita el ancho en web/tablet para que el form
    // no quede ridículamente estirado. En móvil no cambia nada.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  _Logo(),
                  const SizedBox(height: 48),
                  _FormFields(
                    usernameController: _usernameController,
                    passwordController: _passwordController,
                    passwordFocusNode: _passwordFocusNode,
                    loginState: loginState,
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: TrKeys.login.tr(),
                    isLoading: loginState is LoginStateLoading,
                    // Si está cargando, onPressed = null → botón deshabilitado.
                    onPressed: loginState is LoginStateLoading
                        ? null
                        : () => ref.read(loginProvider.notifier).login(
                              _usernameController.text,
                              _passwordController.text,
                            ),
                  ),
                  const SizedBox(height: 16),
                  _SecondaryActions(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Muestra el diálogo de selección de empresa.
  /// Se llama desde ref.listen cuando el estado es needsCompanySelection.
  void _showCompanySelector(
    BuildContext context,
    List<CompanyEntity> companies,
  ) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _CompanySelectorSheet(
        companies: companies,
        onSelect: (company) {
          Navigator.of(context).pop();
          // Delegar al Notifier — la View no decide qué hacer,
          // solo informa al Notifier qué eligió el usuario.
          ref.read(loginProvider.notifier).selectCompany(company);
        },
      ),
    );
  }
}

// ── Widgets privados de la pantalla ──────────────────────────────────────────

/// Logo de la app desde el backend (white-label).
/// Si no hay URL o falla la carga, muestra el ícono genérico.
class _Logo extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final branding = ref.watch(themeProvider.select((c) => c.branding));

    return branding.logoUrl.isNotEmpty
        ? CachedNetworkImage(
            imageUrl: branding.logoUrl,
            height: 100,
            fit: BoxFit.contain,
            errorWidget: (_, _, _) => _fallbackIcon(context),
          )
        : _fallbackIcon(context);
  }

  Widget _fallbackIcon(BuildContext context) => Icon(
        Icons.store_rounded,
        size: 72,
        color: Theme.of(context).colorScheme.primary,
      );
}

/// Campos de formulario: usuario y contraseña.
/// Extraídos a un widget separado para mantener el build() principal limpio.
class _FormFields extends StatelessWidget {
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final FocusNode passwordFocusNode;
  final LoginState loginState;

  const _FormFields({
    required this.usernameController,
    required this.passwordController,
    required this.passwordFocusNode,
    required this.loginState,
  });

  @override
  Widget build(BuildContext context) {
    final isLoading = loginState is LoginStateLoading;

    return Column(
      children: [
        AppTextField(
          controller: usernameController,
          label: TrKeys.username.tr(),
          prefixIcon: const Icon(Icons.person_outline),
          enabled: !isLoading,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => passwordFocusNode.requestFocus(),
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: passwordController,
          label: TrKeys.password.tr(),
          prefixIcon: const Icon(Icons.lock_outline),
          isPassword: true,
          enabled: !isLoading,
          focusNode: passwordFocusNode,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}

/// Botones secundarios: "Olvidé mi contraseña" y "Registrarme".
/// Las rutas están definidas pero las pantallas se crean en Bloque 8.
class _SecondaryActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => context.push(AppRoutes.otp),
          child: Text(TrKeys.forgotPassword.tr()),
        ),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: Text(TrKeys.register.tr()),
        ),
      ],
    );
  }
}

/// Bottom sheet para seleccionar empresa cuando el usuario tiene acceso a varias.
class _CompanySelectorSheet extends StatelessWidget {
  final List<CompanyEntity> companies;
  final void Function(CompanyEntity) onSelect;

  const _CompanySelectorSheet({
    required this.companies,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selecciona tu empresa',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...companies.map(
            (company) => ListTile(
              leading: const Icon(Icons.business_outlined),
              title: Text(company.name),
              subtitle: company.code.isNotEmpty ? Text(company.code) : null,
              onTap: () => onSelect(company),
            ),
          ),
        ],
      ),
    );
  }
}
