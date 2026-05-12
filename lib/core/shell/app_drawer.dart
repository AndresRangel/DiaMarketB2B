import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../router/app_routes.dart';
import '../theme/theme_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_state.dart';
import '../../features/cart/presentation/notifiers/cart_notifier.dart';
import '../../shared/constants/app_radius.dart';
import '../../shared/constants/app_spacing.dart';
import '../../shared/constants/app_text_styles.dart';

class AppDrawer extends ConsumerWidget {
  const AppDrawer({
    super.key,
    this.currentRoute = '',
    this.showHeader = true,
  });

  final String currentRoute;
  final bool showHeader;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final surface = config.theme.surfaceColor;
    final bg = config.theme.backgroundColor;
    final textPrimary = config.theme.textPrimaryColor;
    final textSecondary = config.theme.textSecondaryColor;
    final authState = ref.watch(authProvider);
    final cartCount = ref.watch(cartProvider.select((c) => c.itemCount));

    final session =
        authState is AuthStateAuthenticated ? authState.session : null;
    final userName = session?.user.username ?? 'Usuario';
    final companyName = session?.selectedCompany.name ?? '';

    final navItems = [
      _NavItem(
        iconOutlined: Icons.home_outlined,
        iconFilled: Icons.home_rounded,
        label: 'Inicio',
        route: AppRoutes.home,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.home),
      ),
      _NavItem(
        iconOutlined: Icons.local_offer_outlined,
        iconFilled: Icons.local_offer_rounded,
        label: 'Promociones',
        route: AppRoutes.promotions,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.promotions),
      ),
      _NavItem(
        iconOutlined: Icons.shopping_cart_outlined,
        iconFilled: Icons.shopping_cart_rounded,
        label: 'Carrito',
        route: AppRoutes.cart,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        badge: cartCount > 0 ? '$cartCount' : null,
        onTap: () => _go(context, AppRoutes.cart),
      ),
      _GroupLabel('MI CUENTA', textSecondary),
      _NavItem(
        iconOutlined: Icons.inventory_2_outlined,
        iconFilled: Icons.inventory_2_rounded,
        label: 'Mis Pedidos',
        route: AppRoutes.orders,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.orders),
      ),
      _NavItem(
        iconOutlined: Icons.account_balance_outlined,
        iconFilled: Icons.account_balance_rounded,
        label: 'Cuentas x Pagar',
        route: AppRoutes.accounts,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.accounts),
      ),
      _NavItem(
        iconOutlined: Icons.workspace_premium_outlined,
        iconFilled: Icons.workspace_premium_rounded,
        label: 'Puntos',
        route: AppRoutes.points,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.points),
      ),
      _NavItem(
        iconOutlined: Icons.confirmation_number_outlined,
        iconFilled: Icons.confirmation_number_rounded,
        label: 'Cupones',
        route: AppRoutes.coupons,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.coupons),
      ),
      _NavItem(
        iconOutlined: Icons.article_outlined,
        iconFilled: Icons.article_rounded,
        label: 'Noticias',
        route: AppRoutes.news,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.news),
      ),
      _NavItem(
        iconOutlined: Icons.chat_bubble_outline_rounded,
        iconFilled: Icons.chat_bubble_rounded,
        label: 'Mensajes',
        route: AppRoutes.messages,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.messages),
      ),
      _GroupLabel('SOPORTE', textSecondary),
      _NavItem(
        iconOutlined: Icons.support_agent_outlined,
        iconFilled: Icons.support_agent_rounded,
        label: 'Canales de Atención',
        route: AppRoutes.support,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.support),
      ),
      _NavItem(
        iconOutlined: Icons.policy_outlined,
        iconFilled: Icons.policy_rounded,
        label: 'Términos de Uso',
        route: '/terms',
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, '/terms'),
      ),
      _NavItem(
        iconOutlined: Icons.manage_accounts_outlined,
        iconFilled: Icons.manage_accounts_rounded,
        label: 'Mi Perfil',
        route: AppRoutes.profile,
        current: currentRoute,
        primary: primary,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        onTap: () => _go(context, AppRoutes.profile),
      ),
    ];

    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      color: surface,
      child: Column(
        children: [
          // ── Header con gradiente primario ─────────────────────────────
          if (showHeader)
            _Header(
              userName: userName,
              companyName: companyName,
              primary: primary,
              onClose: () => Navigator.of(context).maybePop(),
            ),

          // ── Nav items scrollables ─────────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.sm),
              children: navItems,
            ),
          ),

          // ── Logout sticky al fondo ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              color: surface,
              border: Border(
                top: BorderSide(
                  color: textSecondary.withValues(alpha: 0.10),
                ),
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.sm,
              AppSpacing.md,
              AppSpacing.sm + bottomPadding,
            ),
            child: _LogoutTile(
              ref: ref,
              bg: bg,
              onTap: () {
                Navigator.of(context).maybePop();
                ref.read(authProvider.notifier).logout();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _go(BuildContext context, String route) {
    Navigator.of(context).maybePop();
    // replace() usa replaceState en browser → no acumula historial de navegación
    context.replace(route);
  }
}

// ── Header con gradiente primario ─────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.userName,
    required this.companyName,
    required this.primary,
    required this.onClose,
  });

  final String userName;
  final String companyName;
  final Color primary;
  final VoidCallback onClose;

  Color get _primaryDark {
    final hsl = HSLColor.fromColor(primary);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final initials =
        userName.isNotEmpty ? userName.substring(0, 1).toUpperCase() : 'U';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        topPadding + AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [primary, _primaryDark],
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.18),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.35),
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                initials,
                style: AppTextStyles.titleSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Nombre + empresa
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (companyName.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    companyName,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Botón cerrar circular
          GestureDetector(
            onTap: onClose,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 32,
              height: 32,
              margin: const EdgeInsets.only(left: AppSpacing.sm),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Nav item con barra izquierda ──────────────────────────────────────────────

class _NavItem extends StatefulWidget {
  const _NavItem({
    required this.iconOutlined,
    required this.iconFilled,
    required this.label,
    required this.route,
    required this.current,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
    this.badge,
  });

  final IconData iconOutlined;
  final IconData iconFilled;
  final String label;
  final String route;
  final String current;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;
  final String? badge;

  bool get _active =>
      current == route || current.startsWith('$route/');

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget._active;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          margin: const EdgeInsets.only(bottom: 1),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 3),
          decoration: BoxDecoration(
            color: active
                ? widget.primary.withValues(alpha: 0.09)
                : _hovered
                    ? widget.primary.withValues(alpha: 0.04)
                    : Colors.transparent,
            // Barra izquierda activa — rounded right, flush left
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(AppRadius.sm),
              bottomRight: Radius.circular(AppRadius.sm),
            ),
            border: Border(
              left: BorderSide(
                color: active ? widget.primary : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                active ? widget.iconFilled : widget.iconOutlined,
                size: 20,
                color: active
                    ? widget.primary
                    : widget.textSecondary.withValues(alpha: 0.8),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  widget.label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight:
                        active ? FontWeight.w600 : FontWeight.w400,
                    color: active ? widget.primary : widget.textPrimary,
                  ),
                ),
              ),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs + 2, vertical: 2),
                  decoration: BoxDecoration(
                    color: widget.primary,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    widget.badge!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Group label ───────────────────────────────────────────────────────────────

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.text, this.color);
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base + 3, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: color.withValues(alpha: 0.5),
          letterSpacing: 1.1,
          fontWeight: FontWeight.w600,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── Logout sticky ─────────────────────────────────────────────────────────────

class _LogoutTile extends StatefulWidget {
  const _LogoutTile({
    required this.ref,
    required this.bg,
    required this.onTap,
  });

  final WidgetRef ref;
  final Color bg;
  final VoidCallback onTap;

  @override
  State<_LogoutTile> createState() => _LogoutTileState();
}

class _LogoutTileState extends State<_LogoutTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm + 3),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.red.shade50
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.sm),
          ),
          child: Row(
            children: [
              Icon(Icons.logout_rounded,
                  size: 20, color: Colors.red.shade500),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Cerrar Sesión',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.red.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
