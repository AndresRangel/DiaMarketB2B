# Page Override: ProductDetailPage

## File Size Warning
1235 lines is too large. Consider splitting:
- `_ProductInfoSection` → own widget file
- `_PriceSection` → own widget file
- `_QuantitySection` → own widget file
- `_RelatedProductsSection` → own widget file

This improves readability and enables const optimization.

## Price Display (Critical B2B)

The current price breakdown is correct for B2B. Maintain it. Improvements:

**Visual hierarchy:** Unit price should be the LARGEST element.
```
Base / und:    $ 12.500      ← 18sp bold, primaryColor (priceDisplay token)
IVA 19%:       + $ 2.375     ← 13sp, warningColor (priceSmall token)
Descuento:     − $ 1.250     ← 13sp, successColor
───────────────────────────
Total / und:   $ 13.625      ← 16sp bold, primaryColor
```

**Collapsed by default on mobile.** Show only "Total / und" with a chevron to expand breakdown.
This cleans up the card without losing information.

## Sticky Bottom Bar

Keep it — it's the right pattern for B2B.
Improvements:
- Show total as LARGE text (24sp bold)
- Add "× N unidades" below total for clarity
- Button: 48px height, full width, primary color

## Toast ("Added to Cart")

Current implementation shows a dark overlay with action button.
Consider: use `ScaffoldMessenger.showSnackBar` with custom styled SnackBar
(themed, primary background, "Ver carrito" action button) instead of overlay.
Overlay pattern works but adds complexity without proportional benefit.

## Related Products Section

**Label:** "También podrías necesitar" or "Productos relacionados"
Cards should be `ProductCard` in compact mode, not `FeaturedProductCard`.
Reason: FeaturedProductCard has no "add to cart" quick action — user must
navigate to another product detail to add. Add inline quantity control to
horizontal related products.

## Transparent AppBar

AppBar with `backgroundColor: Colors.transparent` is correct.
Back button: white icon with semi-transparent circular background:
```dart
CircleAvatar(
  radius: 18,
  backgroundColor: Colors.black.withValues(alpha: 0.35),
  child: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
)
```
This ensures visibility against any image color.
