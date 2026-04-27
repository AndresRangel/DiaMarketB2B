/// Constantes para todas las claves de traducción de la app.
///
/// En lugar de escribir strings sueltos como 'catalog.add_to_cart' en los widgets,
/// se usa TrKeys.addToCart. Ventajas:
/// - El compilador detecta errores de tipeo
/// - Refactorizar una clave es seguro (Dart te dice dónde se usa)
/// - El IDE ofrece autocompletado
///
/// Uso: Text(TrKeys.addToCart.tr())
abstract class TrKeys {
  // ── Auth ──────────────────────────────────────────────────────────────────
  static const login = 'auth.login';
  static const username = 'auth.username';
  static const password = 'auth.password';
  static const rememberMe = 'auth.remember_me';
  static const forgotPassword = 'auth.forgot_password';
  static const register = 'auth.register';
  static const otpTitle = 'auth.otp_title';
  static const otpResend = 'auth.otp_resend';
  static const pendingApproval = 'auth.pending_approval';

  // ── Catálogo ──────────────────────────────────────────────────────────────
  static const categories = 'catalog.categories';
  static const products = 'catalog.products';
  static const search = 'catalog.search';
  static const addToCart = 'catalog.add_to_cart';
  static const outOfStock = 'catalog.out_of_stock';
  static const suggestedProducts = 'catalog.suggested';
  static const unitPrice = 'catalog.unit_price';

  // ── Carrito ───────────────────────────────────────────────────────────────
  static const cart = 'cart.title';
  static const subtotal = 'cart.subtotal';
  static const tax = 'cart.tax';
  static const discount = 'cart.discount';
  static const total = 'cart.total';
  static const emptyCart = 'cart.empty';
  static const minOrderAmount = 'cart.min_order';
  static const checkout = 'cart.checkout';
  static const clearCart = 'cart.clear';

  // ── Pedidos ───────────────────────────────────────────────────────────────
  static const orders = 'orders.title';
  static const orderNumber = 'orders.number';
  static const orderDate = 'orders.date';
  static const orderDetail = 'orders.detail';
  static const orderSuccess = 'orders.success';

  // ── Finanzas ──────────────────────────────────────────────────────────────
  static const accounts = 'finance.accounts';
  static const totalDebt = 'finance.total_debt';
  static const availableCredit = 'finance.available_credit';
  static const daysOverdue = 'finance.days_overdue';
  static const points = 'finance.points';

  // ── Promociones ───────────────────────────────────────────────────────────
  static const promotions = 'promotions.title';
  static const validUntil = 'promotions.valid_until';
  static const coupons = 'promotions.coupons';
  static const enterCoupon = 'promotions.enter_coupon';

  // ── Comunes ───────────────────────────────────────────────────────────────
  static const confirm = 'common.confirm';
  static const cancel = 'common.cancel';
  static const save = 'common.save';
  static const error = 'common.error';
  static const retry = 'common.retry';
  static const loading = 'common.loading';
  static const noData = 'common.no_data';
  static const success = 'common.success';
  static const connectionError = 'common.connection_error';
}
