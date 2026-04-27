# CLAUDE.md — Proyecto EntregasB2B (Dia Market B2B)

> Migración Android nativa (Java) → Flutter. App white-label B2B para clientes mayoristas.
> Versión del documento: 2.0 — Stack Riverpod + Clean Architecture
> Última actualización: 2026-04

---

## 1. CONTEXTO DEL PROYECTO

Estás trabajando en la migración de una app Android nativa llamada **EntregasB2B / Dia Market B2B** a **Flutter**. Es una plataforma de comercio electrónico B2B para clientes mayoristas (tiendas, minimarkets, negocios) que hacen pedidos a un distribuidor.

La app actual está en producción (v7.8). Esta migración debe replicar toda la funcionalidad existente con una arquitectura moderna, desacoplada y **white-label**: la misma app debe poder venderse a múltiples clientes cambiando solo configuración remota (colores, logo, moneda, idioma, feature flags).

**Desarrollador único:** sí. Decisiones pragmáticas permitidas siempre que no comprometan la arquitectura.

---

## 2. STACK TECNOLÓGICO

### Versiones objetivo
- **Flutter:** 3.27.x (estable)
- **Dart:** 3.6.x
- **Plataformas:** Android, iOS y **Web** (ciudadano de primera clase — ver sección 9-bis)

### Filosofía multi-plataforma
**Mobile + Web simultáneos.** Cada pantalla que se implementa debe verse bien en móvil Y en navegador web. No se posterga la calidad visual web para "después". A nivel de librerías, si algo no funciona en web se documenta y se busca alternativa, pero visualmente toda pantalla nueva debe validarse en ambas plataformas antes de considerarse terminada.

### Paquetes principales
| Categoría | Paquete | Web-friendly | Notas |
|---|---|---|---|
| **State management** | `flutter_riverpod` + `riverpod_annotation` | ✅ Sí | Con generación de código `@riverpod` |
| **Generación de código** | `riverpod_generator`, `build_runner`, `custom_lint`, `riverpod_lint` | ✅ Sí | Dev dependencies |
| **Navegación** | `go_router` | ✅ Sí (URLs reales en web) | Con guards para auth |
| **HTTP** | `dio` | ✅ Sí | Con interceptores. **Web requiere CORS configurado en backend** |
| **Modelos inmutables** | `freezed` + `freezed_annotation` | ✅ Sí | Con `json_serializable` para DTOs |
| **JSON** | `json_serializable` + `json_annotation` | ✅ Sí | Solo en DTOs, nunca en Entities |
| **Funcional / Errores** | `fpdart` | ✅ Sí | `Either<Failure, T>` y `Option<T>`. NO usar `dartz` |
| **i18n** | `easy_localization` | ✅ Sí | Con TrKeys constantes |
| **Cache local** | `hive` + `hive_flutter` | ⚠️ Parcial | Funciona pero usa IndexedDB en web (más lento, navegador puede limpiar) |
| **Storage seguro** | `flutter_secure_storage` | ⚠️ Parcial | **En web NO es seguro** (usa localStorage). Acceder vía abstracción `SecureStorageService` |
| **Imágenes remotas** | `cached_network_image` | ✅ Sí | |
| **Push notifications** | `firebase_messaging` + `flutter_local_notifications` | ⚠️ Parcial | Requiere Service Worker + VAPID en web. Acceder vía abstracción `NotificationService` |
| **Analytics / Crash** | `firebase_analytics` + `firebase_crashlytics` | ⚠️ Parcial | Crashlytics solo móvil. Analytics funciona en web |
| **Geolocalización** | `geolocator` | ⚠️ Parcial | Web requiere HTTPS y permiso del navegador. Acceder vía abstracción `LocationService` |
| **Permisos** | `permission_handler` | ⚠️ Parcial | La mayoría de permisos no aplican en web. Acceder vía abstracción `PermissionsService` |
| **Testing** | `flutter_test` + `mocktail` | ✅ Sí | NO usar `mockito` |
| **Logger** | `logger` | ✅ Sí | Para logs estructurados |

### Regla de compatibilidad web

**Antes de añadir cualquier paquete nuevo al `pubspec.yaml`**, validar su compatibilidad con web usando context7. Si el paquete:
- ✅ Funciona perfecto en web → añadir directamente
- ⚠️ Funciona parcialmente → crear abstracción en `core/services/` con dos implementaciones (móvil y web)
- ❌ NO funciona en web → buscar alternativa o documentar limitación en sección 20 (decisiones pendientes)

### Paquetes EXPLÍCITAMENTE NO usar
- ❌ `get` / GetX → reemplazado por Riverpod + go_router + easy_localization
- ❌ `provider` → usar Riverpod
- ❌ `dartz` → usar `fpdart`
- ❌ `mockito` → usar `mocktail`
- ❌ `get_storage` → usar Hive con un box dedicado
- ❌ `drift` / `sqflite` → usar Hive (a menos que un caso real de queries relacionales lo justifique, y se discuta antes)

---

## 3. ARQUITECTURA: Clean Architecture + Repository Pattern + Riverpod

### Regla fundamental
**El código de negocio NUNCA debe conocer de dónde vienen los datos.** Hoy es API REST, mañana puede ser GraphQL, Firebase, o cualquier otra cosa.

### Estructura de capas

```
Presentación (UI) → Widgets, Pages, Notifiers (Riverpod)
       ↓ (consume)
Dominio (Negocio) → Use Cases, Entities, Repository Interfaces (abstractas)
       ↓ (implementa)
Datos (Data)      → Repository Implementations, Data Sources
                     ├── Remote Data Source (API REST via Dio)
                     ├── Local Data Source (Cache: Hive)
                     └── Mappers (DTO ↔ Entity)
```

### Reglas estrictas por capa

**Dominio (núcleo, NO importa nada externo):**
- `Entities`: Modelos puros de negocio (Product, Order, User, etc.). Inmutables (`freezed`). **Sin** anotaciones de serialización JSON. **Sin** dependencias externas.
- `Repository Interfaces`: Contratos abstractos. Ej: `abstract class ProductRepository { Future<Either<Failure, List<Product>>> getProducts(); }`
- `Use Cases`: Una clase por caso de uso. Recibe repositorio por constructor. Método único `call()`. Ej: `CreateOrderUseCase`, `ValidateCouponUseCase`.

**Datos (implementa contratos del dominio):**
- `Repository Implementations`: Implementan la interfaz del dominio. Deciden si consultar red, memoria o disco según `CachePolicy` del tipo de dato.
- `Remote Data Source`: Llamadas HTTP con Dio. Retornan DTOs (modelos con `fromJson`/`toJson`).
- `Local Data Source`: Lectura/escritura en Hive y memoria.
- `DTOs/Models`: Modelos con serialización JSON (`freezed` + `json_serializable`). Tienen método `toEntity()` para convertir a Entity de dominio.

**Presentación:**
- `Notifiers`: Clases con `@riverpod` que extienden `_$NombreNotifier`. Manejan estado con `AsyncValue<T>`. Reciben use cases vía `ref.watch(useCaseProvider)`.
- `Pages`: Widgets de pantalla completa. Extienden `ConsumerWidget` o `ConsumerStatefulWidget`.
- `Widgets`: Componentes reutilizables del feature.
- **NO existen Bindings** (eran de GetX). La inyección se hace declarativamente con providers.

---

## 4. POLÍTICA DE CACHE — DATOS FRESCOS VS FLUIDEZ

> ⚠️ **Esta sección es CRÍTICA.** Lee y respeta estrictamente.

### Filosofía
**Durante la sesión:** velocidad máxima usando datos cacheados en memoria.
**Al reabrir la app:** datos críticos se descargan limpios.
**Al confirmar transacciones:** siempre se valida contra el servidor.

El usuario tiene un mental model simple: *"si quiero datos actualizados, cierro y reabro la app"*.

### Dos niveles de cache

**Nivel 1 — Memory Cache (RAM):**
- Vive en providers de Riverpod
- Se borra cuando la app se mata
- Velocidad: instantánea
- Para datos críticos session-scoped

**Nivel 2 — Persistent Cache (Hive):**
- Vive en disco entre sesiones
- Sobrevive cierres de la app
- Velocidad: muy rápida (ms)
- Para datos estables que pueden persistir

### Estructura del CachePolicy

```dart
// lib/core/cache/cache_policy.dart
enum CacheLifetime {
  session,      // Solo durante la sesión actual, muere al cerrar la app
  persistent,   // Vive entre sesiones (con TTL opcional)
  none,         // Sin cache, siempre va a la red
}

enum CacheLayer {
  memory,       // Solo RAM
  disk,         // Solo Hive
  both,         // RAM con respaldo en Hive
}

@freezed
class CachePolicy with _$CachePolicy {
  const factory CachePolicy({
    required CacheLifetime lifetime,
    required CacheLayer layer,
    Duration? customTtl,
  }) = _CachePolicy;
}
```

### Tabla de políticas (configuración central)

> ⚠️ **Para cambiar el comportamiento del cache, modificar SOLO `cache_policies.dart`. NUNCA tocar los repositorios.**

```dart
// lib/core/cache/cache_policies.dart
class CachePoliciesConfig {
  static const Map<String, CachePolicy> defaults = {
    // ====== 🔴 CRÍTICOS — Solo durante la sesión ======
    'catalog': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'prices': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'inventory': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'promotions': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),
    'suggestedProducts': CachePolicy(
      lifetime: CacheLifetime.session,
      layer: CacheLayer.memory,
    ),

    // ====== 🟡 ESTABLES — Persistentes con TTL ======
    'branches': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(days: 7),
    ),
    'paymentConditions': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(days: 7),
    ),
    'cities': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),

    // ====== 🟢 CONFIGURACIÓN — Persistentes muy estables ======
    'branding': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(hours: 24),
    ),
    'termsAndConditions': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),
    'businessTypes': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.disk,
      customTtl: Duration(days: 30),
    ),

    // ====== 🟢 COMUNICACIÓN ======
    'messages': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(minutes: 30),
    ),
    'news': CachePolicy(
      lifetime: CacheLifetime.persistent,
      layer: CacheLayer.both,
      customTtl: Duration(hours: 1),
    ),

    // ====== ❌ NUNCA EN CACHE ======
    'orderCreation': CachePolicy(lifetime: CacheLifetime.none, layer: CacheLayer.memory),
    'couponValidation': CachePolicy(lifetime: CacheLifetime.none, layer: CacheLayer.memory),
    'paymentOperations': CachePolicy(lifetime: CacheLifetime.none, layer: CacheLayer.memory),
    'orderHistory': CachePolicy(lifetime: CacheLifetime.none, layer: CacheLayer.memory),
  };
}
```

### Override remoto desde S43 (preparación futura)

El servicio S43 (config tema/branding) puede opcionalmente devolver una sección `cachePolicies` que sobrescribe los defaults locales. Si el backend la envía, se aplica; si no, se usan los defaults.

```json
{
  "branding": { ... },
  "theme": { ... },
  "cachePolicies": {
    "catalog": { "lifetime": "persistent", "ttlMinutes": 120 },
    "prices": { "lifetime": "session" }
  }
}
```

Esto permite que el cliente B2B en producción ajuste el comportamiento del cache **sin publicar nueva versión de la app**.

### Operaciones críticas — Sin excepción

Las operaciones que confirman dinero o stock **siempre** se ejecutan contra el servidor. Si el servidor responde con datos diferentes a los cacheados (ej. precios cambiados), la app **debe mostrar al usuario las diferencias antes de confirmar**:

```
"Algunos precios fueron actualizados.

 Producto X: $1.500 → $1.700
 Producto Y: $2.000 → $1.800

 Nuevo total: $48.500

 [Cancelar]    [Confirmar con nuevos precios]"
```

Operaciones críticas:
- S19 — Crear pedido
- S12 — Validar cupón
- S30 — Aplicar pago Ziro
- Cualquier acción que dispare cobro/reserva en el ERP

---

## 5. SISTEMA WHITE-LABEL (TEMA DINÁMICO DESDE BACKEND)

### Concepto
La app **NO** tiene colores, logos ni textos de marca hardcodeados. Todo viene del servicio S43 al iniciar la app.

### Servicio S43 — Estructura esperada

```json
{
  "branding": {
    "appName": "Dia Market B2B",
    "logoUrl": "https://cdn.example.com/empresa1/logo.png",
    "logoLightUrl": "https://cdn.example.com/empresa1/logo_light.png",
    "faviconUrl": "https://cdn.example.com/empresa1/favicon.png",
    "splashLogoUrl": "https://cdn.example.com/empresa1/splash_logo.png"
  },
  "theme": {
    "primaryColor": "#1E3A5F",
    "primaryDarkColor": "#0F2440",
    "primaryLightColor": "#2E5A8F",
    "accentColor": "#FF6B35",
    "secondaryColor": "#4CAF50",
    "errorColor": "#E53935",
    "warningColor": "#FFA726",
    "successColor": "#66BB6A",
    "backgroundColor": "#F5F7FA",
    "surfaceColor": "#FFFFFF",
    "textPrimaryColor": "#1A1A2E",
    "textSecondaryColor": "#666666",
    "buttonTextColor": "#FFFFFF",
    "fontFamily": "Roboto"
  },
  "locale": {
    "defaultLocale": "es_CO",
    "supportedLocales": ["es_CO", "es_MX", "en_US", "pt_BR"],
    "defaultCurrency": "COP",
    "currencySymbol": "$",
    "currencyDecimals": 0,
    "thousandSeparator": ".",
    "decimalSeparator": ","
  },
  "features": {
    "enableZiroPayment": true,
    "enableLoyaltyPoints": true,
    "enableCoupons": true,
    "enableNews": true,
    "enableSmsOtp": true,
    "enablePreRegistration": true
  },
  "cachePolicies": {
    "// optional": "ver sección 4 — Override remoto"
  }
}
```

### ThemeNotifier (Riverpod)

```dart
// lib/core/theme/theme_notifier.dart
@Riverpod(keepAlive: true)
class ThemeNotifier extends _$ThemeNotifier {
  @override
  AppConfig build() => AppConfig.fallback();

  Future<void> loadConfig(String empresaId) async {
    final repo = ref.read(remoteConfigRepositoryProvider);
    final result = await repo.getThemeConfig(empresaId);

    result.fold(
      (failure) async {
        // Intentar cargar desde cache
        final cached = await repo.getCachedConfig();
        if (cached != null) state = cached;
        // Si no hay cache, queda el fallback
      },
      (config) async {
        state = config;
        await repo.cacheConfig(config);
      },
    );
  }

  ThemeData get materialTheme => ThemeData(
        primaryColor: state.theme.primaryColor,
        colorScheme: ColorScheme.light(
          primary: state.theme.primaryColor,
          secondary: state.theme.accentColor,
          error: state.theme.errorColor,
          surface: state.theme.surfaceColor,
        ),
        fontFamily: state.theme.fontFamily,
      );
}
```

### Uso en widgets

```dart
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(themeNotifierProvider);

    return Container(
      color: config.theme.primaryColor,
      child: CachedNetworkImage(imageUrl: config.branding.logoUrl),
    );
  }
}

// Verificar features:
final features = ref.watch(themeNotifierProvider.select((c) => c.features));
if (features.enableZiroPayment) {
  // mostrar opción Ziro
}
```

### Reglas estrictas del white-label
1. **NUNCA** hardcodear colores hex en widgets. Siempre `themeNotifierProvider` o `Theme.of(context)`.
2. **NUNCA** poner logos como assets locales (excepto el splash genérico inicial mientras carga la config).
3. **NUNCA** hardcodear el nombre de la app en textos. Usar `branding.appName`.
4. **Feature flags** controlan qué módulos se renderizan. Verificar antes de mostrar.
5. Mantener un **fallback hardcodeado** con colores neutros por si el backend no responde.

---

## 6. INTERNACIONALIZACIÓN (i18n) Y MULTIMONEDA

### Setup easy_localization

```yaml
# pubspec.yaml
dependencies:
  easy_localization: ^3.0.7

flutter:
  assets:
    - assets/translations/
```

### Estructura de archivos

```
assets/translations/
├── es-CO.json
├── es-MX.json
├── en-US.json
└── pt-BR.json

lib/core/i18n/
├── translation_keys.dart    # Constantes con las keys
└── locale_setup.dart        # Configuración inicial
```

### Translation Keys (constantes)

```dart
// lib/core/i18n/translation_keys.dart
abstract class TrKeys {
  // Auth
  static const login = 'auth.login';
  static const username = 'auth.username';
  static const password = 'auth.password';
  static const rememberMe = 'auth.remember_me';
  static const forgotPassword = 'auth.forgot_password';
  static const register = 'auth.register';
  static const otpTitle = 'auth.otp_title';
  static const otpResend = 'auth.otp_resend';
  static const pendingApproval = 'auth.pending_approval';

  // Catalog
  static const categories = 'catalog.categories';
  static const products = 'catalog.products';
  static const search = 'catalog.search';
  static const addToCart = 'catalog.add_to_cart';
  static const outOfStock = 'catalog.out_of_stock';
  static const suggestedProducts = 'catalog.suggested';
  static const unitPrice = 'catalog.unit_price';

  // Cart
  static const cart = 'cart.title';
  static const subtotal = 'cart.subtotal';
  static const tax = 'cart.tax';
  static const discount = 'cart.discount';
  static const total = 'cart.total';
  static const emptyCart = 'cart.empty';
  static const minOrderAmount = 'cart.min_order';
  static const checkout = 'cart.checkout';
  static const clearCart = 'cart.clear';

  // Orders
  static const orders = 'orders.title';
  static const orderNumber = 'orders.number';
  static const orderDate = 'orders.date';
  static const orderDetail = 'orders.detail';
  static const orderSuccess = 'orders.success';

  // Finance
  static const accounts = 'finance.accounts';
  static const totalDebt = 'finance.total_debt';
  static const availableCredit = 'finance.available_credit';
  static const daysOverdue = 'finance.days_overdue';
  static const points = 'finance.points';

  // Promotions
  static const promotions = 'promotions.title';
  static const validUntil = 'promotions.valid_until';
  static const coupons = 'promotions.coupons';
  static const enterCoupon = 'promotions.enter_coupon';

  // Common
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
```

### Uso en widgets

```dart
// MAL
Text('Agregar al carrito')

// BIEN
Text(TrKeys.addToCart.tr())
```

### Regla de i18n
**TODO texto visible en la UI debe usar `.tr()` con un key de TrKeys.**

**Excepciones permitidas:**
- Logs de debug y errores técnicos
- Identificadores técnicos / claves de assets
- Datos provenientes del backend (nombres de productos, descripciones, etc.)

### Multimoneda — CurrencyFormatter

```dart
// lib/core/utils/currency_formatter.dart
class CurrencyFormatter {
  static String format(double amount, LocaleConfig config) {
    // Formatear según:
    // - config.currencySymbol
    // - config.thousandSeparator
    // - config.decimalSeparator
    // - config.currencyDecimals
  }
}

// Provider helper para uso fácil en widgets:
@riverpod
String formatCurrency(FormatCurrencyRef ref, double amount) {
  final config = ref.watch(themeNotifierProvider.select((c) => c.locale));
  return CurrencyFormatter.format(amount, config);
}
```

**Regla:** NUNCA formatear moneda manualmente. Siempre usar `CurrencyFormatter.format()` o el provider helper.

---

## 7. ESTRUCTURA DE CARPETAS

```
lib/
├── core/
│   ├── config/               # AppConfig (env, ambientes), constantes
│   ├── error/                # Failure classes, excepciones
│   ├── network/              # DioClient, interceptores, ApiResponse
│   ├── cache/                # CachePolicy, CachePoliciesConfig, CacheManager
│   ├── router/               # GoRouter config, AppRoutes (constantes), guards
│   ├── theme/                # ThemeNotifier, AppThemeData, BrandingData, FeatureFlags, fallback
│   ├── i18n/                 # TrKeys, locale_setup
│   ├── providers/            # Providers globales (DioClient, HiveBoxes, etc.)
│   ├── responsive/           # Breakpoints, ResponsiveExtensions (web-ready)
│   ├── services/             # Abstracciones de plataforma (secure_storage, notifications, location, permissions)
│   └── utils/                # CurrencyFormatter, DateFormatter, Validators, Logger
│
├── features/
│   ├── auth/
│   │   ├── domain/
│   │   │   ├── entities/         # UserEntity, etc.
│   │   │   ├── repositories/     # AuthRepository (abstract)
│   │   │   └── usecases/         # LoginUseCase, ValidateOtpUseCase, etc.
│   │   ├── data/
│   │   │   ├── datasources/      # AuthRemoteDataSource
│   │   │   ├── dtos/             # UserDTO, LoginResponseDTO
│   │   │   ├── mappers/          # toEntity extensions
│   │   │   └── repositories/     # AuthRepositoryImpl
│   │   └── presentation/
│   │       ├── notifiers/        # AuthNotifier, LoginFormNotifier
│   │       ├── pages/            # LoginPage, OtpPage, RegisterPage, PendingApprovalPage
│   │       └── widgets/          # OtpInput, CompanySelectorDialog
│   │
│   ├── catalog/
│   │   ├── domain/
│   │   ├── data/
│   │   └── presentation/
│   │       ├── notifiers/        # CatalogNotifier, ProductDetailNotifier, SearchNotifier
│   │       ├── pages/            # HomePage, ProductListPage, ProductDetailPage, SearchPage
│   │       └── widgets/          # ProductCard, CategoryGrid, BannerCarousel
│   │
│   ├── cart/
│   ├── checkout/
│   ├── promotions/
│   ├── coupons/
│   ├── orders/
│   ├── finance/
│   ├── ziro_payment/
│   ├── communication/
│   ├── profile/
│   └── notifications/
│
├── shared/
│   ├── widgets/              # AppButton, AppTextField, AppCard, LoadingIndicator, EmptyState, AppErrorWidget
│   ├── extensions/           # StringExt, DateTimeExt, ContextExt
│   └── constants/            # AssetPaths (solo para fallback splash)
│
├── main.dart                 # Punto de entrada compartido
├── main_qa.dart              # Entry point flavor QA
└── main_prod.dart            # Entry point flavor PROD
```

### Estructura de tests

```
test/
└── features/
    ├── auth/
    │   └── domain/
    │       └── usecases/
    │           └── login_usecase_test.dart
    ├── catalog/
    │   └── domain/
    │       └── usecases/
    └── ...
```

Los tests de Use Cases son **obligatorios**. Tests de widgets, repositorios o integración son opcionales.

---

## 8. PATRONES RIVERPOD

### Provider para repositorios

```dart
// lib/features/catalog/data/repositories/catalog_repository_impl.dart
@riverpod
CatalogRepository catalogRepository(CatalogRepositoryRef ref) {
  return CatalogRepositoryImpl(
    remoteDataSource: ref.watch(catalogRemoteDataSourceProvider),
    localDataSource: ref.watch(catalogLocalDataSourceProvider),
    cachePolicy: CachePoliciesConfig.defaults['catalog']!,
  );
}
```

### Provider para use cases

```dart
@riverpod
GetCatalogUseCase getCatalogUseCase(GetCatalogUseCaseRef ref) {
  return GetCatalogUseCase(ref.watch(catalogRepositoryProvider));
}
```

### Notifier de feature

```dart
// lib/features/catalog/presentation/notifiers/catalog_notifier.dart
@riverpod
class CatalogNotifier extends _$CatalogNotifier {
  @override
  Future<List<Product>> build() async {
    final useCase = ref.watch(getCatalogUseCaseProvider);
    final result = await useCase();

    return result.fold(
      (failure) => throw failure,
      (products) => products,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = ref.read(getCatalogUseCaseProvider);
      final result = await useCase();
      return result.fold(
        (failure) => throw failure,
        (products) => products,
      );
    });
  }
}
```

### Uso en la página

```dart
class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogNotifierProvider);

    return Scaffold(
      body: catalogState.when(
        loading: () => const LoadingIndicator(),
        error: (e, _) => AppErrorWidget(
          message: e.toString(),
          onRetry: () => ref.read(catalogNotifierProvider.notifier).refresh(),
        ),
        data: (products) => RefreshIndicator(
          onRefresh: () => ref.read(catalogNotifierProvider.notifier).refresh(),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, i) => ProductCard(product: products[i]),
          ),
        ),
      ),
    );
  }
}
```

### Providers globales (keepAlive)

Algunos providers viven durante toda la app:

```dart
@Riverpod(keepAlive: true)
ThemeNotifier ...

@Riverpod(keepAlive: true)
AuthNotifier ...

@Riverpod(keepAlive: true)
CartNotifier ...

@Riverpod(keepAlive: true)
NotificationNotifier ...
```

### Separación View / ViewModel (MVVM estricto)

> ⚠️ **REGLA FUNDAMENTAL DEL PROYECTO.** Las pages (Views) son tontas. Los Notifiers (ViewModels) son inteligentes. Esta separación NO es opcional.

#### Distribución de responsabilidades

| Capa | Archivo | Responsabilidad |
|---|---|---|
| **View** | `presentation/pages/*.dart` y `widgets/*.dart` | Mostrar UI, capturar input, delegar al Notifier, observar estado |
| **ViewModel** | `presentation/notifiers/*.dart` | Validación de formularios, gestión de estado, orquestación de Use Cases, transformaciones para mostrar |
| **Use Case** | `domain/usecases/*.dart` | Reglas de negocio puras, sin UI, sin red directa |

#### Lo que la View SÍ puede hacer

- Renderizar widgets según el estado actual
- Capturar input del usuario (TextFields, botones, gestos)
- Llamar a métodos del Notifier vía `ref.read(notifierProvider.notifier).accion()`
- Observar el estado con `ref.watch(notifierProvider)`
- Reaccionar a cambios de estado con `ref.listen` para side effects (navegar, snackbar, diálogo)
- Manejar `TextEditingController`, `FocusNode`, `AnimationController` (son detalles de UI atados al ciclo de vida del widget)
- Aplicar formato visual usando helpers (`CurrencyFormatter`, `DateFormatter`)

#### Lo que la View NO puede hacer

- ❌ Validar datos del usuario (eso lo hace el Notifier)
- ❌ Llamar a Use Cases directamente (debe pasar por el Notifier)
- ❌ Importar repositorios o data sources
- ❌ Importar `dio` o cualquier cliente HTTP
- ❌ Llamar a `flutter_secure_storage` o Hive directamente
- ❌ Tener `bool _isLoading` con `setState` para estado de negocio (eso va en el Notifier)
- ❌ Decidir qué hacer ante un error de negocio (el Notifier decide, la View muestra)
- ❌ Navegar como respuesta a una operación de negocio sin pasar por `ref.listen`

#### Lo que el Notifier SÍ puede hacer

- Mantener el estado de la pantalla (loading, datos, error, éxito)
- Validar input antes de llamar al Use Case
- Llamar a Use Cases vía `ref.read(useCaseProvider)`
- Transformar datos del dominio en datos listos para mostrar
- Exponer métodos públicos que la View puede llamar (`login()`, `refresh()`, `addToCart()`)
- Acceder a otros providers vía `ref` (otros Notifiers, repositorios, configuración)

#### Lo que el Notifier NO puede hacer

- ❌ Importar nada de `package:flutter/material.dart` o `widgets.dart`
- ❌ Recibir o usar `BuildContext`
- ❌ Manejar `TextEditingController`, `FocusNode`, ni nada de UI
- ❌ Mostrar snackbars, diálogos o navegar (eso es responsabilidad de la View con `ref.listen`)
- ❌ Importar `dio` directamente (usa Use Cases que usan repositorios)

#### Estado complejo con sealed classes

Cuando el estado tiene más de 2 variantes (loading, success, error, etc.), usar **sealed class con freezed** en lugar de variables sueltas. Esto fuerza al compilador a manejar todos los casos en la View.

```dart
// lib/features/auth/presentation/notifiers/login_state.dart
@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.initial() = LoginStateInitial;
  const factory LoginState.loading() = LoginStateLoading;
  const factory LoginState.success(User user) = LoginStateSuccess;
  const factory LoginState.error(String message) = LoginStateError;
}
```

#### Ejemplo correcto — Notifier (ViewModel)

```dart
// lib/features/auth/presentation/notifiers/login_notifier.dart
// NOTA: este archivo NO importa material.dart ni widgets.dart.
// Es Dart puro con Riverpod.

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  LoginState build() => const LoginState.initial();

  Future<void> login(String email, String password) async {
    // Validación en el ViewModel, NO en la vista
    if (email.isEmpty) {
      state = const LoginState.error('Email requerido');
      return;
    }
    if (password.length < 4) {
      state = const LoginState.error('Contraseña muy corta');
      return;
    }

    state = const LoginState.loading();

    final useCase = ref.read(loginUseCaseProvider);
    final result = await useCase(email: email, password: password);

    state = result.fold(
      (failure) => LoginState.error(failure.message),
      (user) => LoginState.success(user),
    );
  }

  void clearError() {
    if (state is LoginStateError) {
      state = const LoginState.initial();
    }
  }
}
```

#### Ejemplo correcto — Page (View)

```dart
// lib/features/auth/presentation/pages/login_page.dart
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Los TextEditingController son detalle de UI, atados al ciclo de vida del widget.
  // Por eso viven en la View, no en el Notifier.
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch reconstruye este widget cuando el estado del Notifier cambia.
    final loginState = ref.watch(loginNotifierProvider);

    // ref.listen reacciona a cambios SIN reconstruir el widget.
    // Es donde van los side effects: navegar, snackbar, diálogos.
    ref.listen<LoginState>(loginNotifierProvider, (previous, next) {
      switch (next) {
        case LoginStateSuccess():
          context.go(AppRoutes.home);
        case LoginStateError(:final message):
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        case _:
          break;
      }
    });

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: TrKeys.username.tr()),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: TrKeys.password.tr()),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              // La View solo captura el evento y delega al Notifier.
              // Aquí NO se valida ni se llama a APIs.
              onPressed: switch (loginState) {
                LoginStateLoading() => null,
                _ => () {
                    ref.read(loginNotifierProvider.notifier).login(
                          _emailController.text,
                          _passwordController.text,
                        );
                  },
              },
              child: switch (loginState) {
                LoginStateLoading() => const CircularProgressIndicator(),
                _ => Text(TrKeys.login.tr()),
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

#### Pragmatismo: Notifier obligatorio cuando hay lógica

- **Pantalla con lógica de negocio** (login, catálogo, checkout, etc.) → **OBLIGATORIO** tener Notifier
- **Pantalla puramente informativa** (acerca de, T&C, splash sin lógica) → puede ser `ConsumerWidget` directo sin Notifier

La regla simple: **si la pantalla tiene `if`, validaciones, llamadas a use cases, o estado mutable que importa al negocio → Notifier obligatorio**.

---

## 9. NAVEGACIÓN CON GO_ROUTER

### Constantes de rutas

```dart
// lib/core/router/app_routes.dart
abstract class AppRoutes {
  static const splash = '/splash';
  static const login = '/login';
  static const otp = '/otp';
  static const register = '/register';
  static const pendingApproval = '/pending-approval';
  static const home = '/home';
  static const productList = '/products';
  static const productDetail = '/product/:id';
  static const search = '/search';
  static const cart = '/cart';
  static const checkout = '/checkout';
  static const orderSuccess = '/order-success';
  static const orders = '/orders';
  static const orderDetail = '/order/:id';
  static const promotions = '/promotions';
  static const coupons = '/coupons';
  static const accounts = '/accounts';
  static const points = '/points';
  static const messages = '/messages';
  static const news = '/news';
  static const support = '/support';
  static const profile = '/profile';
  static const ziroPayment = '/ziro-payment';
}
```

### Router config con guard de auth

```dart
// lib/core/router/app_router.dart
@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final auth = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    redirect: (context, state) {
      final isLoggedIn = auth.isLoggedIn;
      final isAuthRoute = [
        AppRoutes.login,
        AppRoutes.otp,
        AppRoutes.register,
        AppRoutes.pendingApproval,
      ].contains(state.matchedLocation);

      if (!isLoggedIn && !isAuthRoute && state.matchedLocation != AppRoutes.splash) {
        return AppRoutes.login;
      }
      if (isLoggedIn && isAuthRoute) {
        return AppRoutes.home;
      }
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashPage()),
      GoRoute(path: AppRoutes.login, builder: (_, __) => const LoginPage()),
      // ... resto
    ],
  );
}
```

---

## 9-bis. MULTI-PLATAFORMA Y RESPONSIVE

> Filosofía: **Mobile + Web simultáneos.** Toda pantalla implementada debe verse bien en móvil Y en navegador web. No se posterga la calidad visual web. A nivel de librerías con limitaciones en web, se documenta y se busca alternativa; pero **visualmente** cada pantalla se valida en ambas plataformas antes de considerarla terminada.

### Reglas operativas

1. **Toda pantalla nueva se valida en móvil Y en chrome** antes de marcarla como completada.
2. **Usar siempre los dos getters de ancho máximo** según el tipo de pantalla (ver tabla abajo).
3. **Shell de navegación**: en desktop usar `NavigationRail` (lateral), en móvil `NavigationBar` (inferior). Ya implementado en `MainShell`.
4. **Si una librería no funciona en web**, documentar en sección 20 y buscar alternativa o crear abstracción. No bloquea el desarrollo pero sí debe resolverse antes de entregar esa feature.
5. **Las abstracciones de plataforma** (`core/services/`) ya están creadas desde Fase 0. Usarlas siempre.

### Breakpoints estándar

```dart
// lib/core/responsive/breakpoints.dart
abstract class Breakpoints {
  /// < 600px = móvil
  static const double mobile = 600;

  /// 600-900px = tablet
  static const double tablet = 900;

  /// > 900px = desktop / web
  static const double desktop = 1200;
}
```

### Getters responsive (obligatorios)

```dart
// lib/core/responsive/responsive_extensions.dart
extension ResponsiveContext on BuildContext {
  bool get isMobile => MediaQuery.sizeOf(this).width < Breakpoints.mobile;
  bool get isTablet => MediaQuery.sizeOf(this).width >= Breakpoints.mobile &&
      MediaQuery.sizeOf(this).width < Breakpoints.tablet;
  bool get isDesktop => MediaQuery.sizeOf(this).width >= Breakpoints.tablet;

  /// Para formularios, login, perfil, OTP, T&C — centra a 600px en desktop
  double get contentMaxWidth => isDesktop ? 600 : double.infinity;

  /// Para catálogo, listas, home — limita a 1400px en desktop
  double get catalogMaxWidth => isDesktop ? 1400 : double.infinity;
}
```

### Tabla: qué getter usar por tipo de pantalla

| Tipo de pantalla | Getter | Resultado en desktop |
|---|---|---|
| Login, registro, OTP, perfil, T&C | `contentMaxWidth` | 600px centrado |
| Home, catálogo, listas, detalle | `catalogMaxWidth` | 1400px centrado |
| Checkout, resumen de pedido | `contentMaxWidth` | 600px centrado |
| Carrito | `catalogMaxWidth` | 1400px centrado |

### Patrón estándar — aplicar en TODA pantalla

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.contentMaxWidth), // o catalogMaxWidth
        child: ...,
      ),
    ),
  );
}
```

En móvil (< 900px) ambos getters retornan `double.infinity` — no hay diferencia visual con el comportamiento actual.

### Shell de navegación (ya implementado)

```
Móvil  (< 900px): NavigationBar inferior  ← comportamiento clásico móvil
Desktop (≥ 900px): NavigationRail lateral  ← estándar web/desktop
```

Ambos modos usan el mismo `_onDestinationSelected` — sin duplicar lógica.

### Cuándo crear archivos `*_mobile.dart` / `*_web.dart`

**Por defecto: NO se crean.** Un solo archivo con `context.isDesktop` es suficiente para el 90% de los casos.

Crear versiones separadas **solo cuando**:
- El layout es fundamentalmente diferente (sidebar vs pantalla completa)
- El archivo supera 500 líneas con muchos `if isDesktop`

### Abstracciones de plataforma (ya en `core/services/`)

Los siguientes servicios tienen implementación móvil y web separada:
- `SecureStorageService` — `flutter_secure_storage` (móvil) / `localStorage` (web)
- `NotificationService` — FCM (móvil) / Web Notifications API (web)
- `LocationService` — `geolocator` (móvil) / Geolocation API (web)
- `PermissionsService` — `permission_handler` (móvil) / no-op (web)

**Regla:** NUNCA importar estas librerías directamente. Siempre vía el provider de abstracción.

### Checklist de calidad visual — por pantalla

Antes de marcar una pantalla como ✅ en PROGRESO.md:
- [ ] ¿Contenido centrado con `ConstrainedBox` en desktop?
- [ ] ¿No hay elementos estirados ridículamente en pantallas anchas?
- [ ] ¿La navegación funciona en chrome?
- [ ] ¿Las imágenes cargan?
- [ ] ¿Los botones responden al click (no solo al tap)?

---

## 10. SERVICIOS BACKEND (43 endpoints)

> Toda llamada a red retorna `Either<Failure, T>` desde fpdart. Sin excepciones.

### Autenticación (S01-S06)
| ID | Servicio | Entrada clave | Salida clave |
|----|----------|---------------|--------------|
| S01 | Login | usuario, contraseña, tokenFCM, IMEI, empresaCod | userData, sessionToken, listaEmpresas[] |
| S02 | Verificar OTP | celular (envío) / código (validación) | resultado validación |
| S03 | Recuperar contraseña | usuario y/o correo | envía email/SMS |
| S04 | Pre-registro cliente | datos completos | registro pendiente aprobación |
| S05 | Registrar token FCM | usuario, tokenFCM | ok |
| S06 | Refresh token sesión | tokenActual | nuevoToken |

### Catálogo (S07-S10)
| ID | Servicio | Entrada clave | Salida clave |
|----|----------|---------------|--------------|
| S07 | Catálogo completo | usuario | productos[], categorías[], subcategorías[], marcas[], precios[], descuentos[], inventario[], ordenMínima, productosTope[], lanzamientos[], combos[] |
| S08 | Inventario | usuario | productos[] con cantidadDisponible |
| S09 | Buscar productos | término, filtros | productos[] |
| S10 | Productos sugeridos | usuario | productos[] |

> **NOTA S07**: Servicio más pesado. Cachear en memoria durante toda la sesión.

### Promociones y Cupones (S11-S13)
| ID | Servicio | Notas |
|----|----------|-------|
| S11 | Promociones vigentes | Cache session |
| S12 | Validar cupón | Sin cache, siempre red |
| S13 | Cupones del usuario | Cache session |

### Sucursales y Ubicaciones (S14-S18)
| ID | Servicio | Notas |
|----|----------|-------|
| S14 | Sucursales del usuario | Cache persistent 7d |
| S15 | Datos PDV completos | Cache session |
| S16 | Ciudades y departamentos | Cache persistent 30d |
| S17 | Compañías del usuario | Cache session |
| S18 | Actualizar datos cliente | Sin cache |

### Pedidos (S19-S22)
| ID | Servicio | Notas |
|----|----------|-------|
| S19 | Crear pedido | **CRÍTICO — Sin cache, siempre validar** |
| S20 | Disparar pedido al ERP | Sin cache |
| S21 | Historial pedidos | Sin cache (siempre fresco) |
| S22 | Detalle pedido | Cache corto |

### Cartera y Finanzas (S23-S25)
| ID | Servicio | Notas |
|----|----------|-------|
| S23 | Cuentas por cobrar | Cache session |
| S24 | Condiciones de pago | Cache persistent 7d |
| S25 | Puntos fidelización | Cache session |

### Pasarela Ziro - API Externa (S26-S31)
> ⚠️ **DECISIÓN PENDIENTE — Antes de Fase 6**: Confirmar de dónde vienen las credenciales `api_user` y `api_secret`. Opciones:
> 1. Las entrega el cliente → van en `.env` local + GitHub Secrets para CI
> 2. Vienen del backend tras login → no son secretos del cliente Flutter
> 3. Otra opción

| ID | Servicio | Notas |
|----|----------|-------|
| S26 | Auth Ziro | Token sesión Ziro |
| S27 | Consultar cupo | Sin cache |
| S28 | Validar datos crédito | Envía OTP |
| S29 | Validar OTP Ziro | Sin cache |
| S30 | Aplicar crédito | **CRÍTICO** |
| S31 | Cancelar crédito | Sin cache |

### Comunicación (S32-S36)
| ID | Servicio | Notas |
|----|----------|-------|
| S32 | Mensajes | Cache persistent 30min |
| S33 | Noticias | Cache persistent 1h |
| S34 | Push notification | FCM directo |
| S35 | Canales soporte | Cache persistent largo |
| S36 | Mensaje fin de orden | Tras pedido exitoso |

### Recursos y Config (S37-S43)
| ID | Servicio | Notas |
|----|----------|-------|
| S37 | Imágenes (CDN) | Cached_network_image |
| S38 | Banners generales | Cache session |
| S39 | Relación proveedores | Cache session |
| S40 | Tipos de negocio | Cache persistent 30d |
| S41 | Config grillas/vista | Cache session |
| S42 | Términos y condiciones | Cache persistent 30d |
| **S43** | **Config tema/branding** | **CRÍTICO al inicio. Cache persistent 24h.** |

---

## 11. LÓGICA DE NEGOCIO CRÍTICA

### Cálculo de Pedido

Cada línea del pedido calcula:
```
precioBase = precio del producto según lista de precios y unidad
ivaValor = precioBase * (porcentajeIVA / 100)
icoValor = valor ICO del producto
descuento = precioBase * (porcentajeDescuento / 100)  // si aplica promoción
subtotalLínea = (precioBase + ivaValor + icoValor - descuento) * cantidad
```

Totales del pedido:
```
totalBruto = Σ (precioBase * cantidad)
totalIVA = Σ (ivaValor * cantidad)
totalDescuentos = Σ (descuento * cantidad)
totalOrden = totalBruto + totalIVA - totalDescuentos
```

### Factor de conversión de unidades
Un producto puede venderse en múltiples unidades (caja, unidad, sixpack). El `factor` indica cuántas unidades base tiene. Ej: factor=12 para "caja" → 1 caja = 12 unidades.

### Promociones - Tipos
1. **Descuento directo**: % escalonado por rangos (compra entre X y Y → Z% descuento).
2. **Bonificación**: Compra X del A → recibe Y del B gratis. Escalonada.
3. **Combo/Paquete**: Grupo de productos (padre + hijos) que se venden juntos.
4. **Topes**: CantidadTope global. Si acumulado >= tope → promo no disponible.

### Cupones
- Validar contra backend (S12) antes de aplicar
- Se agregan al pedido como líneas con `cantidadRegalo > 0` y `precio = 0`
- Uso único por cupón

### Orden mínima
Cada portafolio tiene monto mínimo. Si total carrito < mínimo → no permitir finalizar.

### Productos con tope
Cantidad máxima por pedido. Validar al agregar al carrito.

### Multi-empresa
Login retorna lista de empresas. Si > 1 → mostrar selector. Empresa seleccionada determina: catálogo, precios, promociones, sucursales, **tema visual**.

### Multi-sucursal
Cada sucursal tiene lista de precios y condiciones de pago propias. Se selecciona al crear pedido.

---

## 12. NOTIFICACIONES PUSH

### Configuración
- Canal: configurable por branding (default `B2B_NOTIFICATIONS`)
- Token FCM se registra en S05 después del login

### Routing por tipo
Payload incluye campo `modulo`:
- `CUENTASXPAGAR` → Pantalla cartera
- `MENSAJES` → Bandeja mensajes
- `{códigoProducto}` → Detalle producto

### Comportamiento
- **Foreground**: Mostrar notificación local con `flutter_local_notifications`
- **Background/Terminated**: Al tocar → abrir app → navegar al módulo
- Se almacenan localmente como mensajes

---

## 13. FLUJOS PRINCIPALES

### Flujo de Inicio (Splash)
```
Splash
  → Cargar config tema/branding (S43) desde cache o red
  → Aplicar tema y locale
  → ¿Hay sesión válida?
    SÍ → Home
    NO → Login
```

### Flujo de Login
```
Login → Validar credenciales (S01)
  → ¿Múltiples empresas?
    SÍ → Selector de empresa → Cargar tema de esa empresa (S43) → Home
    NO → Home
  → Registrar token FCM (S05)
```

### Flujo de Pedido completo
```
Catálogo → Agregar productos al carrito
  → Validar cantidades (topes, inventario)
  → Aplicar promociones automáticamente
  → (Opcional) Validar cupón (S12) → agregar producto regalo
  → "Finalizar Pedido"
  → Seleccionar sucursal (S14)
  → Confirmar dirección de entrega
  → Seleccionar condición de pago (S24)
  → Revisar resumen (subtotal, IVA, ICO, descuentos, total)
  → Validar orden mínima
  → ¿Pago Ziro? (solo si feature habilitada)
    SÍ → Flujo Ziro (S26-S30)
    NO → Confirmar
  → Crear pedido (S19) → Disparar al ERP (S20)
  → Si servidor retorna precios diferentes → mostrar diálogo de cambios
  → Confirmación + mensaje fin de orden (S36)
  → Limpiar carrito
```

### Flujo Ziro (crédito)
```
Auth Ziro (S26) → Consultar cupo (S27)
  → Validar datos crédito (S28) → envía OTP
  → Ingresar OTP → Validar (S29)
  → Aplicar crédito (S30) → Confirmación
```
- Monto mínimo: configurable (default $200,000 COP)
- Identificación: 6-12 dígitos
- OTP: 6 dígitos, reenvío cada 60 segundos

---

## 14. AMBIENTES, FLAVORS Y SECRETOS

### Flavors
La app tiene **dos flavors nativos**: `qa` y `prod`.

- Bundle ID:
  - QA: `com.empresa.b2b.qa`
  - Prod: `com.empresa.b2b`
- Nombre visible:
  - QA: `Dia B2B QA`
  - Prod: `Dia Market B2B`
- Ícono distinto por flavor (con badge "QA" en versión QA)
- Entry points: `lib/main_qa.dart` y `lib/main_prod.dart`

### Configuración de ambiente

```dart
// lib/core/config/app_environment.dart
enum AppEnvironment { qa, prod }

class AppConfig {
  final AppEnvironment env;
  final String apiBaseUrl;
  final String firebaseProjectId;

  const AppConfig({
    required this.env,
    required this.apiBaseUrl,
    required this.firebaseProjectId,
  });

  static const qa = AppConfig(
    env: AppEnvironment.qa,
    apiBaseUrl: 'https://qa.api.diamarket.com',
    firebaseProjectId: 'dia-market-qa',
  );

  static const prod = AppConfig(
    env: AppEnvironment.prod,
    apiBaseUrl: 'https://api.diamarket.com',
    firebaseProjectId: 'dia-market-prod',
  );
}
```

### Manejo de secretos

| Tipo | Dónde vive | Commiteable |
|---|---|---|
| URL backend | `app_environment.dart` | ✅ |
| Firebase config | `firebase_options.dart` (generado) | ✅ |
| Credenciales Ziro (si aplica) | `.env` local + GitHub Secrets en CI | ❌ NUNCA |
| Tokens de sesión runtime | `flutter_secure_storage` | ❌ NUNCA |

`.env.example` se commitea con placeholders. `.env` está en `.gitignore`.

---

## 15. CONVENCIONES DE CÓDIGO

### Nomenclatura
- **Archivos**: snake_case (`product_entity.dart`, `catalog_notifier.dart`)
- **Clases**: PascalCase (`ProductEntity`, `CatalogNotifier`)
- **Variables/funciones**: camelCase (`getProducts`, `isLoading`)
- **Constantes**: camelCase con prefijo k (`kMinOtpLength`, `kDefaultPageSize`)
- **Rutas**: en `AppRoutes` (`AppRoutes.home`, `AppRoutes.cart`)
- **Translation keys**: dot notation en `TrKeys` (`TrKeys.addToCart` → `'catalog.add_to_cart'`)
- **Providers**: terminan en `Provider` (`catalogRepositoryProvider`, `themeNotifierProvider`)

### Patrones
- **Either<Failure, T>** (de fpdart) para retornos de Use Cases
- Un **Use Case** = una clase con método `call()`
- **DTOs** separados de Entities. DTOs tienen `fromJson`/`toJson` + extension `toEntity()`
- **Inmutabilidad**: Entities y DTOs con `freezed`
- **Inyección**: vía providers de Riverpod, nunca singletons globales

### Manejo de errores

```dart
// lib/core/error/failures.dart
@freezed
class Failure with _$Failure {
  const factory Failure.server(String message, {int? statusCode}) = ServerFailure;
  const factory Failure.cache(String message) = CacheFailure;
  const factory Failure.network(String message) = NetworkFailure;
  const factory Failure.validation(String message, {String? field}) = ValidationFailure;
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;
  const factory Failure.unknown(String message) = UnknownFailure;
}
```

### Interceptor Dio (auth + refresh)
- Todas las requests (excepto login, registro, recuperar contraseña) llevan header `Authorization`
- Si recibe 401 → refresh token (S06) → reintentar request
- Si refresh falla → cerrar sesión → `context.go(AppRoutes.login)`

---

## 16. TESTING — POLÍTICA Y EJEMPLO

### Política
- **Tests obligatorios:** Use Cases (capa de domain). Cobertura objetivo: **100%**.
- **Tests opcionales pero recomendados:** Repositories (capa de data). Cobertura objetivo: 80%.
- **Tests opcionales:** Notifiers, Widgets, Integration. Solo si la complejidad lo justifica.

### Estructura
```
test/
└── features/
    └── auth/
        └── domain/
            └── usecases/
                ├── login_usecase_test.dart
                ├── validate_otp_usecase_test.dart
                └── register_usecase_test.dart
```

La estructura del directorio `test/` espeja exactamente la de `lib/`.

### Convenciones de nombres
- Archivo: `<nombre_clase>_test.dart` (ej. `login_usecase_test.dart`)
- Grupo: nombre de la clase bajo prueba (ej. `'LoginUseCase'`)
- Test: formato `'should <expected behavior> when <condition>'`
  - ✅ `'should return User when credentials are valid'`
  - ✅ `'should return ServerFailure when API throws DioException'`
  - ❌ `'test login'`

### Patrón AAA (Arrange / Act / Assert)
Todos los tests deben seguir esta estructura:
1. **Arrange:** preparar mocks, datos de entrada, comportamiento esperado
2. **Act:** ejecutar la acción a probar
3. **Assert:** verificar el resultado y las interacciones con dependencias

### Ejemplo completo de test de Use Case

```dart
// test/features/auth/domain/usecases/login_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mi_app/core/error/failures.dart';
import 'package:mi_app/features/auth/domain/entities/user.dart';
import 'package:mi_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:mi_app/features/auth/domain/usecases/login_usecase.dart';

// Mock del repositorio (usa mocktail, no mockito)
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;

  // setUp se ejecuta antes de cada test
  setUp(() {
    mockRepository = MockAuthRepository();
    useCase = LoginUseCase(mockRepository);
  });

  group('LoginUseCase', () {
    const tUsername = 'testuser';
    const tPassword = 'password123';
    const tUser = User(
      id: '1',
      username: 'testuser',
      email: 'test@example.com',
    );

    test('should return User when credentials are valid', () async {
      // Arrange
      when(() => mockRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Right(tUser));

      // Act
      final result = await useCase(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, const Right<Failure, User>(tUser));
      verify(() => mockRepository.login(
            username: tUsername,
            password: tPassword,
          )).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('should return ServerFailure when API fails', () async {
      // Arrange
      const tFailure = Failure.server('Error del servidor', statusCode: 500);
      when(() => mockRepository.login(
            username: any(named: 'username'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => const Left(tFailure));

      // Act
      final result = await useCase(
        username: tUsername,
        password: tPassword,
      );

      // Assert
      expect(result, const Left<Failure, User>(tFailure));
      verify(() => mockRepository.login(
            username: tUsername,
            password: tPassword,
          )).called(1);
    });

    test('should return ValidationFailure when username is empty', () async {
      // Act
      final result = await useCase(username: '', password: tPassword);

      // Assert
      expect(
        result,
        const Left<Failure, User>(
          Failure.validation('Username is required', field: 'username'),
        ),
      );
      // No debe llamar al repositorio si la validación falla antes
      verifyZeroInteractions(mockRepository);
    });
  });
}
```

### Reglas de testing

1. **Un test por comportamiento.** No mezclar varios casos en un solo test.
2. **Tests independientes.** El orden de ejecución no debe importar. `setUp` antes de cada test.
3. **Mockear solo dependencias directas.** Para `LoginUseCase`, se mockea `AuthRepository`. No se mockea Dio.
4. **Verificar tanto el resultado como las interacciones.** `expect` para el resultado, `verify` para confirmar que se llamó al repositorio con los parámetros correctos.
5. **`verifyNoMoreInteractions`** al final para asegurar que no hay llamadas inesperadas.
6. **Datos de prueba con prefijo `t`** (`tUsername`, `tUser`, `tFailure`) para distinguirlos de variables de producción.
7. **Si el test es difícil de escribir, probablemente la clase está mal diseñada.** Refactorizar antes de forzar el test.

### Cuándo correr los tests

- **Antes de cada commit** importante (no obligatorio, recomendado)
- **Antes de pasar a la siguiente fase** del plan de implementación (obligatorio)
- **Antes de hacer build de release** (obligatorio)

### Comandos
```bash
# Correr todos los tests
flutter test

# Correr tests de un módulo específico
flutter test test/features/auth/

# Correr un solo archivo
flutter test test/features/auth/domain/usecases/login_usecase_test.dart

# Con coverage
flutter test --coverage
# Genera coverage/lcov.info que se puede ver con herramientas tipo lcov
```

### Regla para Claude Code
**Cuando Claude Code crea un Use Case, debe crear su archivo de test en la misma sesión.** Sin excepciones. El test debe cubrir al menos:
- Caso de éxito (happy path)
- Caso de fallo del repositorio (ServerFailure / NetworkFailure)
- Casos de validación de entrada (si aplica)

---

## 17. PLAN DE IMPLEMENTACIÓN POR FASES

| Fase | Módulo | Servicios backend | Semana |
|------|--------|-------------------|--------|
| 0 | Setup proyecto + arquitectura + flavors + tema dinámico + i18n base + widgets comunes | S43 | 1 |
| 1 | Autenticación (login, OTP, registro, sesión) | S01-S06 | 2 |
| 2 | Catálogo (home, categorías, productos, búsqueda, sugeridos, banners) | S07-S10, S37, S38, S41 | 3-4 |
| 3 | Carrito + Checkout | S14, S15, S19, S20, S24, S36 | 5 |
| 4 | Promociones + Cupones | S11-S13 | 6 |
| 5 | Historial + Cartera + Puntos | S21-S23, S25 | 7 |
| 6 | Pago Ziro | S26-S31 (API externa) | 8 |
| 7 | Comunicación + Notificaciones push | S32-S35 | 9 |
| 8 | Perfil + Configuración | S16-S18, S40 | 9-10 |
| 9 | Deep linking + Permisos + Registro completo | S04, S42 | 10 |
| 10 | QA + Optimización + Release | — | 11-12 |

---

## 18. COMANDOS FRECUENTES DEL PROYECTO

```bash
# ====== Dependencias ======
flutter pub get
flutter pub upgrade

# ====== Generación de código ======
# Para generar todos los archivos .g.dart, .freezed.dart, etc.
dart run build_runner build --delete-conflicting-outputs

# Para watch durante desarrollo
dart run build_runner watch --delete-conflicting-outputs

# Limpiar archivos generados
dart run build_runner clean

# ====== Análisis y formato ======
flutter analyze
dart format lib/ test/

# ====== Testing ======
flutter test
flutter test --coverage
flutter test test/features/auth/  # solo un módulo

# ====== Ejecutar app por flavor ======
# Android
flutter run --flavor qa -t lib/main_qa.dart
flutter run --flavor prod -t lib/main_prod.dart

# iOS
flutter run --flavor qa -t lib/main_qa.dart
flutter run --flavor prod -t lib/main_prod.dart

# ====== Build de release ======
# Android
flutter build apk --flavor prod -t lib/main_prod.dart --release
flutter build appbundle --flavor prod -t lib/main_prod.dart --release

# iOS
flutter build ipa --flavor prod -t lib/main_prod.dart --release

# ====== Limpieza ======
flutter clean && flutter pub get
```

---

## 19. REGLAS PARA CLAUDE CODE

### A. Reglas de eficiencia (ahorro de tokens)

1. **No leer archivos completos sin necesidad.** Si solo necesitas una función específica, usa búsqueda por símbolo o grep, no cargues el archivo entero.
2. **No releer archivos ya vistos en la sesión actual.** Si en el mismo chat ya leíste `catalog_repository.dart`, no lo vuelvas a abrir salvo que se haya modificado.
3. **NUNCA generar archivos `.g.dart`, `.freezed.dart`, `.config.dart` manualmente.** Esos los crea `build_runner`. Solo modifica archivos fuente y luego ejecuta el comando de generación.
4. **No leer archivos generados** (`.g.dart`, `.freezed.dart`) salvo que sea estrictamente necesario para depurar un problema de generación.
5. **Antes de crear un widget, buscar si ya existe uno similar** en `shared/widgets/` o en el feature actual. Reutilizar > recrear.
6. **Respuestas técnicas concisas por defecto.** Si el usuario pide "añade un campo email al login", haz el cambio y confírmalo en 2 frases. No escribas un ensayo.

7. **🔴 USO OBLIGATORIO DE CONTEXT7 PARA TODO PAQUETE EXTERNO.** Antes de escribir CUALQUIER línea de código que use un paquete externo, Claude DEBE consultar el MCP `context7` para obtener la API actual del paquete. **No se acepta "creo recordar que la API es así"** ni asumir por memoria. Las APIs cambian entre versiones y la información del entrenamiento puede estar desactualizada.

   **Paquetes que SIEMPRE requieren consulta a context7 antes de usar** (lista no exhaustiva, han cambiado mucho recientemente):
   - `flutter_riverpod` / `riverpod_annotation` / `riverpod_generator` (cambios grandes entre v1 y v2, sintaxis con `@riverpod` es relativamente nueva)
   - `go_router` (cambios entre v5, v6, v7+)
   - `freezed` / `freezed_annotation` (cambios entre v2 y v3)
   - `dio` (diferencias entre v4 y v5)
   - `easy_localization` (sintaxis de plurales y variables)
   - `hive` / `hive_flutter` (adapters generados)
   - `fpdart` (Either, Option, TaskEither)
   - `mocktail` (when/registerFallbackValue)
   - `flutter_secure_storage` (opciones por plataforma)
   - `firebase_messaging` / `flutter_local_notifications` (cambios constantes)
   - `cached_network_image`
   - Cualquier otro paquete del `pubspec.yaml` que no esté ya validado en esta sesión

   **Flujo de trabajo correcto:**
   1. Identificar todos los paquetes externos involucrados en la tarea
   2. Consultar context7 para cada uno (`use context7 to get current API of <package>`)
   3. Validar la versión exacta declarada en `pubspec.yaml`
   4. Recién entonces escribir código
   5. Si compilation falla, releer la respuesta de context7 antes de adivinar la solución

   **Si context7 no responde o no está disponible**, Claude debe pausar y preguntar al usuario antes de continuar adivinando. NO escribir código basado en memoria del entrenamiento sobre estos paquetes.

8. **No ejecutar `flutter pub get` salvo que se modifique `pubspec.yaml`.**

### B. Reglas de arquitectura (calidad)

9. **Toda sección o pantalla que carga datos DEBE tener skeleton loading, no spinner.** El skeleton replica el layout exacto de los elementos que van a aparecer (mismas dimensiones, misma estructura). Se implementa con `ShimmerBox` de `shared/widgets/shimmer_box.dart`. Un `CircularProgressIndicator` o `LoadingIndicator` genérico está prohibido como estado de carga principal de una pantalla o lista. Solo se permite como indicador secundario (ej: botón de submit mientras procesa).

10. **Respetar las 3 capas siempre.** Domain no importa Data ni Presentation. Data implementa Domain. Presentation usa Domain (vía providers).
10. **NUNCA importar `dio` desde Notifiers.** Solo desde Data Sources.
11. **NUNCA poner `fromJson`/`toJson` en Entities.** Solo en DTOs.
12. **Cada Use Case en su propia clase**, con un único método `call()`.
13. **Cada feature nuevo debe crearse en orden**: primero `domain`, luego `data`, luego `presentation`. Y dentro de cada una, primero los modelos/interfaces, luego las implementaciones.
14. **Cualquier llamada a red retorna `Either<Failure, T>`** (de fpdart). Sin excepciones. Sin `throw` propagados a la UI.
15. **Cualquier texto visible usa `tr()` con un key de `TrKeys`.** Excepciones permitidas: logs de debug, identificadores técnicos, claves de assets, datos del backend.
16. **Cualquier color viene del `themeNotifierProvider`** o `Theme.of(context)`. Nunca hex hardcodeados. Excepción: el splash inicial fallback.
17. **Cualquier formateo de moneda usa `CurrencyFormatter.format()`** o el provider `formatCurrencyProvider`. Sin excepciones.
18. **Antes de renderizar módulos opcionales** (Ziro, puntos, cupones, noticias), verificar `featuresProvider`.

### C. Reglas MVVM (separación View / ViewModel)

> Ver sección 8 para detalles, ejemplos y la lista completa de qué puede y no puede hacer cada capa.

19. **MVVM ESTRICTO.** Las pages (Views) son tontas, los Notifiers (ViewModels) son inteligentes. Toda lógica de validación, decisión, y orquestación va en el Notifier. La View solo muestra y delega.
20. **Notifier obligatorio en pantallas con lógica.** Si la pantalla tiene `if`, validaciones, llamadas a use cases, o estado mutable que importa al negocio → tiene su propio Notifier. Solo pantallas puramente informativas (about, T&C, splash sin lógica) pueden ser `ConsumerWidget` directo.
21. **Notifiers son Dart puro.** PROHIBIDO importar `package:flutter/material.dart`, `widgets.dart`, usar `BuildContext`, `TextEditingController`, `FocusNode`, o cualquier elemento de UI dentro de un Notifier.
22. **Side effects con `ref.listen` en la View, NUNCA en el Notifier.** Navegación, snackbars, diálogos, toasts → todo se dispara en la View como reacción al cambio de estado del Notifier.
23. **Estado complejo con sealed classes.** Cuando un Notifier tiene más de 2 estados (loading, success, error, etc.), usar `@freezed sealed class XState` en lugar de variables sueltas. Esto fuerza al compilador a manejar todos los casos en la View con `switch` o `when`.
24. **Las Views NO importan repositorios, data sources, dio, ni storage directamente.** Si una View necesita un dato o una acción, lo pide a su Notifier.

### D. Reglas de cache

25. **Para cambiar el comportamiento del cache, modificar SOLO `cache_policies.dart`.** Nunca tocar los repositorios para esto.
26. **Las operaciones críticas** (S19, S12, S30, S31) **NUNCA usan cache**. Siempre van a la red.
27. **Antes de finalizar un pedido**, comparar precios cacheados vs respuesta del servidor. Si difieren, mostrar diálogo al usuario antes de confirmar.

### E. Reglas Web / Multi-plataforma

> Web es ciudadano de primera clase visual. Ver sección 9-bis para detalles completos.

28. **Toda pantalla nueva se valida en móvil Y chrome** antes de marcarla como completada en PROGRESO.md.
29. **Antes de añadir cualquier paquete nuevo al `pubspec.yaml`**, validar compatibilidad con web usando context7. Si tiene limitaciones web, crear abstracción en `core/services/`.
30. **Servicios platform-specific se acceden SIEMPRE vía abstracciones** en `core/services/`. PROHIBIDO importar `flutter_secure_storage`, `firebase_messaging`, `geolocator`, `permission_handler` directamente desde Notifiers o Use Cases.
31. **TODA pantalla DEBE envolver su contenido en `Center` + `ConstrainedBox`**:
    - Formularios, login, OTP, perfil, checkout → `maxWidth: context.contentMaxWidth` (600px)
    - Home, catálogo, listas, carrito → `maxWidth: context.catalogMaxWidth` (1400px)
    Esto no afecta móvil (ambos getters retornan `infinity` en pantallas < 900px).
32. **Shell de navegación**: en desktop (≥ 900px) usar `NavigationRail` lateral. En móvil `NavigationBar` inferior. Ya implementado — no cambiar sin motivo.
33. **Si una librería falla en web**, documentar en sección 20 y buscar alternativa. No bloquea desarrollo pero sí debe resolverse antes de dar la feature por terminada.

### F. Reglas de proceso

34. **Si una decisión arquitectónica no está clara, preguntar al usuario antes de implementar.** Mejor 30 segundos de pregunta que 2 horas de refactor.
35. **Después de crear un Use Case, crear su test en la misma sesión.** Sin excepción. Usar `mocktail` para mockear repositorios.
36. **Cambios mínimos y dirigidos.** No refactorizar módulos no relacionados con la tarea actual.
37. **Si Claude detecta código repetido en 3+ lugares, proponer extracción a helper/widget compartido**, pero no hacerlo sin confirmar.
38. **🎓 APOYO ACTIVO AL APRENDIZAJE DE RIVERPOD.** El desarrollador está aprendiendo Riverpod desde cero (viene de no haber usado state managers serios). Por eso:

   **a) Comentarios didácticos inline** — Cuando Claude Code use un concepto de Riverpod por primera vez en el proyecto, DEBE incluir un comentario breve (1-2 líneas) explicando qué hace ese concepto en términos simples. Conceptos que requieren explicación al menos la primera vez:
   - `Provider`, `StateProvider`, `FutureProvider`, `StreamProvider`
   - `Notifier`, `AsyncNotifier`
   - `ref.watch` vs `ref.read` vs `ref.listen`
   - `AsyncValue` y sus estados (`loading`, `data`, `error`)
   - `family` (providers parametrizados)
   - `select` (optimización de rebuilds)
   - `keepAlive` y `autoDispose`
   - `ConsumerWidget` vs `ConsumerStatefulWidget`
   - `ProviderScope` y `overrides` (en tests)
   - Generación con `@riverpod` y `part 'archivo.g.dart'`

   Ejemplo de comentario didáctico:
   ```dart
   // ref.watch reconstruye este widget automáticamente cuando el estado cambia.
   // Es como "escuchar" el provider en vivo.
   final catalogState = ref.watch(catalogNotifierProvider);
   ```

   **b) Curva gradual de complejidad** — No introducir patrones avanzados antes de tiempo. Orden recomendado:
   - **Fase 0-1:** Solo `Provider` simple, `ConsumerWidget`, `ref.watch`
   - **Fase 2-3:** Añadir `AsyncValue`, `Notifier`, `ref.read` para acciones
   - **Fase 4-5:** Añadir `ref.listen` para side effects (navegación, snackbars)
   - **Fase 6+:** Patrones avanzados (`family`, `select`, `keepAlive`, `autoDispose`)

   Si una fase requiere un patrón avanzado, Claude debe **avisar al usuario** y explicarlo brevemente antes de usarlo.

   **c) Preferir claridad sobre brevedad** — Si hay dos formas de escribir lo mismo, elegir la más explícita y verbosa para que el desarrollador entienda. La optimización vendrá después.

   **d) Si el desarrollador pregunta "¿qué hace esto?"** sobre cualquier código generado, Claude debe explicarlo en términos simples y con analogías, no con jerga técnica.

39. **No commitear `.env`** ni archivos con credenciales reales. Mantener `.env.example` actualizado con placeholders.
40. **Después de generar código con `build_runner`**, no editar manualmente los archivos generados. Si algo no compila, ajustar el archivo fuente.

---

## 20. DECISIONES PENDIENTES (revisar antes de cada fase)

| Decisión | Fecha límite | Notas |
|---|---|---|
| Cómo el backend entrega APIs (REST tradicional vs cliente Supabase) | Antes de Fase 2 | Pendiente de confirmación con equipo back |
| Origen de credenciales Ziro | Antes de Fase 6 | 3 opciones documentadas en sección 10 |
| Frecuencia real de actualización de precios del cliente | Antes de Fase 2 | Define si los TTL session-only son apropiados o necesitan ajuste |
| Necesidad de servicios S44 (Check Versions) y S45 (Validate Cart) | Antes de Fase 3 | Nice to have, no críticos. La arquitectura los soporta si se implementan |
| **CORS configurado en el backend** | **Antes de validación web (Fase 3-4)** | **CRÍTICO para web. Sin esto la versión web no puede hacer requests. Pedir al equipo backend headers: Access-Control-Allow-Origin, Methods, Headers, Credentials** |
| **¿Ziro tiene SDK Web?** | Antes de Fase 6 | Riesgo de proyecto. Si no tiene SDK Web, decidir: redirect por iframe, quitar Ziro de Web, o pasarela alternativa |
| **¿La web requiere login obligatorio?** (asumimos sí) | Antes de Fase 1 | Si tiene secciones públicas, SEO se vuelve relevante (Flutter Web tiene problemas de SEO) |
| **Dominio donde vivirá la web** | Antes de Fase 10 | Define hosting, certificados SSL, configuración de Firebase |
| **Bundle ID definitivo del cliente** | Antes de Fase 10 | Por ahora se usa placeholder. El cliente tiene app en producción con otro bundle ID — NO chocar |
| **Estrategia de migración respecto a la app actual** | Antes de Fase 10 | A: reemplazar (mismo bundle ID), B: app paralela (bundle distinto), C: coexistencia |
| **Lista de bugs/limitaciones web** descubiertos durante desarrollo móvil | Continuamente | Acumular aquí los problemas que aparezcan al usar paquetes en web. Resolver en fases de validación web |

---

## 21. MODO DE COLABORACIÓN CON EL DESARROLLADOR

> ⚠️ **Leer obligatoriamente al inicio de cada sesión.** Este es el acuerdo de trabajo con el desarrollador del proyecto.

### Contexto del desarrollador
- Tiene experiencia con Flutter y GetX como gestor de estado.
- **Riverpod es completamente nuevo para él.** No asumas conocimiento previo de Riverpod.
- Quiere entender cada decisión, no solo ver código generado.
- El calendario no es rígido — se puede extender el tiempo si se necesita.

### Flujo obligatorio para cada bloque de trabajo

**NUNCA escribir código sin antes haber completado estos pasos:**

1. **Explicar qué se va a hacer y por qué** — en lenguaje claro, sin jerga innecesaria.
2. **Esperar aprobación explícita del desarrollador** — un "listo", "adelante" o "sí" cuenta.
3. **Solo entonces codificar** — con comentarios didácticos en el código.
4. **Explicar el código producido** — señalando las partes importantes.
5. **Esperar preguntas** — no avanzar al siguiente bloque hasta que el desarrollador esté conforme.

### Reglas de enseñanza de Riverpod

- Introducir conceptos **de uno en uno**, en orden de complejidad creciente (ver sección 19, regla 38b).
- Cada concepto nuevo de Riverpod se explica con su **equivalente en GetX** para dar ancla mental.
- Incluir comentarios didácticos en el código (ver sección 19, regla 38a).
- Si el desarrollador pregunta "¿qué hace esto?", responder con analogías simples, no con jerga.

### Tabla de equivalencias GetX → Riverpod (referencia rápida)

| GetX | Riverpod | Notas |
|---|---|---|
| `GetxController` | `Notifier` | El "cerebro" de la pantalla |
| `Get.find<Controller>()` | `ref.read(provider)` | Acceder al controller/provider para ejecutar acciones |
| `Obx(() => ...)` | `ref.watch(provider)` | Escuchar cambios y reconstruir el widget |
| Variable `.obs` | Estado del `Notifier` / `AsyncValue` | El dato reactivo |
| `Get.to()` / `Get.off()` | `context.go()` | Navegación (go_router) |
| `Bindings` | Providers de Riverpod | En Riverpod se crean/destruyen automáticamente |
| `GetMaterialApp` | `ProviderScope` + `MaterialApp.router` | El widget raíz de la app |

### Plan de implementación actual

La Fase 0 está dividida en estos bloques. Estado actualizado aquí cuando se complete cada uno:

| Bloque | Descripción | Estado |
|---|---|---|
| 1 | Dependencias (`pubspec.yaml`) + estructura de carpetas | ⬜ Pendiente |
| 2 | Flavors QA/Prod + `AppConfig` | ⬜ Pendiente |
| 3 | Manejo de errores (`Failure`) + cliente HTTP (`DioClient`) | ⬜ Pendiente |
| 4 | Sistema de Cache (`CachePolicy`) | ⬜ Pendiente |
| 5 | Primer provider Riverpod: `ThemeNotifier` (white-label) | ⬜ Pendiente |
| 6 | Navegación con `go_router` | ⬜ Pendiente |
| 7 | i18n con `easy_localization` + `TrKeys` | ⬜ Pendiente |
| 8 | Widgets compartidos (`AppButton`, `AppTextField`, etc.) | ⬜ Pendiente |
| 9 | Abstracciones de plataforma (`SecureStorageService`, etc.) | ⬜ Pendiente |
| 10 | `main.dart`, `main_qa.dart`, `main_prod.dart` + correr la app | ⬜ Pendiente |

---

## 22. RECORDATORIOS FINALES

- Este documento es **la única fuente de verdad** para arquitectura y convenciones del proyecto. Si algo en el código contradice este documento, el documento gana (y el código se corrige).
- Si una regla del documento bloquea claramente el desarrollo, **proponer su modificación al usuario antes de violarla**.
- El objetivo del proyecto es **migrar una app en producción**, no reinventarla. Cuando haya duda sobre una regla de negocio, asumir que la app actual ya tiene la respuesta correcta.
- **Calidad > velocidad.** Es mejor entregar Fase 0 sólida en 1.5 semanas que entregar 3 fases en 2 semanas con deuda técnica.

---

## 23. SEGUIMIENTO DE PROGRESO

> ⚠️ **LEER OBLIGATORIAMENTE al inicio de cada sesión si no hay contexto previo del avance.**

El archivo **`PROGRESO.md`** (en la raíz del proyecto, junto a este archivo) registra:
- Qué fases y bloques están completados
- Qué archivos se crearon en cada bloque
- Qué sigue en la próxima sesión
- Notas técnicas y convenciones descubiertas durante el desarrollo

### Reglas de actualización

1. **Al completar cualquier bloque**, actualizar `PROGRESO.md` inmediatamente:
   - Cambiar `⬜` por `✅` en el bloque completado
   - Listar los archivos creados o modificados
   - Anotar cualquier convención o decisión técnica nueva

2. **Al iniciar una sesión sin contexto**, leer `PROGRESO.md` antes de cualquier acción:
   - Identificar en qué fase y bloque se quedó
   - Leer las notas técnicas de la sección correspondiente
   - Preguntar al usuario si quiere continuar donde se dejó o cambiar de dirección

3. **Al iniciar una fase nueva**, agregar su tabla de bloques en `PROGRESO.md` antes de empezar a codificar.


## 24. Routing de modelos — desarrollo app Flutter

Modelo por defecto: sonnet


### Cambiar a /model haiku para:
- Escribir o actualizar comentarios, docstrings y documentación inline
- Renombrar variables, archivos o carpetas
- Actualizar archivos de traducción (ARB, strings de l10n)
- Generar boilerplate: modelos de datos, DTOs, enums, clases freezed
- Escribir o actualizar README, CHANGELOG y notas de versión
- Preguntas rápidas o snippets cortos
- Correcciones de formato y lint sencillos

### Permanecer en /model sonnet para:
- Construir nuevos widgets y pantallas
- Implementar lógica de negocio, providers de Riverpod
- Corregir bugs comunes o aislados
- Escribir tests unitarios, de widget y mocks
- Integrar con APIs REST, GraphQL o repositorios locales
- Refactors de alcance medio (1–3 archivos)
- Configuración de navegación y routing
- Conexión del estado con la UI

### Cambiar a /model opus únicamente para:
- Diseñar o revisar la arquitectura general de la app
- Depurar problemas complejos que cruzan varias capas (UI + estado + datos)
- Refactors masivos que afectan muchos archivos o paquetes
- Code review de lógica crítica o sensible a seguridad
- Análisis de rendimiento y estrategia de optimización
- Planificar una feature compleja antes de escribir código
- Revisar pipelines de CI/CD o decisiones de infraestructura

### Comandos de cambio de modelo
/model haiku      # documentación, boilerplate, l10n, renombrado
/model sonnet     # desarrollo Flutter diario (por defecto)
/model opus       # arquitectura, depuración compleja, revisiones críticas
/model opusplan   # modo planificación: Opus razona el plan, Sonnet ejecuta


## 25.Cambio de modo

Modo por defecto: caveman

Cambiar a modo normal SOLO si el usuario escribe:
- explica
- explícame
- paso a paso
- en detalle
- modo normal
- sin caveman

En modo normal:
- Explicar claro
- Ser estructurado
- Priorizar entendimiento sobre brevedad