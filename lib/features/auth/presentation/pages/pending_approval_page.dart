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

class PendingApprovalPage extends ConsumerWidget {
  const PendingApprovalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final textPrimary = config.theme.textPrimaryColor;
    final textSecondary = config.theme.textSecondaryColor;
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    return Scaffold(
      backgroundColor: config.theme.backgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 520 : 480),
            child: Container(
              padding: EdgeInsets.all(isDesktop ? AppSpacing.xxl : AppSpacing.xl),
              decoration: isDesktop
                  ? BoxDecoration(
                      color: config.theme.surfaceColor,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 32,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Ícono animado ─────────────────────────────────────
                  _PulsingIcon(primary: primary),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Título ────────────────────────────────────────────
                  Text(
                    TrKeys.pendingApproval.tr(),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // ── Mensaje ───────────────────────────────────────────
                  Text(
                    'Tu solicitud de registro fue enviada exitosamente.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.sm),

                  Text(
                    'El distribuidor revisará tu información y te notificará '
                    'cuando tu cuenta esté activa.',
                    style: AppTextStyles.bodyMedium.copyWith(
                        color: textSecondary),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  // ── Info chips ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.base),
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                          color: primary.withValues(alpha: 0.15)),
                    ),
                    child: Column(
                      children: [
                        _InfoRow(
                          icon: Icons.schedule_rounded,
                          text: 'Proceso de aprobación: hasta 24 horas hábiles',
                          color: primary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _InfoRow(
                          icon: Icons.notifications_outlined,
                          text: 'Recibirás una notificación cuando esté listo',
                          color: primary,
                          textSecondary: textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _InfoRow(
                          icon: Icons.email_outlined,
                          text: 'Revisa tu correo para más información',
                          color: primary,
                          textSecondary: textSecondary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.xl),

                  AppButton(
                    label: TrKeys.login.tr(),
                    icon: Icons.login_rounded,
                    onPressed: () => context.go(AppRoutes.login),
                    isFullWidth: true,
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

// ── Ícono con anillo pulsante ─────────────────────────────────────────────────

class _PulsingIcon extends StatefulWidget {
  const _PulsingIcon({required this.primary});
  final Color primary;

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _ring;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();

    _ring = Tween<double>(begin: 0.8, end: 1.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 110,
      height: 110,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Anillo pulsante
          AnimatedBuilder(
            animation: _ring,
            builder: (_, _) => Transform.scale(
              scale: _ring.value,
              child: Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.primary.withValues(
                    alpha: (1.0 - (_ring.value - 0.8) / 0.5) * 0.15,
                  ),
                ),
              ),
            ),
          ),
          // Ícono central
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: widget.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: widget.primary.withValues(alpha: 0.25),
                width: 2,
              ),
            ),
            child: Icon(
              Icons.hourglass_top_rounded,
              size: 36,
              color: widget.primary,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fila informativa ──────────────────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.text,
    required this.color,
    required this.textSecondary,
  });

  final IconData icon;
  final String text;
  final Color color;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.70)),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.labelSmall.copyWith(color: textSecondary),
          ),
        ),
      ],
    );
  }
}
