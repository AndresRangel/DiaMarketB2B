import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/theme_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_state.dart';
import '../../features/cart/presentation/notifiers/cart_notifier.dart';

/// TopBar global para desktop. Altura fija 64px.
/// Solo visible en pantallas ≥ 900px (lo controla MainShell).
class DesktopTopBar extends ConsumerWidget implements PreferredSizeWidget {
  const DesktopTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final cartCount = ref.watch(cartProvider.select((c) => c.itemCount));
    final authState = ref.watch(authProvider);
    final session =
        authState is AuthStateAuthenticated ? authState.session : null;
    final userName = session?.user.username ?? '';
    final initials =
        userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: primary,
        boxShadow: [
          BoxShadow(
            color: primary.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          // ── Logo ──────────────────────────────────────────────────────
          SizedBox(
            height: 36,
            width: 130,
            child: config.branding.logoLightUrl.isNotEmpty ||
                    config.branding.logoUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: config.branding.logoLightUrl.isNotEmpty
                        ? config.branding.logoLightUrl
                        : config.branding.logoUrl,
                    fit: BoxFit.contain,
                    alignment: Alignment.centerLeft,
                    errorWidget: (_, _, _) => _AppName(config.branding.appName),
                    placeholder: (_, _) => const SizedBox.shrink(),
                  )
                : _AppName(config.branding.appName),
          ),

          const SizedBox(width: 32),

          // ── Search bar ────────────────────────────────────────────────
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: GestureDetector(
                onTap: () => context.push(AppRoutes.search),
                child: Container(
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.2)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      Icon(Icons.search,
                          color: Colors.white.withValues(alpha: 0.7),
                          size: 18),
                      const SizedBox(width: 10),
                      Text(
                        'Buscar productos...',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const Spacer(),

          // ── Acciones ──────────────────────────────────────────────────
          _TopBarAction(
            icon: Icons.notifications_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 4),

          // Carrito con badge
          Stack(
            clipBehavior: Clip.none,
            children: [
              _TopBarAction(
                icon: Icons.shopping_cart_outlined,
                onTap: () => context.go(AppRoutes.cart),
              ),
              if (cartCount > 0)
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 1.5),
                    ),
                    child: Center(
                      child: Text(
                        cartCount > 9 ? '9+' : '$cartCount',
                        style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 16),

          // ── User chip ─────────────────────────────────────────────────
          GestureDetector(
            onTap: () => context.go(AppRoutes.profile),
            child: Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Avatar mini
                  Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.25),
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (userName.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 120),
                      child: Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const SizedBox(width: 4),
                  Icon(Icons.keyboard_arrow_down_rounded,
                      size: 16,
                      color: Colors.white.withValues(alpha: 0.8)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TopBarAction extends StatelessWidget {
  const _TopBarAction({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
