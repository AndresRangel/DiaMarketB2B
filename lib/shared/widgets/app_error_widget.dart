import 'package:flutter/material.dart';

import '../constants/app_spacing.dart';
import '../constants/app_text_styles.dart';
import 'app_button.dart';

/// Widget de error con ícono, mensaje y botón "Reintentar".
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.message,
    this.onRetry,
    this.title,
  });

  final String message;
  final VoidCallback? onRetry;
  final String? title;

  @override
  Widget build(BuildContext context) {
    final errorColor = Theme.of(context).colorScheme.error;
    final textSecondary = Theme.of(context)
        .colorScheme
        .onSurface
        .withValues(alpha: 0.55);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ícono en círculo error
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.10),
                shape: BoxShape.circle,
                border: Border.all(
                  color: errorColor.withValues(alpha: 0.20),
                  width: 1.5,
                ),
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 36,
                color: errorColor,
              ),
            ),

            const SizedBox(height: AppSpacing.lg),

            Text(
              title ?? 'Algo salió mal',
              style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(color: textSecondary),
              textAlign: TextAlign.center,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Reintentar',
                icon: Icons.refresh_rounded,
                onPressed: onRetry,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
