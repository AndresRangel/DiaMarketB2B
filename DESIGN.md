# DESIGN.md — EntregasB2B Visual System

> Source of truth for visual decisions. All rules here must be implementable
> with Flutter's ThemeData and dynamic color tokens from ThemeNotifier.

---

## Plataformas: Mobile + Web como ciudadanos iguales

**Regla fundamental:** Cada pantalla debe verse bien en móvil Y debe verse como una **web profesional** en navegador — no como una app móvil estirada.

### Qué significa "web profesional" aquí

En desktop/web, EntregasB2B debe competir visualmente con plataformas B2B como Shopify B2B, TradeGecko, o portales de distribuidores modernos. No con apps móviles corriendo en Chrome.

**Diferencias de diseño por plataforma:**

| Aspecto | Móvil | Web/Desktop |
|---------|-------|-------------|
| Layout catálogo | 2 columnas, scroll vertical | Grid 4-6 columnas, sidebar de filtros visible |
| Navegación | NavigationBar inferior | NavigationRail lateral, TopBar con búsqueda inline |
| AppBar | Compacta, iconos | Barra completa con logo, search expandido, carrito con valor |
| Cards de producto | Touch-first, botones grandes | Hover states, imagen más grande, info densa |
| Precio | Unitario prominente | Breakdown visible sin tap, precio por caja/pallet |
| Filtros | Sheet / modal | Panel lateral siempre visible (240px) |
| Formularios | Full width, inputs grandes | Centrados, max 600px, labels inline |
| Carrito | FAB o tab | Sidebar o panel derecho persistente en checkout |
| Tipografía | Más compacta (espacio limitado) | Escala más abierta (pantalla grande) |

### Web: Patrones de diseño específicos

**NO hacer en web** (se ve como app móvil en browser):
- Contenido sin sidebar o estructura de dos columnas
- Botones full-width en desktop
- NavigationBar inferior visible en pantallas > 900px
- Cards con el mismo tamaño que en móvil (muy pequeñas en desktop)
- Sin hover states en elementos interactivos
- Campos de formulario a full width sin `maxWidth`
- AppBar igual que en móvil (sin adaptación)

**SÍ hacer en web**:
- Grid de productos con 4-6 columnas usando el espacio disponible
- Sidebar de filtros siempre visible (no en sheet/modal)
- Hover states en cards: elevación + borde sutil (150ms ease)
- Precio breakdown visible sin necesidad de tap
- Breadcrumbs de navegación (categoría > subcategoría > producto)
- TopBar con logo izquierda, búsqueda centro, carrito+usuario derecha
- Tabla de carrito en lugar de lista de cards (más eficiente en desktop)
- Footer informativo (política, soporte, contacto)

### Checklist web antes de marcar pantalla como completa

- [ ] ¿El layout usa el espacio horizontal disponible (no es solo mobile centrado)?
- [ ] ¿Los hover states están implementados en todas las cards interactivas?
- [ ] ¿Los formularios tienen `maxWidth: context.contentMaxWidth`?
- [ ] ¿El catálogo usa `maxWidth: context.catalogMaxWidth` con grid de más columnas?
- [ ] ¿La navegación muestra NavigationRail lateral, no NavigationBar inferior?
- [ ] ¿Los filtros son sidebar visible, no sheet/modal?
- [ ] ¿Los botones de acción NO son full-width en desktop?
- [ ] ¿Se ven breadcrumbs cuando hay jerarquía de navegación?
- [ ] ¿El cursor es `SystemMouseCursors.click` en elementos clickeables?
- [ ] ¿La densidad de información aprovecha el espacio extra de pantalla?

---

## Color Strategy: Restrained

One primary brand color carries interactive actions (≤60% of surface).
Neutrals carry the rest. Accent used sparingly (<10%).

### Token Map (Flutter → ThemeNotifier)

| Token | ThemeNotifier field | Role |
|-------|---------------------|------|
| primary | `theme.primaryColor` | CTAs, AppBar, active states, prices |
| primaryDark | `theme.primaryDarkColor` | Pressed states, AppBar gradient |
| primaryLight | `theme.primaryLightColor` | Soft backgrounds on primary sections |
| accent | `theme.accentColor` | Discounts, promotions, badges |
| success | `theme.successColor` | Availability, confirmations |
| warning | `theme.warningColor` | Alerts, low stock |
| error | `theme.errorColor` | Validation errors, delete actions |
| background | `theme.backgroundColor` | Page backgrounds |
| surface | `theme.surfaceColor` | Cards, inputs, modals |
| textPrimary | `theme.textPrimaryColor` | Headlines, body |
| textSecondary | `theme.textSecondaryColor` | Labels, captions, hints |

### Derived Alphas (consistent across all colors)

```dart
// Use these alpha values consistently — never arbitrary ones
primary.withValues(alpha: 0.08)   // Soft chip background
primary.withValues(alpha: 0.12)   // Navigation indicator
primary.withValues(alpha: 0.15)   // Hover state background
primary.withValues(alpha: 0.20)   // Active section tint
primary.withValues(alpha: 0.30)   // Border on selected state
primary.withValues(alpha: 0.50)   // Disabled button
```

---

## Typography

### Font Family
**Inter** (preferred for new builds) or **Plus Jakarta Sans** as upgrade path from Roboto.
Configured via `theme.fontFamily` from ThemeNotifier — never hardcoded.

### Type Scale (Flutter TextStyle tokens)

Define in `AppTextStyles` class, using `theme.fontFamily`:

| Token | Size | Weight | LineHeight | LetterSpacing | Use |
|-------|------|--------|------------|---------------|-----|
| `displayLarge` | 28sp | 700 | 1.15 | -0.5 | Section heroes, large amounts |
| `titleLarge` | 20sp | 700 | 1.2 | -0.3 | Page titles, product names (detail) |
| `titleMedium` | 17sp | 600 | 1.25 | -0.2 | Section headers, card titles |
| `titleSmall` | 15sp | 600 | 1.3 | -0.1 | Subsection labels |
| `bodyLarge` | 15sp | 400 | 1.5 | 0 | Primary body, descriptions |
| `bodyMedium` | 13sp | 400 | 1.5 | 0 | Secondary body, table rows |
| `labelLarge` | 13sp | 600 | 1.0 | 0.2 | Buttons (primary), tags |
| `labelMedium` | 12sp | 500 | 1.0 | 0.2 | Chips, badges, secondary labels |
| `labelSmall` | 11sp | 500 | 1.0 | 0.3 | Captions, footnotes, timestamps |
| `priceDisplay` | 18sp | 700 | 1.0 | -0.2 | Prominent price display |
| `priceMedium` | 15sp | 700 | 1.0 | -0.1 | Secondary prices |
| `priceSmall` | 13sp | 600 | 1.0 | 0 | Price breakdowns |

---

## Spacing Scale

**Base:** 4px. All spacing is a multiple of 4.

```dart
// lib/shared/constants/app_spacing.dart
abstract class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double base = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}
```

### Spacing Usage Rules

| Context | Spacing |
|---------|---------|
| Within a component (icon to text) | xs (4) or sm (8) |
| Between elements in a list | sm (8) |
| Card internal padding | base (16) |
| Between cards/sections | base (16) or lg (20) |
| Section vertical padding | xl (24) or xxl (32) |
| Page edge padding | base (16) |

---

## Border Radius Scale

```dart
abstract class AppRadius {
  static const double xs = 4;     // Tags, chips (tight)
  static const double sm = 8;     // Input fields, small buttons
  static const double md = 12;    // Cards, large buttons
  static const double lg = 16;    // Modal bottom sheets, featured cards
  static const double xl = 20;    // Banners, hero containers
  static const double full = 999; // Pills, badges
}
```

**Rule:** Use ONE radius value per component type. No mixing within same component.

---

## Elevation / Shadow

```dart
// lib/shared/constants/app_shadows.dart
// Use BoxShadow list constants — never raw elevation integers alone

// Level 0 — flat (no shadow)
// Level 1 — list items, subtle cards
BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: Offset(0, 2))

// Level 2 — cards (default)
BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: Offset(0, 3))

// Level 3 — active/selected cards (tinted with primaryColor)
BoxShadow(color: primaryColor.withValues(alpha: 0.18), blurRadius: 16, offset: Offset(0, 4))

// Level 4 — modals, FABs
BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: Offset(0, 8))
```

---

## Component Standards

### Touch Targets
**Minimum 44×44px for ALL interactive elements.** No exceptions.
- `_AddButton` height: **44px** (currently 34px — VIOLATES this rule)
- `_QtySelector` height: **44px** (currently 34px — VIOLATES)
- `_InlineBtn` height: **44px** (currently 34px — VIOLATES)
- Navigation destinations: use default Material NavigationBar sizing

### Buttons

**Primary (AppButton):**
- Height: 48px
- Border radius: AppRadius.md (12)
- Font: labelLarge (13sp, w600)
- Loading: 18×18px spinner, strokeWidth: 2

**Secondary (AppOutlinedButton):**
- Height: 48px
- Border: 1.5px primary color
- Font: labelLarge (13sp, w600)

**Compact (in-card actions like _AddButton):**
- Height: 44px (minimum)
- Border radius: AppRadius.sm (8)
- Font: 13sp, w600

### ProductCard

**Grid card aspect ratio:** 0.68 (maintain)
**Image area:** min 45% of card height
**"In cart" state:**
- Border: 1.5px primary × 0.4 alpha (maintain)
- Shadow: primaryColor × 0.18 alpha (reduce from 0.25)
- No elevation jump (subtle, not dramatic)

### Shimmer

**Tie to theme — never hardcoded grays:**
```dart
// baseColor: theme.textSecondaryColor.withValues(alpha: 0.12)
// highlightColor: theme.surfaceColor
```

### AppBar

**Mobile:**
- preferredSize: 60px (current) — maintain
- Logo: max 36px height
- Actions spacing: 4px between icons
- Icon button size: 44×44px (touch target)

**Transparent AppBar (product detail):**
- Background: Colors.transparent
- Elevation: 0
- Show back button with white circle background (8px blur glass effect)

### NavigationBar (bottom, mobile)

- Height: 64px (default Material 3)
- `labelBehavior`: `onlyShowSelected` (change from `alwaysShow` — saves 8px)
- Indicator color: primary × 0.12 alpha (maintain)

### Chips / Filter Pills

- Height: 32px
- Padding: horizontal 14px
- Border radius: AppRadius.full
- Selected: primary background, white text, w600
- Unselected: `backgroundColor` tint, textSecondary, w400
- Transition: 180ms

---

## Loading States (Skeletons)

**Rule:** Every async-loaded region MUST have a skeleton that mirrors the exact layout.

**Shimmer color:** Use theme-derived colors (see Shimmer section above).

**Skeleton rules:**
- Image placeholder → same dimensions as image, AppRadius.md
- Text lines → exact widths (title: 70%, subtitle: 50%, price: 40%)
- Buttons → same size as real button, slightly different radius

---

## Empty States

B2B empty states should be **functional, not decorative.**

**Structure:**
1. Icon: 56×56px, textSecondary × 0.3 alpha background circle, icon inside
2. Title: titleMedium, textPrimary
3. Body: bodyMedium, textSecondary, max 2 lines
4. Action: optional — AppButton or AppOutlinedButton

**Tone:** Direct and helpful. "No hay productos en esta categoría" not "¡Parece que no hay nada aquí todavía!"

---

## Animation Principles

| Type | Duration | Curve |
|------|----------|-------|
| Micro (button press, chip select) | 120–180ms | easeOut |
| State transition (page section change) | 200–250ms | easeInOut |
| Page transition | 250–300ms | easeInOut |
| Carousel auto-play | 300ms (reduce from 450) | easeInOut |
| Modal appear | 250ms | easeOut |

**Never animate:** width/height (use transform instead), color changes >300ms.

**Respect `MediaQuery.disableAnimations`** for accessibility.

---

## B2B-Specific Patterns

### Price Display Hierarchy

```
[Unit Price]         $ 12.500        ← Bold, primary color, large
[Per Case (×12)]     $ 150.000       ← Medium, textSecondary
[IVA 19%]            + $ 2.375       ← Small, warning color  
[Descuento]          − $ 1.250       ← Small, success color
```

### Quantity Selector (Wholesale)

Add **batch quantity** support: long-press on + opens a numeric input for typing quantity directly. B2B buyers frequently order in cases (×12, ×24).

### Cart Badge

Show **item count AND total value** in cart icon area:
```
[Cart icon] 12 items · $485.200
```
(or just count in mobile navigation bar due to space constraints)

### "In Cart" State

Persist across sessions via explicit cart persistence (Hive, not just memory).
Visual indicator on ProductCard must be immediately clear even at small sizes.

---

## Accessibility Minimums

| Element | Requirement |
|---------|-------------|
| Normal text | 4.5:1 contrast ratio |
| Large text (≥18sp bold or ≥24sp) | 3:1 ratio |
| Interactive touch targets | 44×44px minimum |
| Focus indicators | 2px ring, primary color |
| Price/quantity changes | Announce via Semantics |
| Loading states | `Semantics(label: 'Cargando...')` wrapper |

---

## Anti-Patterns (Forbidden)

- `Colors.black` or `Colors.white` directly — use theme tokens
- `Color(0xFF...)` in widget files — use AppColors or theme tokens
- Hardcoded font sizes without going through AppTextStyles
- `CircularProgressIndicator` as full-page loading state (use shimmer)
- Side-stripe borders (border-left as accent)
- Gradient text
- Identical card grids with only icon + title + description
- Nested cards (Card inside Card)
- Modals as first response to a user action (prefer inline)
- Emojis as functional icons
- `elevation` integer prop alone — always pair with custom shadow for consistency
