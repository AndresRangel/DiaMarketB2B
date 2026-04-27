import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/i18n/translation_keys.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/router/app_routes.dart';

/// Pantalla informativa mostrada tras un pre-registro exitoso.
///
/// El registro en este sistema B2B no es automático: el distribuidor
/// debe aprobar manualmente cada nuevo cliente. Esta pantalla
/// comunica eso claramente y no tiene lógica de negocio.
///
/// Por eso es un StatelessWidget simple — no necesita Notifier.
/// Regla del CLAUDE.md: solo pantallas informativas sin lógica pueden
/// ser ConsumerWidget/StatelessWidget directos sin Notifier.
class PendingApprovalPage extends StatelessWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Sin AppBar: esta es una pantalla "final" del flujo de registro.
      // El usuario no puede volver atrás — debe esperar la aprobación.
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ── Ícono ─────────────────────────────────────────────────
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.hourglass_top_rounded,
                      size: 52,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── Título ────────────────────────────────────────────────
                  Text(
                    TrKeys.pendingApproval.tr(),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // ── Mensaje explicativo ───────────────────────────────────
                  Text(
                    'Tu solicitud de registro fue enviada exitosamente.\n\n'
                    'El distribuidor revisará tu información y te notificará '
                    'cuando tu cuenta esté activa.\n\n'
                    'Este proceso puede tomar hasta 24 horas hábiles.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant,
                          height: 1.6,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // ── Botón volver al login ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.login),
                      label: Text(TrKeys.login.tr()),
                      onPressed: () => context.go(AppRoutes.login),
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
}
