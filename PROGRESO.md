# PROGRESO — EntregasB2B Flutter

> Este archivo se actualiza al completar cada bloque o fase.
> **Leer obligatoriamente al inicio de sesión si no hay contexto previo.**

---

## Estado general

| Fase | Descripción | Estado |
|------|-------------|--------|
| **Fase 0** | Setup + arquitectura base | ✅ Completada |
| Fase 1 | Autenticación | ✅ Completada |
| Fase 2 | Catálogo | ✅ Completada |
| Fase 3 | Carrito + Checkout | 🔄 En progreso |
| Fase 4 | Promociones + Cupones | ⬜ Pendiente |
| Fase 5 | Historial + Cartera + Puntos | ⬜ Pendiente |
| Fase 6 | Pago Ziro | ⬜ Pendiente |
| Fase 7 | Comunicación + Notificaciones push | ⬜ Pendiente |
| Fase 8 | Perfil + Configuración | ⬜ Pendiente |
| Fase 9 | Deep linking + Permisos + Registro completo | ⬜ Pendiente |
| Fase 10 | QA + Optimización + Release | ⬜ Pendiente |

---

## ✅ FASE 0 — Setup + Arquitectura base (Completada)

### Bloque 1 — Dependencias + estructura de carpetas ✅
- `pubspec.yaml` con todas las dependencias del stack
- Estructura completa de carpetas `lib/core/`, `lib/features/`, `lib/shared/`
- iOS deployment target actualizado a 15.0 (requerido por Firebase)
- `~/.zshrc` con `LANG=en_US.UTF-8` y `LC_ALL=en_US.UTF-8` (fix Ruby/CocoaPods)

### Bloque 2 — Flavors QA/Prod + AppConfig ✅
- `lib/core/config/app_environment.dart` — enum `AppEnvironment` + clase `AppConfig`
- `lib/main_qa.dart` — entry point QA (placeholder reemplazado en Bloque 10)
- `lib/main_prod.dart` — entry point PROD

### Bloque 3 — Manejo de errores + DioClient ✅
- `lib/core/error/failures.dart` — sealed class `Failure` con 6 tipos (freezed)
- `lib/core/error/failures.freezed.dart` — generado por build_runner
- `lib/core/network/dio_client.dart` — cliente HTTP con interceptores de auth y refresh token

### Bloque 4 — Sistema de Cache ✅
- `lib/core/cache/cache_policy.dart` — enums `CacheLifetime`, `CacheLayer` + clase `CachePolicy` (freezed)
- `lib/core/cache/cache_policies_config.dart` — mapa central de políticas por tipo de dato
- `lib/core/cache/cache_manager.dart` — gestor de cache en memoria

### Bloque 5 — ThemeNotifier (white-label) ✅
- `lib/core/theme/app_config_model.dart` — modelos `BrandingData`, `AppThemeData`, `LocaleConfig`, `FeatureFlags`, `RemoteAppConfig`
- `lib/core/theme/theme_notifier.dart` — primer provider Riverpod (`@Riverpod(keepAlive: true)`)
- `lib/core/theme/theme_notifier.g.dart` — generado. Provider se llama `themeProvider` (no `themeNotifierProvider`)

### Bloque 6 — Navegación con go_router ✅
- `lib/core/router/app_routes.dart` — constantes de todas las rutas + lista `publicRoutes`
- `lib/core/router/app_router.dart` — GoRouter como provider Riverpod. Guard de auth comentado, listo para Fase 1

### Bloque 7 — i18n + TrKeys ✅
- `assets/translations/es-CO.json` — español Colombia (idioma principal)
- `assets/translations/es-MX.json` — español México
- `assets/translations/en-US.json` — inglés
- `assets/translations/pt-BR.json` — portugués Brasil
- `lib/core/i18n/translation_keys.dart` — clase `TrKeys` con todas las claves
- `lib/core/i18n/locale_setup.dart` — configuración de `EasyLocalization`

### Bloque 8 — Widgets compartidos ✅
- `lib/shared/widgets/app_button.dart` — `AppButton` + `AppOutlinedButton`
- `lib/shared/widgets/app_text_field.dart` — `AppTextField` con ojo de contraseña
- `lib/shared/widgets/app_card.dart` — `AppCard`
- `lib/shared/widgets/loading_indicator.dart` — `LoadingIndicator`
- `lib/shared/widgets/empty_state.dart` — `EmptyState`
- `lib/shared/widgets/app_error_widget.dart` — `AppErrorWidget`

### Bloque 9 — Abstracciones de plataforma ✅
- `SecureStorageService` (interfaz + móvil con flutter_secure_storage + web en memoria)
- `NotificationService` (interfaz + móvil placeholder Fase 7 + web placeholder)
- `LocationService` (interfaz + móvil con geolocator + web placeholder)
- `PermissionsService` (interfaz + móvil con permission_handler + web no-op)
- Todos en `lib/core/services/`

### Bloque 10 — App real corriendo ✅
- `lib/app.dart` — widget raíz con `ProviderScope` + `EasyLocalization` + `MaterialApp.router`
- `lib/main_qa.dart` — actualizado con inicialización real
- `lib/main_prod.dart` — actualizado con inicialización real
- `lib/main.dart` — re-exporta `main_qa.dart` como default
- **App corre en simulador iPhone sin errores**

---

## ✅ FASE 1 — Autenticación (Completada)

### Servicios backend involucrados
- S01 — Login (usuario, contraseña, tokenFCM, IMEI, empresaCod)
- S02 — Verificar OTP
- S03 — Recuperar contraseña
- S04 — Pre-registro cliente
- S05 — Registrar token FCM
- S06 — Refresh token sesión

### Bloques planificados
| Bloque | Descripción | Estado |
|--------|-------------|--------|
| 1 | Entidades de dominio (`UserEntity`, `CompanyEntity`) | ✅ |
| 2 | Repositorio abstracto (`AuthRepository`) + Use Cases | ✅ |
| 3 | DTOs + Remote Data Source (llamadas a S01–S06) | ✅ |
| 4 | `AuthRepositoryImpl` + `SecureStorageService` conectado | ✅ |
| 5 | `AuthNotifier` (keepAlive) + conectar guard del router | ✅ |
| 5b | `SplashPage` real + `ThemeNotifier.loadConfig()` conectado a S43 | ✅ |
| 6 | `LoginPage` + `LoginNotifier` + `LoginState` | ✅ |
| 7 | `OtpPage` + `OtpNotifier` | ✅ |
| 8 | `RegisterPage` + `PendingApprovalPage` | ✅ |
| 9 | Tests de Use Cases (obligatorios) | ✅ |

---

## ✅ CONEXIÓN BACKEND REAL — S43 + Splash + Login (Completado 2026-04-09)

> Bloque transversal entre Fase 0/1 y Fase 2. Se hizo antes de Fase 2 porque
> el cliente entregó acceso real al backend (Supabase).

### Qué se hizo

| Cambio | Archivos |
|--------|----------|
| Backend confirmado como Supabase. URL y anon key reales en `AppConfig` | `app_environment.dart` |
| Header `apikey` agregado a todas las requests en el DioClient | `dio_client.dart` |
| `ApiEndpoints.themeConfig` → `/rest/v1/rpc/get_config` (endpoint real) | `api_endpoints.dart` |
| S43 en `_publicPaths` (no requiere JWT de usuario, solo anon key) | `dio_client.dart` |
| Logo real desde `branding.splashLogoUrl` en el splash con `CachedNetworkImage` | `splash_page.dart` |
| Logo real desde `branding.logoUrl` en el login con `CachedNetworkImage` | `login_page.dart` |
| Preloading del tema antes de `runApp()` para evitar flash de colores/logo | `main_qa.dart`, `theme_notifier.dart` |
| `SecureStorageServiceWeb` descartado — ahora todas las plataformas usan `flutter_secure_storage` | `secure_storage_service.dart` |
| Delay de 2s en el splash después de cargar config, antes de verificar auth | `splash_page.dart` |

### Decisiones técnicas importantes

**Backend es Supabase (resuelve decisión pendiente de sección 20 del CLAUDE.md)**
- Todos los endpoints siguen el patrón `/rest/v1/rpc/{nombre_funcion}`
- El anon key va en header `apikey` en todas las requests (seguro por diseño — RLS controla permisos)
- Endpoints autenticados llevan además `Authorization: Bearer {jwt_usuario}`
- Endpoints públicos (S43, etc.) solo llevan `apikey`

**Flash de colores/logo en arranque — causa y solución**
- Causa: `App` widget renderiza con fallback antes de que `loadConfig()` termine (async)
- Solución: en `main_qa.dart`, antes de `runApp()`, leer config del cache y llamar `preloadThemeConfig()`
- `ThemeNotifier.build()` usa `_preloadedConfig ?? RemoteAppConfig.fallback` como estado inicial
- Primer arranque (sin cache): sigue usando fallback. Segundo arranque en adelante: sin flash

**SecureStorage unificado en todas las plataformas**
- `SecureStorageServiceWeb` usaba memoria (se perdía al recargar) — cache del tema nunca persistía en web
- `SecureStorageServiceMobile` usa `flutter_secure_storage` que en web usa `localStorage` (persistente)
- Solución: `secureStorageProvider` ahora usa `SecureStorageServiceMobile` en todas las plataformas
- Implicación: en web los datos van a `localStorage` (no es keychain, pero es aceptable para esta app B2B)

**Orden del splash**
- `loadConfig()` primero → logo real aparece
- `Future.delayed(2s)` → splash visible con logo
- `authProvider.initialize()` al final → GoRouter redirige
- El delay va ANTES de `initialize()` porque el GoRouter reacciona instantáneamente al cambio de estado de `authProvider`. Si fuera después, el router ya habría navegado.

---

## ✅ FASE 2 — Catálogo (Completada)

### Servicios backend involucrados
- S07 — Catálogo vía Supabase REST: `products_v`, `categories_v`, `brands_v`
- S09 — Búsqueda: filtro `ilike` sobre `products_v`
- S08, S10, S38, S41 — Pendientes

### Bloques planificados
| Bloque | Descripción | Estado |
|--------|-------------|--------|
| 1 | Entidades de dominio (`ProductEntity`, `CategoryEntity`, `BrandEntity`) | ✅ |
| 2 | Repositorio abstracto (`CatalogRepository`) + Use Cases (5) | ✅ |
| 3 | DTOs + Remote Data Source (Supabase REST real) | ✅ |
| 4 | `CatalogRepositoryImpl` con cache session en memoria | ✅ |
| 5 | `CatalogNotifier` + `HomePage` + `ProductCard` + `CurrencyFormatter` | ✅ |
| 5b | Rediseño profesional Home + ProductCard + BannerCarousel + Shell + Skeleton | ✅ |
| 6 | `ProductDetailPage` — detalle de un producto | ✅ |
| 6b | Rediseño profesional ProductDetailPage + skeleton + qty selector | ✅ |
| 7 | `SearchPage` + `SearchNotifier` + rediseño web (grilla desktop) | ✅ |
| 8 | Tests de Use Cases (23 tests verdes) | ✅ |

---

## 🔄 FASE 3 — Carrito + Checkout (En progreso)

### Servicios backend involucrados
- S14 — Sucursales del usuario
- S15 — Datos PDV completos
- S19 — Crear pedido (CRÍTICO)
- S20 — Disparar pedido al ERP
- S24 — Condiciones de pago
- S36 — Mensaje fin de orden

### Bloques planificados
| Bloque | Descripción | Estado |
|--------|-------------|--------|
| 1 | `CartItemEntity` + `CartEntity` (dominio) | ✅ |
| 2 | `CartNotifier` (keepAlive, add/remove/qty/addWithQuantity) | ✅ |
| 3 | `CartPage` (mobile lista + desktop 2 columnas) | ✅ |
| 3b | Badge cantidad en `ProductCard` + selector qty inline + `FeaturedProductCard` | ✅ |
| 3c | Botón "Agregar" activo en `ProductDetailPage` + snackbar | ✅ |
| 3d | Badge carrito en `NavigationBar`/`NavigationRail` | ✅ |
| 3e | Menu lateral (`AppDrawer`) móvil + sidebar desktop | ✅ |
| 3f | `DesktopTopBar` + layout web real (TopBar + sidebar + contenido) | ✅ |
| 4 | `BranchEntity` + `PaymentConditionEntity` (dominio checkout) | ⬜ |
| 5 | DTOs + Data Sources S14, S24 | ⬜ |
| 6 | `CheckoutPage` (sucursal → pago → confirmar → S19/S20) | ⬜ |
| 7 | `OrderSuccessPage` | ⬜ |
| 8 | Tests Use Cases | ⬜ |

### Notas técnicas Fase 3
- `CartNotifier` keepAlive — vive toda la sesión, no se destruye al navegar
- `cartProvider.select((c) => c.quantityOf(sku))` — reconstruye solo la card afectada, no toda la lista
- `ProductCard` botón cambia a selector `[−|qty|+]` inline cuando qty > 0
- `mainScaffoldKey` GlobalKey en `MainShell` — abre drawer desde cualquier página
- Desktop layout: `Column(DesktopTopBar + Row(AppDrawer(showHeader:false) + content))`
- Shell pages (`HomePage`, `CartPage`) usan `appBar: isDesktop ? null : _buildAppBar(...)` 
- Permisos Android agregados: INTERNET, NETWORK_STATE, POST_NOTIFICATIONS, VIBRATE, BOOT, WAKE_LOCK, LOCATION

---

## Notas técnicas importantes

### Convenciones descubiertas durante Fase 0
- En Riverpod 3.x + riverpod_generator 4.x, los providers generados para clases `Notifier` **eliminan el sufijo `Notifier`** del nombre. Ej: `ThemeNotifier` → `themeProvider`, `AuthNotifier` → `authProvider`, `LoginNotifier` → `loginProvider`. Los providers de funciones simples (`@riverpod LoginUseCase loginUseCase(...)`) sí mantienen el nombre completo → `loginUseCaseProvider`.
- Las clases `@freezed` no-sealed deben declararse como `abstract class` en freezed 3.x.
- `custom_lint` no se declara explícitamente en `pubspec.yaml` — `riverpod_lint` lo trae como dependencia interna. Declararlos juntos causa conflicto de versiones del analyzer.
- `flutter run` sin `-t` lanza `lib/main.dart` (que re-exporta QA).
- `flutter run -t lib/main_qa.dart -d iphone` para simulador iOS.

### Bloque 5b — SplashPage + ThemeNotifier conectado
- `lib/features/auth/presentation/pages/splash_page.dart` — pantalla de arranque real
- `lib/core/theme/theme_notifier.dart` — `loadConfig()` conectado a `RemoteConfigRepository`
- `lib/core/theme/app_config_model.dart` — `toJson()` añadido a `RemoteAppConfig`
- `lib/core/theme/remote_config_repository.g.dart` — generado por build_runner
- `lib/core/theme/remote_config_data_source.g.dart` — generado por build_runner
- Flujo verificado: S43 falla (URL falsa) → sin cache → fallback activo → router redirige a /login

### ApiEndpoints — centralización de URLs
- `lib/core/network/api_endpoints.dart` — clase nueva con los 43 endpoints como constantes estáticas
- `lib/core/theme/remote_config_data_source.dart` — usa `ApiEndpoints.themeConfig`
- `lib/features/auth/data/datasources/auth_remote_data_source.dart` — usa `ApiEndpoints.*` en todos los métodos
- Convención: los endpoints no confirmados con backend están marcados con `// [PLACEHOLDER]`
- Regla: ningún data source puede tener strings de URL hardcodeados — siempre `ApiEndpoints.*`

### Bloque 9 — Tests de Use Cases
- `test/features/auth/domain/usecases/login_usecase_test.dart` — 7 casos
- `test/features/auth/domain/usecases/validate_otp_usecase_test.dart` — 6 casos
- `test/features/auth/domain/usecases/send_otp_usecase_test.dart` — 5 casos
- `test/features/auth/domain/usecases/recover_password_usecase_test.dart` — 6 casos
- `test/features/auth/domain/usecases/register_usecase_test.dart` — 7 casos
- **Total: 31 tests, todos verdes ✅**
- Comando: `flutter test test/features/auth/domain/usecases/`

### Bloque 8 — RegisterPage + PendingApprovalPage
- `lib/features/auth/presentation/notifiers/register_state.dart` — sealed class con 4 estados: `initial`, `loading`, `success(user)`, `error(message, field?)`
- `lib/features/auth/presentation/notifiers/register_notifier.dart` — ViewModel: valida 6 campos + confirmPassword, llama `RegisterUseCase`, extrae `field` de `ValidationFailure`
- `lib/features/auth/presentation/pages/register_page.dart` — formulario con usuario, contraseña, confirmación, teléfono, email, tipo de negocio (dropdown), código de referido (opcional). Navega a `/pending-approval` en éxito
- `lib/features/auth/presentation/pages/pending_approval_page.dart` — pantalla estática informativa, sin Notifier. Botón "Iniciar sesión" navega a `/login`
- Router: `/register` → `RegisterPage`, `/pending-approval` → `PendingApprovalPage`
- Corrección: `DropdownButtonFormField.value` está deprecated → usar `initialValue`
- Pendiente Fase 8: tipos de negocio hardcodeados → conectar a S40. Ciudad hardcodeada → conectar a S16

### Bloque 7 — OtpPage + OtpNotifier + OtpState
- `lib/features/auth/presentation/notifiers/otp_state.dart` — sealed class con 6 estados + enum `OtpFlow` (recoverPassword, registration)
- `lib/features/auth/presentation/notifiers/otp_notifier.dart` — ViewModel: envía OTP, valida código, countdown 60s con `Timer.periodic`, limpieza con `ref.onDispose`
- `lib/features/auth/presentation/pages/otp_page.dart` — View con dos fases: fase 1 (pedir teléfono), fase 2 (6 campos OTP + countdown reenvío)
- Router: `/otp` conectado a `OtpPage` con query params `flow` y `phone`
- Navegación desde LoginPage: `context.push(AppRoutes.otp)` (ya estaba conectado)
- Corrección: `dispose()` no existe en Riverpod `Notifier` → usar `ref.onDispose(() => timer.cancel())` dentro de `build()`

### Bloque 6 — LoginPage + LoginNotifier + LoginState
- `lib/features/auth/presentation/notifiers/login_state.dart` — sealed class con 5 estados: `initial`, `loading`, `success`, `needsCompanySelection`, `error`
- `lib/features/auth/presentation/notifiers/login_notifier.dart` — ViewModel: valida, llama `LoginUseCase`, maneja flujo multi-empresa
- `lib/features/auth/presentation/pages/login_page.dart` — View: campos usuario/contraseña, `AppButton`+`AppTextField`, `ref.listen` para navegación/snackbar, `_CompanySelectorSheet` para multi-empresa
- `lib/core/responsive/breakpoints.dart` — creado (faltaba desde Fase 0)
- `lib/core/responsive/responsive_extensions.dart` — creado (faltaba desde Fase 0)
- `AppTextField` — añadidos `focusNode`, `textInputAction`, `onSubmitted`
- Router: `/login` conectado a `LoginPage` (antes era `_PlaceholderPage`)
- Corrección aplicada: `authNotifierProvider` → `authProvider`, `loginNotifierProvider` → `loginProvider`
- Corrección aplicada: `Failure.when()` es una **extension** (`FailurePatterns`) — requiere importar `failures.dart` para tenerla en scope

### Decisión arquitectónica — Backend es Supabase (confirmado 2026-04-09)
- **Decisión pendiente resuelta:** el backend es Supabase, no un REST tradicional propio.
- URL base: `https://yffvbmpngcrgcknimnjc.supabase.co` (QA y PROD comparten el mismo proyecto por ahora)
- Patrón de endpoints RPC: `/rest/v1/rpc/{nombre_funcion}`
- Todas las requests llevan el header `apikey` con el anon key de Supabase (seguro en cliente — RLS controla permisos)
- Endpoints autenticados llevan además `Authorization: Bearer {jwt_usuario}`
- Endpoints públicos (S43, etc.) solo llevan `apikey`
- `AppConfig.supabaseAnonKey` almacena la clave anónima; se inyecta en `DioClient` como header base
- `ApiEndpoints.themeConfig` → `/rest/v1/rpc/get_config` (confirmado y funcionando ✅)

### Fase 2 — Bloque 5b/6b — Rediseño UI profesional

**NavigationBar (Bottom Nav):**
- `StatefulShellRoute.indexedStack` en go_router 17.x con 4 branches: Home, Promociones, Carrito, Perfil
- `MainShell` en `lib/core/shell/main_shell.dart` — envuelve el shell de go_router
- Rutas fuera del shell (sin bottom nav): auth routes + `/product/:id`
- `lib/features/promotions`, `cart`, `profile` con páginas placeholder

**Home redesign:**
- `BannerCarousel` — auto-scroll 3s, PageView con dot indicators animados, gradiente inferior
- `_CategoriesSection` — círculos con letra inicial + paleta de colores por índice, selección activa con sombra
- `_FeaturedSection` — scroll horizontal de `FeaturedProductCard` (148×200px)
- Grilla adaptativa: 2 cols móvil / 3 tablet / 4 desktop con `Breakpoints`
- `HomeSkeleton` — shimmer que replica layout exacto de cada sección
- `shimmer: ^3.0.0` agregado a pubspec.yaml

**ProductCard:**
- `BoxFit.contain` + fondo `#F8F9FB` + padding 8px → imagen completa sin recorte
- `FilledButton` desactivado (Fase 3) en lugar de `OutlinedButton`
- `FeaturedProductCard` — variante 148px ancho para scroll horizontal

**ProductDetailPage:**
- `extendBodyBehindAppBar: true` + AppBar transparente con botones circulares blancos
- Imagen 300px con `BoxFit.contain` + fondo claro (no cover)
- 3 cards (info, precio, cantidad) con shadow sutil + border radius 16
- Chips de categoría + SKU + disponibilidad
- Selector de cantidad con estado local (`_quantity`) — conectar a CartNotifier en Fase 3
- Total calculado en tiempo real: `_quantity × finalPrice`
- Sticky bottom bar con total + botón "Agregar al carrito"
- `_ProductDetailSkeleton` — skeleton que replica cada sección

### Fase 2 — Notas técnicas

**Backend catálogo (confirmado)**
- Supabase REST (PostgREST). Vistas públicas: `products_v` (200), `categories_v` (52), `brands_v` (817)
- Todos los endpoints: `/rest/v1/{vista}` con query params PostgREST estándar
- `base_price` llega como String `"10000.0000"` (tipo numeric de PostgreSQL) → `double.tryParse()` en mapper
- Filtro búsqueda: `name=ilike.*TERM*` (case-insensitive, asterisco es comodín PostgREST)
- Ordenamiento categorías: `parent_id.asc.nullsfirst,name.asc` → padres primero

**Login conectado (temp)**
- Endpoint real: `/rest/v1/rpc/login_user` con `{"p_email": "..."}` — devuelve `[{id, email}]`
- El RPC actual ignora contraseña (endpoint de desarrollo). Token = user ID (temporal)
- Empresa hardcodeada como `CompanyDto(id:'default', code:'DEFAULT', name:'Mi Empresa')` hasta endpoint definitivo
- Splash neutro (blanco) → primer arranque sin cache. Branded desde segundo arranque

**CatalogNotifier**
- Usa `AsyncNotifier` → `build()` retorna `Future<CatalogData>` → Riverpod maneja `AsyncValue` automáticamente
- `CatalogData` es Dart record: `({List<ProductEntity> products, List<CategoryEntity> categories})`
- Productos y categorías se cargan en PARALELO (dos futures iniciadas antes de primer await)
- Nombre generado: `CatalogNotifier` → `catalogProvider` (no `catalogNotifierProvider`)
- `refresh()` usa `ref.invalidateSelf()` para forzar rebuild completo

**CurrencyFormatter**
- `lib/core/utils/currency_formatter.dart` — implementación real usando `LocaleConfig`
- Soporta separador de miles, decimales configurables y símbolo de moneda del cliente

**ProductDetailPage (Bloque 6)**
- `lib/features/catalog/presentation/notifiers/product_detail_notifier.dart` — family provider `productDetailProvider(sku)`: busca primero en cache del catálogo, fallback a API
- `lib/features/catalog/presentation/pages/product_detail_page.dart` — SliverAppBar con imagen, nombre, SKU, categoría, desglose precio base+IVA+total, botón carrito (disabled Fase 3)
- Router: `/product/:id` → `ProductDetailPage(sku: ...)`
- `ProductCard` → tap navega a `/product/{sku}` vía `context.push`

### Versiones clave del stack
- flutter_riverpod: 3.3.1
- riverpod_annotation: 4.0.2
- riverpod_generator: 4.0.3
- go_router: 17.2.0
- freezed: 3.2.5 / freezed_annotation: 3.1.0
- fpdart: 1.2.0
- easy_localization: 3.0.8
- iOS deployment target: 15.0 (Firebase lo requiere)
