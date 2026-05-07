# Page Override: ProductCard

## Critical Fixes (Priority 1)

### Touch Target Violation
`_AddButton`, `_QtySelector`, and `_InlineBtn` are all **34px height**.
WCAG 2.5.5 requires 44px minimum. Fix:

```dart
// _AddButton: change height 34 → 44
SizedBox(height: 44, child: FilledButton.icon(...))

// _QtySelector: change SizedBox height 34 → 44
SizedBox(height: 44, child: Row(...))

// _InlineBtn: change Container height 34 → 44
Container(height: 44, ...)
```

### Hardcoded Colors → Theme Tokens

```dart
// BEFORE (hardcoded)
color: const Color(0xFF1A1A2E)
color: const Color(0xFFCFD8DC)
color: const Color(0xFFF8F9FB)
color: Colors.white

// AFTER (themed)
color: theme.textPrimaryColor
color: theme.textSecondaryColor.withValues(alpha: 0.35)
color: theme.backgroundColor
color: theme.surfaceColor
```

### GestureDetector → InkWell (FeaturedProductCard)
`FeaturedProductCard` wraps in `GestureDetector`. Loses ripple + accessibility.
Wrap body in `Material` + `InkWell` instead.

## Improvements (Priority 2)

### _AddButton text
"Agregar" → use `TrKeys.addToCart.tr()` (already in translation keys)

### Product name font size
12sp in grid card is too small for scanning. Raise to 13sp.

### Price display
Add subtle "/ und" (per unit) suffix for wholesale clarity:
```
$ 12.500 / und
```

### Cart badge clarity
Current badge shows icon + count. Consider showing count only (larger).
At 11px font, the cart icon at 11px size is nearly invisible.
```dart
// Simplified badge: just the count, cleaner
Container(
  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
  // ... primaryColor background
  child: Text('$qty', style: TextStyle(fontSize: 12, fontWeight: w700, color: white)),
)
```

## "In Cart" Border Alpha
Current: `primaryColor.withValues(alpha: 0.4)` border + `alpha: 0.25` shadow.
Reduce border alpha to 0.35, shadow to 0.18 — less aggressive visual.

## Const Usage
`_ProductImage._placeholder()` creates a new `Icon` on every build. Make const:
```dart
static const Widget _placeholder = Center(
  child: Icon(Icons.inventory_2_outlined, color: Color(0xFFCFD8DC), size: 36),
);
```
