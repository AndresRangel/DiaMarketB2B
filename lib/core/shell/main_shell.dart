import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../responsive/breakpoints.dart';
import '../theme/theme_notifier.dart';
import '../../features/cart/presentation/notifiers/cart_notifier.dart';
import 'app_drawer.dart';
import 'shell_key.dart';
import 'top_bar.dart';

/// Shell principal de la app.
///
/// Móvil  (< 900px): NavigationBar inferior + Drawer lateral.
/// Desktop (≥ 900px): Sidebar permanente 260px con toda la navegación.
class MainShell extends ConsumerWidget {
  const MainShell({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor =
        ref.watch(themeProvider.select((c) => c.theme.primaryColor));
    final cartCount =
        ref.watch(cartProvider.select((c) => c.itemCount));
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
    final currentRoute = GoRouterState.of(context).uri.path;

    if (isDesktop) {
      return Scaffold(
        body: Column(
          children: [
            // TopBar global — logo, search, cart, user
            const DesktopTopBar(),
            Expanded(
              child: Row(
                children: [
                  // Sidebar sin header (el header ya está en TopBar)
                  SizedBox(
                    width: 220,
                    child: AppDrawer(
                      currentRoute: currentRoute,
                      showHeader: false,
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),
                  Expanded(child: shell),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ── Móvil ────────────────────────────────────────────────────────────────
    return Scaffold(
      key: mainScaffoldKey,
      drawer: Drawer(
        width: 280,
        child: AppDrawer(currentRoute: currentRoute),
      ),
      body: shell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: shell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        backgroundColor: Colors.white,
        elevation: 8,
        shadowColor: Colors.black12,
        indicatorColor: primaryColor.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: primaryColor),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: const Icon(Icons.local_offer_outlined),
            selectedIcon: Icon(Icons.local_offer, color: primaryColor),
            label: 'Promociones',
          ),
          NavigationDestination(
            icon: _CartIcon(
              count: cartCount,
              primaryColor: primaryColor,
              selected: false,
            ),
            selectedIcon: _CartIcon(
              count: cartCount,
              primaryColor: primaryColor,
              selected: true,
            ),
            label: 'Carrito',
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: primaryColor),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  void _onDestinationSelected(int index) {
    shell.goBranch(
      index,
      initialLocation: index == shell.currentIndex,
    );
  }
}

// ── Ícono de carrito con badge ────────────────────────────────────────────────

class _CartIcon extends StatelessWidget {
  const _CartIcon({
    required this.count,
    required this.primaryColor,
    required this.selected,
  });

  final int count;
  final Color primaryColor;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(fontSize: 10, color: Colors.white),
      ),
      backgroundColor: Colors.red.shade600,
      child: Icon(
        selected ? Icons.shopping_cart : Icons.shopping_cart_outlined,
        color: selected ? primaryColor : null,
      ),
    );
  }
}
