# Page Override: HomePage

## Problems

### Three Identical Horizontal Scroll Sections
"Productos Destacados", "Más Comprados", "Ofertas del Día" use the same
`FeaturedProductCard` in the same layout. Users cannot distinguish sections.

**Fix:** Differentiate visually:
- "Ofertas del Día" → add accent color badge with discount %, darker border
- "Más Comprados" → add subtle "🔥 Popular" label (use Icon, not emoji in production)
- "Destacados" → can stay as-is (default)

OR collapse to 2 sections if data is sparse — empty sections should be hidden, not shown as empty carousels.

### BannerCarousel Height (170px)
Slightly tight. Raise to 190px for better image presentation.
Gradient: current `0xCC1A1A2E` (80% opacity black) is very dark.
Reduce to `0xAA1A1A2E` (~67%) — images still legible, less oppressive.

### Category Section: All Same Primary Color
Category badges all use `primaryColor` background. When there are 10+ categories,
the visual result is a row of identical colored squares.

**Fix:** Use category image as background when available. Fall back to
`primaryColor.withValues(alpha: 0.12)` with primary-colored icon (not filled circle).
This creates texture without relying on images.

### AppBar: Company Badge Opacity
`Colors.white.withValues(alpha: 0.18)` for company badge is nearly invisible on dark AppBar.
Raise to `0.25` or use white border instead of filled background.

## Improvements

### Sticky "Carrito" FAB vs NavigationBar
On mobile, when cart has items, consider showing a persistent bottom sheet
summary (compact: total + item count) above the NavigationBar.
This is standard in high-frequency B2B apps and reduces navigation friction.

### Section Headers
Section titles (e.g., "Destacados", "Más Comprados") need more visual weight.
Current pattern not specified — ensure: titleMedium (17sp, w600), with a
"Ver todos →" link right-aligned. Use `Row(mainAxisAlignment: spaceBetween)`.

### Pull-to-Refresh
Refresh indicator color should use `primaryColor` from theme, not default blue.
```dart
RefreshIndicator(
  color: primaryColor,
  backgroundColor: theme.surfaceColor,
  ...
)
```
