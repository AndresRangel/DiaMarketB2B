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

## ✅ SPRINT UI/UX — Design System + Polish visual (2026-05)

> Sprint transversal entre Fases 2 y 3. Dos sesiones: primera pasó tokens y estructura,
> segunda (2026-05-08) hizo el polish visual profundo comparando con Rappi/Cornershop.

### Qué se hizo — Sesión 1

| Área | Archivos |
|------|----------|
| Auditoría UI/UX completa (ui-ux-pro-max + impeccable) | `PRODUCT.md`, `DESIGN.md`, `design-system/MASTER.md`, `design-system/pages/*.md` |
| Tokens de diseño | `lib/shared/constants/app_spacing.dart`, `app_radius.dart`, `app_shadows.dart`, `app_text_styles.dart` |
| ShimmerBox → colores themed | `lib/shared/widgets/shimmer_box.dart` |
| ProductCard: touch targets, tokens, InkWell | `product_card.dart` |
| HomePage: tokens, secciones diferenciadas, grid desktop | `home_page.dart` |
| BannerCarousel: 300ms, altura responsive, gradiente | `banner_carousel.dart` |
| MainShell: labelBehavior, surfaceColor | `main_shell.dart` |
| ProductDetailPage: tokens, QuantityButton 44px, RelatedCard | `product_detail_page.dart` |

### Qué se hizo — Sesión 2 (2026-05-08)

| Área | Archivos |
|------|----------|
| `google_fonts: ^6.2.1` añadido — fuente dinámica desde backend | `pubspec.yaml`, `app_config_model.dart` |
| `ProductCard` → `ConsumerStatefulWidget` con hover, sin Card+DecoratedBox, `showAddButton` param | `product_card.dart` |
| `FeaturedProductCard` → hover, `showAddButton`, imagen `surfaceColor` | `product_card.dart` |
| `HomePage` categorías → pills compactos (36px) con hover animado | `home_page.dart` |
| `HomePage` "Más comprados" → `_RankedProductList` (layout completamente diferente a Destacados) | `home_page.dart` |
| Ranked list mobile → lista vertical de 6 items (no carrusel) | `home_page.dart` |
| Destacados + Ofertas → `showAddButton: false`, `childAspectRatio: 0.80` sin botón | `home_page.dart` |
| `ProductDetailPage` mobile → sheet único que sube sobre imagen (sin cards apiladas) | `product_detail_page.dart` |
| ProductDetail: nombre primero (héroe), chips después; secciones con dividers no cards | `product_detail_page.dart` |
| `CartPage` → tokens completos, hover en items, `_QtySelector` con botones cuadrados | `cart_page.dart` |

### Decisiones de diseño tomadas

- **Estrategia de color:** Restrained — un primaryColor lleva acciones, neutrales para estructura
- **Touch targets:** mínimo 44px en TODO elemento interactivo (WCAG 2.5.5)
- **Shimmer:** colores derivados de `themeProvider`
- **Desktop home:** grid 3-5 cols, no scroll horizontal
- **Secciones diferenciadas:** Destacados = grid cards, Más Comprados = lista ranked con número de posición
- **ProductDetail mobile:** patrón "sheet sobre imagen" (imagen gris + sheet blanco con rounded top + sombra hacia arriba). Sin margin negativo — contraste de colores crea la ilusión.
- **Fuente:** `google_fonts` instalado, `toMaterialTheme()` usa `GoogleFonts.getTextTheme()`. Actualmente backend devuelve `"Roboto"` — pedir al back cambiar a `"Inter"` en `get_config`.
- **CartPage:** sin hardcoded colors, todos los tokens del tema

---

## ⬜ PENDIENTE — Sprint UI/UX (siguiente sesión)

### ✅ Completado en esta sesión

| Tarea | Archivos |
|-------|----------|
| `ProductListPage` desktop: sidebar fijo 240px, hover+indicador borde, 3-4 cols junto sidebar | `product_list_page.dart` |
| `ProductListPage` tokens: todos los hardcoded colors → tema, AppTextStyles, AppSpacing | `product_list_page.dart` |
| `AnimatedCard` compartido: fade+slide up 280ms easeOutCubic, delay 40ms×índice máx 320ms | `lib/shared/widgets/animated_card.dart` |
| Animaciones en grids de `HomePage` (Destacados, Ofertas) | `home_page.dart` |
| Animaciones en grid de `ProductListPage` | `product_list_page.dart` |

### P1 — Pendiente

| Tarea | Impacto | Archivo |
|-------|---------|---------|
| Pedir al backend cambiar `fontFamily` de `"Roboto"` a `"Inter"` en `get_config` | ★★★★★ | Backend Supabase |

### ✅ Completado en Sesión 3 (2026-05-11/12) — Sprint UI/UX avanzado

| Área | Archivos |
|------|----------|
| Navegación contextual: `openProductDetail()` → sheet en móvil, push en desktop | `lib/shared/utils/nav.dart` (NUEVO) |
| `ProductDetailPage`: `isSheet` param, `_buildSheetLayout`, handle externo, `ClampingScrollPhysics` | `product_detail_page.dart` |
| `_buildSheetImageSection`: 240px, centrada, sin padding de AppBar | `product_detail_page.dart` |
| `_CloseButton`: botón X circular sobre imagen en sheet | `product_detail_page.dart` |
| Drag-to-dismiss: `GestureDetector(onVerticalDragEnd)` fuera de scroll con velocity > 200 | `product_detail_page.dart` |
| `AppDrawer`: botón cerrar X en header, todos los colores → tokens | `app_drawer.dart` |
| `SearchPage`: reescritura completa — recientes, términos populares, productos populares | `search_page.dart` |
| `RecentSearches` notifier: guarda hasta 6 búsquedas de sesión | `search_notifier.dart` |
| `SearchNotifier.search()`: auto-guarda en recientes antes del debounce | `search_notifier.dart` |
| Todos los product cards navegan via `context.openProductDetail()` | `product_card.dart`, `home_page.dart`, `search_page.dart` |

### P2 — Calidad y consistencia ✅ Completado en Sprint 2026-05-12

| Tarea | Estado |
|-------|--------|
| Auth pages: tokens AppSpacing/AppRadius/AppTextStyles | ✅ |
| `AppButton`: altura 52px + FilledButton + tokens | ✅ |
| `AppTextField`: bordes temáticos | ✅ |
| `AppErrorWidget`: rediseño completo | ✅ |
| `PendingApprovalPage`: branded con themeProvider | ✅ |
| `SplashPage`: neutral + branded animados | ✅ |

---

## ✅ SPRINT UI/UX — Polish visual profundo (2026-05-12)

> Sprint completo de polish visual. Todas las pantallas existentes revisadas mobile + web.
> Cero pendientes visuales hasta que lleguen nuevas fases funcionales.

### Pantallas auth

| Archivo | Cambios |
|---------|---------|
| `login_page.dart` | Reescritura total. Mobile: gradiente primario arriba + card blanca. Desktop: dos columnas (panel marca + formulario). Company selector con tiles animados. |
| `register_page.dart` | Mismo patrón visual que Login. Dropdown temático (mismos bordes que AppTextField). Botón atrás en card desktop. |
| `otp_page.dart` | Panel izquierdo de marca en desktop (igual que Login/Register). OTP boxes 48×56px con borde primario animado al enfocar/completar. Countdown como pill con icono timer. |
| `splash_page.dart` | Neutral: gradiente slate oscuro (#1A2535→#243447) + fade-in + `_LoadingDots` animados. Branded: gradiente primario + círculos decorativos + fade-in del logo + dots. |
| `pending_approval_page.dart` | `ConsumerWidget` con themeProvider. `_PulsingIcon` con anillo animado. Card elevado en desktop. Info bullets temáticos. `AppButton` con icono. |

### Pantallas catálogo

| Archivo | Cambios |
|---------|---------|
| `home_page.dart` | Categorías: pills → `_CategoryGrid` (carousel mobile, grid 2 filas desktop). Tiles con icono temático + label, hover, imagen si disponible. |
| `product_detail_page.dart` | Badge descuento sobre imagen. Handle drag solo en sheet. Label "CANTIDAD". Nombre primero en desktop. Chip descuento en info card. Close button 36→44px. |
| `product_list_page.dart` | Badge carrito: `accentColor` → `Colors.red.shade600`. |
| `search_page.dart` | (sin cambios en esta sesión — ya rediseñada) |

### Carrito

| Archivo | Cambios |
|---------|---------|
| `cart_page.dart` | Reescritura total. Swipe-to-delete mobile (`Dismissible`). Descuento visible en items (tachado + ahorro). SKU. Imagen 80/96px. Touch target `_QtyBtn` 36→44px. Empty state con CTA. Summary bar expandible con `AnimatedSize`. Chip ahorro total. |

### Toast "Agregado al carrito"

| Archivo | Cambios |
|---------|---------|
| `product_detail_page.dart` | Reemplazado overlay oscuro plano por `_CartToast`: slide-up + fade animados, card blanca, ícono check success, barra de progreso auto-dismiss 4s, botón X cerrar. Desktop: esquina inferior derecha 360px. "Ver carrito" cierra sheet antes de navegar. |

### Shared widgets

| Archivo | Cambios |
|---------|---------|
| `app_button.dart` | `ElevatedButton` → `FilledButton`. Altura 52px. `AppRadius.md`. `AppTextStyles.labelLarge`. Parámetro `icon` opcional. `AppOutlinedButton` misma altura/radio. |
| `app_text_field.dart` | Bordes temáticos (gris en reposo, primario al enfocar). `filled: true`. `floatingLabelStyle` en primario. Padding moderno. |
| `app_error_widget.dart` | Ícono en círculo error. Título + mensaje separados. `AppButton` con refresh icon. Tokens completos. |
| `shimmer_box.dart` | Sin cambios — ya usaba colores temáticos correctamente ✅ |

### Skeleton home

| Archivo | Cambios |
|---------|---------|
| `home_skeleton.dart` | Reescritura total. Categorías → `_CategoryTilesSkeleton` (carousel mobile / grid desktop). Productos → grid adaptativo en desktop. Ranked list → grid desktop / lista mobile. Todos los componentes con sombras y radios que coinciden con widgets reales. |

### Decisiones visuales

- **AppButton**: `FilledButton` Material 3 > `ElevatedButton` — mejor hover/press nativo en web
- **OTP boxes**: animación en el propio widget (`_OtpBoxState`) con `focusNode.addListener` — sin estado externo
- **Splash neutral**: gradiente oscuro neutral (no blanco) — se ve como carga premium, no pantalla de error
- **Cart swipe**: `Dismissible(direction: endToStart)` sin confirmación — acción obvia y reversible desde catálogo
- **Toast**: `TickerProviderStateMixin` para dos `AnimationController` independientes (entrada + progreso)
- **Categorías mobile**: carousel siempre (no grid) — menos scroll vertical, descubrimiento más natural

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
