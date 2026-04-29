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
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.otp,
        builder: (_, state) {
          final flowParam = state.uri.queryParameters['flow'];
          final flow = flowParam == 'registration'
              ? OtpFlow.registration
              : OtpFlow.recoverPassword;
          final phone = state.uri.queryParameters['phone'];
          return OtpPage(flow: flow, prefilledPhone: phone);
        },
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.pendingApproval,
        builder: (_, _) => const PendingApprovalPage(),
      ),

      // ── Búsqueda (fuera del shell — pantalla completa) ───────────────
      GoRoute(
        path: AppRoutes.search,
        builder: (_, _) => const SearchPage(),
      ),

      // ── Lista de productos por categoría ─────────────────────────────
      GoRoute(
        path: AppRoutes.productList,
        builder: (_, state) {
          final categoryId = state.uri.queryParameters['categoryId'];
          final name = state.uri.queryParameters['name'] != null
              ? Uri.decodeComponent(state.uri.queryParameters['name']!)
              : null;
          return ProductListPage(categoryId: categoryId, categoryName: name);
        },
      ),

      // ── Detalle de producto (fuera del shell — pantalla completa) ─────
      GoRoute(
        path: AppRoutes.productDetail,
        builder: (_, state) {
          final sku = state.pathParameters['id']!;
          return ProductDetailPage(sku: sku);
        },
      ),

      // ── Shell principal con NavigationBar ─────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => MainShell(shell: shell),
        branches: [
          // Branch 0 — Inicio
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),

          // Branch 1 — Promociones
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.promotions,
                builder: (_, _) => const PromotionsPage(),
              ),
            ],
          ),

          // Branch 2 — Carrito
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (_, _) => const CartPage(),
              ),
            ],
          ),

          // Branch 3 — Perfil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (_, _) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
