/// Constantes de todas las rutas de la app.
///
/// NUNCA escribir strings de rutas sueltos en los widgets.
/// Siempre usar estas constantes para que un cambio de ruta
/// se propague automáticamente a todos los lugares que la usan.
abstract class AppRoutes {
  // ── Auth ──────────────────────────────────────────────────────────────────
  static const splash = '/splash';
  static const login = '/login';
  static const otp = '/otp';
  static const register = '/register';
  static const pendingApproval = '/pending-approval';

  // ── Home / Catálogo ───────────────────────────────────────────────────────
  static const home = '/home';
  static const productList = '/products';
  static const productDetail = '/product/:id';
  static const search = '/search';

  // ── Carrito / Checkout ────────────────────────────────────────────────────
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';

  // ── Pedidos ───────────────────────────────────────────────────────────────
  static const orders = '/orders';
  static const orderDetail = '/order/:id';

  // ── Promociones / Cupones ─────────────────────────────────────────────────
  static const promotions = '/promotions';
  static const coupons = '/coupons';

  // ── Finanzas ──────────────────────────────────────────────────────────────
  static const accounts = '/accounts';
  static const points = '/points';

  // ── Comunicación ──────────────────────────────────────────────────────────
  static const messages = '/messages';
  static const news = '/news';
  static const support = '/support';

  // ── Perfil / Config ───────────────────────────────────────────────────────
  static const profile = '/profile';

  // ── Módulos opcionales ────────────────────────────────────────────────────
  static const ziroPayment = '/ziro-payment';

  // ── Rutas protegidas (requieren login) ────────────────────────────────────
  /// Lista de rutas que NO requieren estar logueado.
  /// Cualquier ruta fuera de esta lista es protegida.
  static const publicRoutes = [
    splash,
    login,
    otp,
    register,
    pendingApproval,
  ];
}
