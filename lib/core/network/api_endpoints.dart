/// Todas las rutas de la API en un solo lugar.
///
/// Cuando el backend confirme o cambie una URL, solo se toca aquí.
/// Los data sources referencian estas constantes — nunca escriben strings sueltos.
///
/// ⚠️  Los paths marcados con [PLACEHOLDER] son estimaciones REST.
///     Confirmar con el equipo backend antes de conectar en producción.
abstract class ApiEndpoints {
  // ── Autenticación (S01-S06) ───────────────────────────────────────────────

  /// S01 — Login con email y contraseña.
  /// Función Supabase RPC: public.login_user(p_email)
  /// ⚠️  [TEMP] Endpoint de desarrollo — solo valida email, ignora contraseña.
  static const login = '/rest/v1/rpc/login_user';

  /// S02 — Enviar OTP al celular
  static const otpSend = '/otp/send'; // [PLACEHOLDER]

  /// S02 — Validar código OTP ingresado
  static const otpValidate = '/otp/validate'; // [PLACEHOLDER]

  /// S03 — Recuperar contraseña (envía email/SMS)
  static const recoverPassword = '/auth/recover-password'; // [PLACEHOLDER]

  /// S04 — Pre-registro de nuevo cliente (queda pendiente de aprobación)
  static const preRegister = '/auth/register'; // [PLACEHOLDER]

  /// S05 — Registrar token FCM del dispositivo
  static const registerFcmToken = '/auth/fcm-token'; // [PLACEHOLDER]

  /// S06 — Renovar token de sesión
  static const refreshToken = '/auth/refresh-token'; // [PLACEHOLDER]

  // ── Catálogo (S07-S10) ────────────────────────────────────────────────────
  //
  // Backend: Supabase REST (PostgREST) — vistas en esquema public con
  // security_invoker=false para bypasear RLS del esquema b2b.
  // Tenant ID fijo: fb13332d-a434-4b90-bc00-081c00ce1bda (embebido en las vistas).
  //
  // Vistas disponibles:
  //   public.products_v   → 200 productos
  //   public.categories_v → 52 categorías (12 padres + 40 hijas)
  //   public.brands_v     → 817 marcas
  //
  // Parámetros comunes PostgREST:
  //   select=col1,col2     → columnas a devolver
  //   limit=N              → máximo de filas
  //   offset=N             → paginación
  //   order=col.asc/desc   → ordenamiento (nullsfirst/nullslast opcional)
  //   col=eq.<val>         → WHERE col = val
  //   col=ilike.*<val>*    → WHERE col ILIKE '%val%' (case-insensitive)
  //   col=is.null          → WHERE col IS NULL
  //   Prefer: count=exact  → total en header Content-Range (para paginación)

  /// S07 — Lista de productos.
  /// Columnas útiles: id, sku, name, base_price, image_url,
  ///                  brand_id, category_id, tax_rule_id, is_active
  ///
  /// ⚠️  base_price = 10000 en todos los registros (datos de prueba).
  ///     Actualizar a precios reales antes de producción.
  ///
  /// Tax rules: 1 = IVA 19%, 2 = IVA 5%, 3 = IVA 0% exento.
  static const products = '/rest/v1/products_v';

  /// S08 — Inventario actualizado por producto.
  static const inventory = '/inventario'; // [PLACEHOLDER]

  /// S09 — Búsqueda de productos por nombre (case-insensitive).
  /// Usar query param: `name=ilike.*TÉRMINO*`
  /// Mismo endpoint que [products] — la búsqueda es un filtro PostgREST.
  static const searchProducts = '/rest/v1/products_v';

  /// S10 — Productos sugeridos personalizados por usuario.
  static const suggestedProducts = '/productos/sugeridos'; // [PLACEHOLDER]

  /// S07 — Categorías del catálogo.
  /// Columnas: id, name, parent_id, sort_order, is_active
  /// Ordenamiento recomendado: parent_id.asc.nullsfirst,name.asc
  /// Filtro para solo padres: parent_id=is.null
  static const categories = '/rest/v1/categories_v';

  /// Marcas del catálogo (817 registros).
  /// Columnas: id, name, provider_id, is_active
  static const brands = '/rest/v1/brands_v';

  // ── Promociones y Cupones (S11-S13) ───────────────────────────────────────

  /// S11 — Promociones vigentes (descuentos, bonificaciones, combos)
  static const promotions = '/promociones'; // [PLACEHOLDER]

  /// S12 — Validar cupón. CRÍTICO: sin cache, siempre va a la red.
  static const validateCoupon = '/cupones/validar'; // [PLACEHOLDER]

  /// S13 — Cupones disponibles del usuario
  static const userCoupons = '/cupones/usuario'; // [PLACEHOLDER]

  // ── Sucursales y Ubicaciones (S14-S18) ────────────────────────────────────

  /// S14 — Sucursales asignadas al usuario
  static const branches = '/sucursales'; // [PLACEHOLDER]

  /// S15 — Datos completos del punto de venta (PDV)
  static const pointOfSale = '/pdv'; // [PLACEHOLDER]

  /// S16 — Ciudades y departamentos disponibles
  static const cities = '/ciudades'; // [PLACEHOLDER]

  /// S17 — Compañías asociadas al usuario (para selector multi-empresa)
  static const userCompanies = '/empresas/usuario'; // [PLACEHOLDER]

  /// S18 — Actualizar datos del cliente (nombre, dirección, contacto)
  static const updateClient = '/clientes/actualizar'; // [PLACEHOLDER]

  // ── Pedidos (S19-S22) ─────────────────────────────────────────────────────

  /// S19 — Crear pedido. CRÍTICO: sin cache, siempre validar contra servidor.
  static const createOrder = '/pedidos'; // [PLACEHOLDER]

  /// S20 — Disparar pedido confirmado al ERP
  static const triggerOrder = '/pedidos/disparar'; // [PLACEHOLDER]

  /// S21 — Historial de pedidos del cliente
  static const orderHistory = '/pedidos/historial'; // [PLACEHOLDER]

  /// S22 — Detalle de un pedido específico
  static const orderDetail = '/pedidos/detalle'; // [PLACEHOLDER]

  // ── Cartera y Finanzas (S23-S25) ──────────────────────────────────────────

  /// S23 — Cuentas por cobrar del cliente
  static const accounts = '/cartera/cuentas'; // [PLACEHOLDER]

  /// S24 — Condiciones de pago disponibles para la sucursal
  static const paymentConditions = '/cartera/condiciones-pago'; // [PLACEHOLDER]

  /// S25 — Puntos de fidelización del cliente
  static const loyaltyPoints = '/fidelizacion/puntos'; // [PLACEHOLDER]

  // ── Pasarela Ziro (S26-S31) ───────────────────────────────────────────────
  // ⚠️  Estos son endpoints de API EXTERNA (Ziro), no del backend propio.
  //     Ver sección 10 del CLAUDE.md — confirmar origen de credenciales antes de Fase 6.

  /// S26 — Autenticación con Ziro para obtener token de sesión
  static const ziroAuth = '/ziro/auth'; // [PLACEHOLDER - API externa]

  /// S27 — Consultar cupo de crédito disponible en Ziro
  static const ziroCheckCredit = '/ziro/cupo'; // [PLACEHOLDER - API externa]

  /// S28 — Validar datos del crédito y disparar envío de OTP
  static const ziroValidateCredit = '/ziro/validar'; // [PLACEHOLDER - API externa]

  /// S29 — Validar OTP de Ziro
  static const ziroValidateOtp = '/ziro/otp/validar'; // [PLACEHOLDER - API externa]

  /// S30 — Aplicar crédito Ziro al pedido. CRÍTICO.
  static const ziroApplyCredit = '/ziro/aplicar'; // [PLACEHOLDER - API externa]

  /// S31 — Cancelar crédito Ziro
  static const ziroCancelCredit = '/ziro/cancelar'; // [PLACEHOLDER - API externa]

  // ── Comunicación (S32-S36) ────────────────────────────────────────────────

  /// S32 — Bandeja de mensajes del cliente
  static const messages = '/comunicacion/mensajes'; // [PLACEHOLDER]

  /// S33 — Noticias / novedades del distribuidor
  static const news = '/comunicacion/noticias'; // [PLACEHOLDER]

  /// S34 — Envío de push notification (FCM directo desde backend)
  static const pushNotification = '/comunicacion/push'; // [PLACEHOLDER]

  /// S35 — Canales de soporte disponibles (WhatsApp, teléfono, email)
  static const supportChannels = '/comunicacion/soporte'; // [PLACEHOLDER]

  /// S36 — Mensaje de confirmación al finalizar un pedido
  static const orderConfirmationMessage = '/comunicacion/fin-orden'; // [PLACEHOLDER]

  // ── Recursos y Configuración (S37-S43) ────────────────────────────────────

  /// S37 — CDN de imágenes (base URL para construir URLs de productos)
  static const imagesCdn = '/recursos/imagenes'; // [PLACEHOLDER]

  /// S38 — Banners generales (home, categorías)
  static const banners = '/recursos/banners'; // [PLACEHOLDER]

  /// S39 — Relación de proveedores del catálogo
  static const suppliers = '/recursos/proveedores'; // [PLACEHOLDER]

  /// S40 — Tipos de negocio disponibles (para registro)
  static const businessTypes = '/recursos/tipos-negocio'; // [PLACEHOLDER]

  /// S41 — Configuración de grillas y vistas del catálogo
  static const viewConfig = '/recursos/config-vistas'; // [PLACEHOLDER]

  /// S42 — Términos y condiciones vigentes
  static const termsAndConditions = '/recursos/terminos'; // [PLACEHOLDER]

  /// S43 — Configuración de tema, branding, locale y feature flags.
  /// CRÍTICO al inicio de la app. Cache persistent 24h.
  /// Endpoint real: Supabase RPC función get_config.
  static const themeConfig = '/rest/v1/rpc/get_config';
}
