import 'package:flutter/material.dart';

/// Botón primario de la app.
///
/// Maneja automáticamente el estado de carga: cuando [isLoading] es true,
/// muestra un spinner y deshabilita el botón para evitar doble tap.
///
/// Uso:
/// ```dart
/// AppButton(
///   label: TrKeys.login.tr(),
///   onPressed: () => ref.read(loginNotifierProvider.notifier).login(),
///   isLoading: loginState is LoginStateLoading,
/// )
/// ```
class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;
  final ButtonStyle? style;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton(
      // Si está cargando, onPressed = null → botón deshabilitado automáticamente
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                // El color del spinner toma el color del texto del botón
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(label),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

/// Variante de botón secundario (outlined).
class AppOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isFullWidth;

  const AppOutlinedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final button = OutlinedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );

    if (isFullWidth) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
