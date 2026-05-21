import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/notifiers/auth_notifier.dart';
import '../../features/auth/presentation/notifiers/auth_state.dart';
import '../../features/auth/presentation/notifiers/otp_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/pending_approval_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/catalog/presentation/pages/home_page.dart';
import '../../features/catalog/presentation/pages/product_detail_page.dart';
import '../../features/catalog/presentation/pages/product_list_page.dart';
import '../../features/catalog/presentation/pages/search_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/promotions/presentation/pages/promotions_page.dart';
import '../shell/main_shell.dart';
import 'app_routes.dart';

part 'app_router.g.dart';

// ── Transición global: fade + slide vertical sutil ───────────────────────────

CustomTransitionPage<void> _page(LocalKey key, Widget child) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (_, animation, _, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        ),
      );
    },
  );
}

// ── Navigator keys — deben vivir fuera del provider para no recrearse ────────
// Sin estos, StatefulShellRoute.indexedStack genera keys inestables que
// chocan con el HeroController al navegar desde rutas fuera del shell.

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellBranchHomeKey = GlobalKey<NavigatorState>(debugLabel: 'branch-home');
final _shellBranchPromosKey = GlobalKey<NavigatorState>(debugLabel: 'branch-promos');
final _shellBranchCartKey = GlobalKey<NavigatorState>(debugLabel: 'branch-cart');
final _shellBranchProfileKey = GlobalKey<NavigatorState>(debugLabel: 'branch-profile');

// ── Notifier para disparar refresh del router ─────────────────────────────────

/// GoRouter necesita un Listenable para saber cuándo re-evaluar las
/// redirecciones. Este ChangeNotifier hace de puente entre Riverpod y GoRouter.
class _RouterRefreshNotifier extends ChangeNotifier {
  void refresh() => notifyListeners();
}

// ── Provider del router ────────────────────────────────────────────────────────

@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final refreshNotifier = _RouterRefreshNotifier();

  // ref.listen observa authProvider sin reconstruir el provider del router.
  ref.listen<AuthState>(authProvider, (prev, next) {
    refreshNotifier.refresh();
  });

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshNotifier,
    debugLogDiagnostics: true,

    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final location = state.matchedLocation;

      return switch (authState) {
        AuthStateInitial() =>
          location == AppRoutes.splash ? null : AppRoutes.splash,

        AuthStateUnauthenticated() =>
          (AppRoutes.publicRoutes.contains(location) &&
                  location != AppRoutes.splash)
              ? null
              : AppRoutes.login,

        AuthStateAuthenticated() =>
          AppRoutes.publicRoutes.contains(location) ? AppRoutes.home : null,
      };
    },

    routes: [
      // ── Auth (fuera del shell — sin bottom nav) ───────────────────────
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (_, state) => _page(state.pageKey, const SplashPage()),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (_, state) => _page(state.pageKey, const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (_, state) {
          final flowParam = state.uri.queryParameters['flow'];
          final flow = flowParam == 'registration'
              ? OtpFlow.registration
              : OtpFlow.recoverPassword;
          final phone = state.uri.queryParameters['phone'];
          return _page(state.pageKey, OtpPage(flow: flow, prefilledPhone: phone));
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (_, state) => _page(state.pageKey, const RegisterPage()),
      ),
      GoRoute(
        path: AppRoutes.pendingApproval,
        pageBuilder: (_, state) =>
            _page(state.pageKey, const PendingApprovalPage()),
      ),

      // ── Búsqueda (fuera del shell — pantalla completa) ───────────────
      GoRoute(
        path: AppRoutes.search,
        pageBuilder: (_, state) => _page(state.pageKey, const SearchPage()),
      ),

      // ── Lista de productos por categoría ─────────────────────────────
      GoRoute(
        path: AppRoutes.productList,
        pageBuilder: (_, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          final name = state.uri.queryParameters['name'] != null
              ? Uri.decodeComponent(state.uri.queryParameters['name']!)
              : null;
          return _page(
            state.pageKey,
            ProductListPage(categoryId: categoryId, categoryName: name),
          );
        },
      ),

      // ── Detalle de producto (fuera del shell — pantalla completa) ─────
      GoRoute(
        path: AppRoutes.productDetail,
        pageBuilder: (_, state) {
          final sku = state.pathParameters['id']!;
          return _page(state.pageKey, ProductDetailPage(sku: sku));
        },
      ),

      // ── Shell principal con NavigationBar ─────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          // Branch 0 — Inicio
          StatefulShellBranch(
            navigatorKey: _shellBranchHomeKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                pageBuilder: (_, state) =>
                    _page(state.pageKey, const HomePage()),
              ),
            ],
          ),

          // Branch 1 — Promociones
          StatefulShellBranch(
            navigatorKey: _shellBranchPromosKey,
            routes: [
              GoRoute(
                path: AppRoutes.promotions,
                pageBuilder: (_, state) =>
                    _page(state.pageKey, const PromotionsPage()),
              ),
            ],
          ),

          // Branch 2 — Carrito
          StatefulShellBranch(
            navigatorKey: _shellBranchCartKey,
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                pageBuilder: (_, state) =>
                    _page(state.pageKey, const CartPage()),
              ),
            ],
          ),

          // Branch 3 — Perfil
          StatefulShellBranch(
            navigatorKey: _shellBranchProfileKey,
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                pageBuilder: (_, state) =>
                    _page(state.pageKey, const ProfilePage()),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
