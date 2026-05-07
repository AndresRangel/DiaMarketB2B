# Design System MASTER — EntregasB2B
> Generated from ui-ux-pro-max + impeccable audit — 2026-05
> This file is the authoritative source for all visual decisions.
> Page-specific overrides live in `design-system/pages/`.

---

## Product Profile

**Type:** B2B wholesale commerce mobile app (Flutter)
**Register:** Product (design serves the tool)
**Theme:** Dynamic (remote config via Firebase / S43 endpoint)
**Color Strategy:** Restrained — tinted neutrals + one brand primary

---

## Critical Rules

1. **Zero hardcoded colors in widget files.** All colors via `themeProvider` or `AppColors` tokens derived from theme.
2. **Touch targets ≥ 44px.** Every tappable element. Currently violated: `_AddButton`, `_QtySelector`, `_InlineBtn` (all 34px → fix to 44px).
3. **No full-page spinners.** Shimmer skeletons always. `CircularProgressIndicator` only as secondary indicator (submit button).
4. **Every async-loaded surface has a skeleton** that mirrors the exact layout of the real content.
5. **Type scale from AppTextStyles.** No inline `fontSize:` declarations in production widgets.
6. **Spacing from AppSpacing.** No inline `EdgeInsets.all(10)` or `SizedBox(height: 5)` magic numbers.
7. **Border radius from AppRadius.** Consistent per component class.

---

## Plataforma: Mobile Y Web profesional

> Regla no negociable: la app en navegador debe parecer un portal B2B profesional,
> no una app móvil corriendo en browser.

### La prueba de "¿parece web profesional?"

Abrir la app en Chrome a 1440px. Preguntar: ¿parece un portal de distribución profesional
o parece una pantalla de móvil centrada con espacio vacío alrededor?

Si hay **espacio vacío lateral sin usar** → falta layout de desktop.
Si los **botones son full-width** → diseño de móvil sin adaptar.
Si **no hay hover states** → no se aprovechó la plataforma.
Si **los filtros son un sheet/modal** → falta sidebar.
Si **el grid de productos tiene 2 columnas** → no se adaptó para desktop.

### Diferencias de implementación por breakpoint

```dart
// mobile (< 600px)         tablet (600-900px)         desktop (≥ 900px)
// 2 col grid               3 col grid                  4-6 col grid
// NavBar inferior          NavBar inferior              NavigationRail lateral
// Filtros en sheet         Filtros en sheet             Filtros en sidebar fijo (240px)
// Botones full-width       Botones full-width           Botones con ancho propio
// Sin hover states         Sin hover states             Hover states en cards
// Sin breadcrumbs          Breadcrumbs opcionales       Breadcrumbs siempre visibles
// AppBar compacta          AppBar media                 TopBar completa (logo+search+cart)
// Sin cursor pointer       Sin cursor pointer           MouseRegion + SystemMouseCursors.click
```

### Hover states en Flutter Web (obligatorio en desktop)

Todo elemento interactivo en desktop necesita hover visual:

```dart
// Patrón estándar para cards con hover en web
class _HoverCard extends StatefulWidget { ... }

class _HoverCardState extends State<_HoverCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          // elevación aumenta sutilmente al hover
          boxShadow: _hovered ? AppShadows.level3 : AppShadows.level1,
          border: _hovered
            ? Border.all(color: primaryColor.withValues(alpha: 0.25))
            : Border.all(color: Colors.transparent),
        ),
        child: child,
      ),
    );
  }
}
```

### Sidebar de filtros (desktop solamente)

En `ProductListPage` y futuras páginas con filtros, desktop debe mostrar:

```
┌──────────────────┬────────────────────────────────────┐
│ Filtros (240px)  │ Grid de productos (restante)        │
│                  │                                      │
│ Categorías       │ [card][card][card][card]             │
│  ● Bebidas       │ [card][card][card][card]             │
│  ○ Lácteos       │ [card][card][card][card]             │
│  ○ Snacks        │                                      │
│                  │                                      │
│ Marcas           │                                      │
│ Precio           │                                      │
└──────────────────┴────────────────────────────────────┘
```

En mobile: mismos filtros en un BottomSheet o FilterChips horizontales.

### TopBar (desktop solamente — ya implementado en shell)

Verificar que `TopBar` contiene:
- Logo (izquierda, vinculado a home)
- Barra de búsqueda expandida (centro, no solo ícono)
- Carrito con item count + total (derecha)
- Usuario/empresa info (derecha)

Si `TopBar` solo tiene logo + íconos → es mobile en desktop, no web profesional.

### Breadcrumbs (desktop, páginas de profundidad ≥ 2)

```dart
// En ProductListPage (desktop):
// Home > Categoría > Subcategoría

// En ProductDetailPage (desktop):
// Home > Categoría > Producto

// Widget: BreadcrumbBar (crear en shared/widgets/)
Row(
  children: [
    TextButton(onPressed: () => context.go('/home'), child: Text('Inicio')),
    Icon(Icons.chevron_right, size: 16, color: textSecondary),
    TextButton(onPressed: () => context.go('/products?cat=bebidas'), child: Text('Bebidas')),
    Icon(Icons.chevron_right, size: 16, color: textSecondary),
    Text('Coca-Cola 350ml', style: AppTextStyles.bodyMedium.copyWith(color: textSecondary)),
  ],
)
```

### Grid columns por breakpoint

```dart
// ProductListPage, HomePage sections
int _crossAxisCount(BuildContext context) {
  final w = MediaQuery.sizeOf(context).width;
  if (w >= 1400) return 6;
  if (w >= 1100) return 5;
  if (w >= 900)  return 4;
  if (w >= 600)  return 3;
  return 2; // mobile
}
```

### Cart en desktop

En desktop, el checkout/carrito debe usar layout de dos columnas:
- Izquierda: lista de productos (tabla, no cards apiladas)
- Derecha: resumen del pedido (sticky)

```
┌──────────────────────────┬────────────────┐
│ Producto  │ Qty  │ Total  │  Resumen       │
│ Coca-Cola │  ×12 │ 45.000 │  Subtotal      │
│ Agua      │  ×24 │ 28.800 │  IVA           │
│ ...       │      │        │  Descuento     │
│                           │  ─────────     │
│                           │  Total         │
│                           │  [Confirmar]   │
└──────────────────────────┴────────────────┘
```

---

---

## Color Tokens

See `DESIGN.md` → Color section for full token map.

**Most common derived alphas:**
- `.08` — soft chip/section background
- `.12` — navigation indicator, subtle tint
- `.18` — active card shadow (tinted)
- `.30` — selected border

---

## Type Scale Quick Reference

| Token | Size | Weight | Use |
|-------|------|--------|-----|
| titleLarge | 20sp | 700 | Product detail title |
| titleMedium | 17sp | 600 | Section headers |
| bodyLarge | 15sp | 400 | Primary body text |
| bodyMedium | 13sp | 400 | Secondary info |
| labelLarge | 13sp | 600 | Buttons, important labels |
| labelMedium | 12sp | 500 | Chips, badges |
| labelSmall | 11sp | 500 | Timestamps, captions |
| priceDisplay | 18sp | 700 | Unit price prominent display |
| priceSmall | 13sp | 600 | Price breakdown rows |

---

## Spacing Quick Reference

| Token | Value | Use |
|-------|-------|-----|
| xs | 4px | Icon-to-text gaps |
| sm | 8px | List item gaps |
| md | 12px | Card internal secondary padding |
| base | 16px | Card padding, page edges |
| lg | 20px | Between sections |
| xl | 24px | Section vertical padding |
| xxl | 32px | Large section breaks |

---

## Border Radius Quick Reference

| Token | Value | Use |
|-------|-------|-----|
| xs | 4px | Tags, tight chips |
| sm | 8px | Input fields, compact buttons |
| md | 12px | Standard cards, buttons |
| lg | 16px | Featured cards, bottom sheets |
| xl | 20px | Banners, hero containers |
| full | 999px | Pills, badges |

---

## Component Checklist

### ProductCard
- [ ] Touch targets ≥ 44px (`_AddButton`, `_QtySelector`)
- [ ] `Colors.white` → `theme.surfaceColor`
- [ ] `Color(0xFF1A1A2E)` → `theme.textPrimaryColor`
- [ ] `Color(0xFFCFD8DC)` placeholder → `theme.textSecondaryColor.withValues(alpha: 0.4)`
- [ ] `Color(0xFFF8F9FB)` image bg → `theme.backgroundColor`
- [ ] Shimmer colors tied to theme

### ShimmerBox
- [ ] `Color(0xFFE0E0E0)` → `theme.textSecondaryColor.withValues(alpha: 0.12)`
- [ ] `Color(0xFFF5F5F5)` → `theme.surfaceColor`

### AppButton
- [ ] Height: 48px (currently unspecified — relies on theme)
- [ ] Ensure `ButtonStyle` uses theme primary color via ThemeData

### Navigation (MainShell)
- [ ] `labelBehavior`: change to `onlyShowSelected` (saves 8px vertical)

### BannerCarousel
- [ ] Auto-play duration: keep 3s
- [ ] Transition: reduce from 450ms to 300ms
- [ ] Max height: consider 190px (from 170px) for better image presentation

---

## Screen-Specific Overrides

See `design-system/pages/` for per-screen guidance.

---

## B2B-Specific UX Standards

### Information Density
- Product cards: name (2 lines max), price, quantity control. NO description text.
- List items: name + price + quantity = complete information.
- Avoid truncation for critical info (price, availability).

### Ordering Patterns
- Primary CTA always visible (sticky bar or pinned button).
- Quantity changes must be immediate (no confirmation dialog for ±1).
- Bulk quantity input (type-in) for orders > 9 units.

### Trust Signals
- Show inventory count when < 10 units ("Quedan 8").
- Show price breakdown on demand (collapsed by default in list, expanded in detail).
- Order history visible within 2 taps from home.

---

## Flutter Implementation Notes

### Const Widgets
Every static widget must use `const` constructor. Prevents unnecessary rebuilds.

### Rebuild Optimization
Use `ref.watch(provider.select(...))` to select only needed fields from complex state objects. Never `ref.watch(themeProvider)` when you only need `primaryColor`.

### Image Placeholders
Replace `Icon(Icons.inventory_2_outlined, color: Color(0xFFCFD8DC))` with a themed placeholder:
```dart
Icon(Icons.inventory_2_outlined, 
     color: theme.textSecondaryColor.withValues(alpha: 0.35))
```

### GestureDetector vs InkWell
- Use `InkWell` for cards/surfaces where ripple feedback is appropriate
- Use `GestureDetector` only when you need gesture details (swipe, long press)
- Current `_InlineBtn` uses `GestureDetector` — should use `InkWell` or `IconButton` for proper accessibility/ripple

### NavigationBar labelBehavior
```dart
// Change from:
labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
// To:
labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
```
Saves ~20px vertical space on mobile. Important for dense product lists.
