import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/theme_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_state.dart';
import '../../features/cart/presentation/notifiers/cart_notifier.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    this.currentRoute = '',
    this.showHeader = true,
  });

  final String currentRoute;
  /// false en desktop — el header vive en el TopBar global.
  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary =
        ref.watch(themeProvider.select((c) => c.theme.primaryColor));
    final authState = ref.watch(authProvider);
    final cartCount =
        ref.watch(cartProvider.select((c) => c.itemCount));

    final session =
        authState is AuthStateAuthenticated ? authState.session : null;
    final userName = session?.user.username ?? 'Usuario';
    final companyName = session?.selectedCompany.name ?? '';

    return Container(
      color: const Color(0xFFFAFAFA),
      child: Column(
        children: [
          // Header solo en móvil — en desktop lo reemplaza el TopBar global.
          if (showHeader)
            _Header(
              userName: userName,
              companyName: companyName,
              primary: primary,
            ),

          // ── Nav items ────────────────────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
              children: [
                _NavItem(
                  iconOutlined: Icons.home_outlined,
                  iconFilled: Icons.home_rounded,
                  label: 'Inicio',
                  route: AppRoutes.home,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.home),
                ),
                _NavItem(
                  iconOutlined: Icons.local_offer_outlined,
                  iconFilled: Icons.local_offer_rounded,
                  label: 'Promociones',
                  route: AppRoutes.promotions,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.promotions),
                ),
                _NavItem(
                  iconOutlined: Icons.shopping_cart_outlined,
                  iconFilled: Icons.shopping_cart_rounded,
                  label: 'Carrito',
                  route: AppRoutes.cart,
                  current: currentRoute,
                  primary: primary,
                  badge: cartCount > 0 ? '$cartCount' : null,
                  onTap: () => _go(context, AppRoutes.cart),
                ),

                const SizedBox(height: 16),
                _GroupLabel('Mi cuenta'),
                const SizedBox(height: 4),

                _NavItem(
                  iconOutlined: Icons.inventory_2_outlined,
                  iconFilled: Icons.inventory_2_rounded,
                  label: 'Mis Pedidos',
                  route: AppRoutes.orders,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.orders),
                ),
                _NavItem(
                  iconOutlined: Icons.account_balance_outlined,
                  iconFilled: Icons.account_balance_rounded,
                  label: 'Cuentas x Pagar',
                  route: AppRoutes.accounts,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.accounts),
                ),
                _NavItem(
                  iconOutlined: Icons.workspace_premium_outlined,
                  iconFilled: Icons.workspace_premium_rounded,
                  label: 'Puntos',
                  route: AppRoutes.points,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.points),
                ),
                _NavItem(
                  iconOutlined: Icons.confirmation_number_outlined,
                  iconFilled: Icons.confirmation_number_rounded,
                  label: 'Cupones',
                  route: AppRoutes.coupons,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.coupons),
                ),
                _NavItem(
                  iconOutlined: Icons.article_outlined,
                  iconFilled: Icons.article_rounded,
                  label: 'Noticias',
                  route: AppRoutes.news,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.news),
                ),
                _NavItem(
                  iconOutlined: Icons.chat_bubble_outline_rounded,
                  iconFilled: Icons.chat_bubble_rounded,
                  label: 'Mensajes',
                  route: AppRoutes.messages,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.messages),
                ),

                const SizedBox(height: 16),
                _GroupLabel('Soporte'),
                const SizedBox(height: 4),

                _NavItem(
                  iconOutlined: Icons.support_agent_outlined,
                  iconFilled: Icons.support_agent_rounded,
                  label: 'Canales de Atención',
                  route: AppRoutes.support,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.support),
                ),
                _NavItem(
                  iconOutlined: Icons.policy_outlined,
                  iconFilled: Icons.policy_rounded,
                  label: 'Términos de Uso',
                  route: '/terms',
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, '/terms'),
                ),
                _NavItem(
                  iconOutlined: Icons.manage_accounts_outlined,
                  iconFilled: Icons.manage_accounts_rounded,
                  label: 'Mi Perfil',
                  route: AppRoutes.profile,
                  current: currentRoute,
                  primary: primary,
                  onTap: () => _go(context, AppRoutes.profile),
                ),

                const SizedBox(height: 24),

                // Logout
                _LogoutButton(ref: ref),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).maybePop();
    context.go(route);
  }
}

// ── Header ────────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.userName,
    required this.companyName,
    required this.primary,
  });

  final String userName;
  final String companyName;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final initials = userName.isNotEmpty
        ? userName.substring(0, 1).toUpperCase()
        : 'U';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPadding + 20, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          // Avatar con gradiente
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  primary,
                  primary.withValues(alpha: 0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (companyName.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    companyName,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF9E9E9E),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav item ──────────────────────────────────────────────────────────────────

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.iconOutlined,
    required this.iconFilled,
    required this.label,
    required this.route,
    required this.current,
    required this.primary,
    required this.onTap,
    this.badge,
  });

  final IconData iconOutlined;
  final IconData iconFilled;
  final String label;
  final String route;
  final String current;
  final Color primary;
  final VoidCallback onTap;
  final String? badge;

  bool get _active =>
      current == route || current.startsWith('$route/');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 2),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: _active
              ? primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              _active ? iconFilled : iconOutlined,
              size: 20,
              color: _active ? primary : const Color(0xFF6B7280),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight:
                      _active ? FontWeight.w600 : FontWeight.w400,
                  color: _active
                      ? primary
                      : const Color(0xFF374151),
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade600,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ── Logout ────────────────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.ref});
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).maybePop();
        ref.read(authProvider.notifier).logout();
      },
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.logout_rounded, size: 20, color: Colors.red.shade600),
            const SizedBox(width: 12),
            Text(
              'Cerrar Sesión',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.red.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Group label ───────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 2),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Color(0xFFB0B7C3),
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
