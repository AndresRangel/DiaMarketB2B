import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/nav.dart';

import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_shadows.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';

// ── ProductCard — grid (desktop) y secciones con botón opcional ───────────────

class ProductCard extends ConsumerStatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.showAddButton = true,
  });

  final ProductEntity product;
  final bool showAddButton;

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(themeProvider.select((c) => c.locale));
    final theme = ref.watch(themeProvider);
    final primary = theme.theme.primaryColor;
    final qty = ref.watch(
        cartProvider.select((c) => c.quantityOf(widget.product.sku)));
    final inCart = qty > 0;
    final product = widget.product;
    final hasDiscount = product.discount > 0;

    final activeShadow = inCart || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: theme.theme.surfaceColor,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: activeShadow
                ? primary.withValues(alpha: 0.30)
                : theme.theme.textSecondaryColor.withValues(alpha: 0.10),
            width: activeShadow ? 1.5 : 1,
          ),
          boxShadow: activeShadow
              ? AppShadows.level3(primary)
              : AppShadows.level1,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => context.openProductDetail(product.sku),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Imagen ──────────────────────────────────────────────
                  Expanded(
                    flex: 6,
                    child: Stack(
                      children: [
                        _ProductImage(
                          imageUrl: product.imageUrl,
                          backgroundColor: theme.theme.surfaceColor,
                          placeholderColor: theme.theme.textSecondaryColor
                              .withValues(alpha: 0.25),
                        ),
                        if (hasDiscount)
                          Positioned(
                            top: AppSpacing.sm,
                            left: AppSpacing.sm,
                            child: _DiscountBadge(discount: product.discount),
                          ),
                        if (inCart)
                          Positioned(
                            top: AppSpacing.sm,
                            right: AppSpacing.sm,
                            child: _CartBadge(qty: qty, color: primary),
                          ),
                      ],
                    ),
                  ),

                  Container(
                    height: 1,
                    color: theme.theme.textSecondaryColor
                        .withValues(alpha: 0.07),
                  ),

                  // ── Info ─────────────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Nombre
                        Text(
                          product.name,
                          style: AppTextStyles.productName.copyWith(
                            color: theme.theme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        // SKU — referencia clave en B2B
                        Text(
                          product.sku,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: theme.theme.textSecondaryColor
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),

                        // Precio
                        _PriceDisplay(
                          product: product,
                          locale: locale,
                          primary: primary,
                          textSecondary: theme.theme.textSecondaryColor,
                          successColor: theme.theme.successColor,
                        ),

                        if (widget.showAddButton) ...[
                          const SizedBox(height: AppSpacing.xs),
                          if (qty == 0)
                            _AddBtn(
                              primaryColor: primary,
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .addItem(product),
                            )
                          else
                            _FullQtySelector(
                              qty: qty,
                              primaryColor: primary,
                              onDecrement: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(product.sku, qty - 1),
                              onIncrement: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(product.sku, qty + 1),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── FeaturedProductCard — scroll horizontal en HomePage (mobile) ──────────────

class FeaturedProductCard extends ConsumerStatefulWidget {
  const FeaturedProductCard({
    super.key,
    required this.product,
    this.showAddButton = true,
  });

  final ProductEntity product;
  final bool showAddButton;

  @override
  ConsumerState<FeaturedProductCard> createState() =>
      _FeaturedProductCardState();
}

class _FeaturedProductCardState extends ConsumerState<FeaturedProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(themeProvider.select((c) => c.locale));
    final theme = ref.watch(themeProvider);
    final primary = theme.theme.primaryColor;
    final qty = ref.watch(
        cartProvider.select((c) => c.quantityOf(widget.product.sku)));
    final inCart = qty > 0;
    final product = widget.product;
    final hasDiscount = product.discount > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.openProductDetail(product.sku),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 152,
          decoration: BoxDecoration(
            color: theme.theme.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: (inCart || _hovered)
                  ? primary.withValues(alpha: 0.30)
                  : theme.theme.textSecondaryColor.withValues(alpha: 0.10),
              width: (inCart || _hovered) ? 1.5 : 1,
            ),
            boxShadow: (inCart || _hovered)
                ? AppShadows.level3(primary)
                : AppShadows.level1,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagen
                Stack(
                  children: [
                    Container(
                      height: 112,
                      color: theme.theme.surfaceColor,
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: (product.imageUrl == null ||
                              product.imageUrl!.isEmpty)
                          ? Center(
                              child: Icon(
                                Icons.inventory_2_outlined,
                                color: theme.theme.textSecondaryColor
                                    .withValues(alpha: 0.25),
                                size: 40,
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: product.imageUrl!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              placeholder: (_, _) => Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: theme.theme.textSecondaryColor
                                      .withValues(alpha: 0.25),
                                  size: 40,
                                ),
                              ),
                              errorWidget: (_, _, _) => Center(
                                child: Icon(
                                  Icons.inventory_2_outlined,
                                  color: theme.theme.textSecondaryColor
                                      .withValues(alpha: 0.25),
                                  size: 40,
                                ),
                              ),
                            ),
                    ),
                    if (hasDiscount)
                      Positioned(
                        top: AppSpacing.xs,
                        left: AppSpacing.xs,
                        child: _DiscountBadge(
                            discount: product.discount, compact: true),
                      ),
                    if (inCart)
                      Positioned(
                        top: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: _CartBadge(qty: qty, color: primary),
                      ),
                  ],
                ),

                Container(
                  height: 1,
                  color:
                      theme.theme.textSecondaryColor.withValues(alpha: 0.07),
                ),

                // Info
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          style: AppTextStyles.productNameSmall.copyWith(
                            color: theme.theme.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          product.sku,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: theme.theme.textSecondaryColor
                                .withValues(alpha: 0.55),
                            fontSize: 10,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _PriceDisplay(
                          product: product,
                          locale: locale,
                          primary: primary,
                          textSecondary: theme.theme.textSecondaryColor,
                          successColor: theme.theme.successColor,
                          compact: true,
                        ),
                        if (widget.showAddButton) ...[
                          const SizedBox(height: AppSpacing.xs),
                          if (qty == 0)
                            _AddBtn(
                              primaryColor: primary,
                              onTap: () => ref
                                  .read(cartProvider.notifier)
                                  .addItem(product),
                            )
                          else
                            _FullQtySelector(
                              qty: qty,
                              primaryColor: primary,
                              onDecrement: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(product.sku, qty - 1),
                              onIncrement: () => ref
                                  .read(cartProvider.notifier)
                                  .updateQuantity(product.sku, qty + 1),
                            ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Precio con lógica de descuento e IVA ─────────────────────────────────────

class _PriceDisplay extends StatelessWidget {
  const _PriceDisplay({
    required this.product,
    required this.locale,
    required this.primary,
    required this.textSecondary,
    required this.successColor,
    this.compact = false,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primary;
  final Color textSecondary;
  final Color successColor;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discount > 0;
    final hasIva = product.taxRate > 0;
    final discountedBase = product.basePrice - product.discountAmount;

    if (hasDiscount) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Precio original tachado
          Text(
            CurrencyFormatter.format(product.basePrice, locale),
            style: (compact
                    ? AppTextStyles.labelSmall
                    : AppTextStyles.bodyMedium)
                .copyWith(
              color: textSecondary.withValues(alpha: 0.5),
              decoration: TextDecoration.lineThrough,
              decorationColor: textSecondary.withValues(alpha: 0.5),
            ),
          ),
          // Precio con descuento + IVA tag
          Row(
            children: [
              Text(
                CurrencyFormatter.format(discountedBase, locale),
                style: (compact
                        ? AppTextStyles.priceSmall
                        : AppTextStyles.priceMedium)
                    .copyWith(
                  color: successColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (hasIva) ...[
                const SizedBox(width: 4),
                _IvaTag(
                    taxRate: product.taxRate, textSecondary: textSecondary),
              ],
            ],
          ),
        ],
      );
    }

    // Sin descuento
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          CurrencyFormatter.format(product.basePrice, locale),
          style:
              (compact ? AppTextStyles.priceSmall : AppTextStyles.priceMedium)
                  .copyWith(
            color: primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        if (hasIva) ...[
          const SizedBox(width: 4),
          _IvaTag(taxRate: product.taxRate, textSecondary: textSecondary),
        ],
      ],
    );
  }
}

// ── Tag IVA sutil ─────────────────────────────────────────────────────────────

class _IvaTag extends StatelessWidget {
  const _IvaTag({required this.taxRate, required this.textSecondary});
  final double taxRate;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    final label = '+IVA ${(taxRate * 100).round()}%';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: textSecondary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: textSecondary.withValues(alpha: 0.65),
          fontSize: 9,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Badge descuento en imagen ─────────────────────────────────────────────────

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount, this.compact = false});
  final double discount;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final label = '-${(discount * 100).round()}%';
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 4 : AppSpacing.sm,
        vertical: compact ? 2 : AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE53935),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: compact ? 9 : 11,
        ),
      ),
    );
  }
}

// ── Badge cantidad en carrito ─────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.qty, required this.color});
  final int qty;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.full),
        boxShadow: AppShadows.level3(color),
      ),
      child: Text(
        '$qty',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ── Botón "Agregar" full-width ────────────────────────────────────────────────

class _AddBtn extends StatelessWidget {
  const _AddBtn({required this.primaryColor, required this.onTap});
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_shopping_cart_outlined,
                size: 14, color: Colors.white),
            const SizedBox(width: AppSpacing.xs),
            Text(
              'Agregar',
              style: AppTextStyles.labelMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Selector cantidad full-width ──────────────────────────────────────────────

class _FullQtySelector extends StatelessWidget {
  const _FullQtySelector({
    required this.qty,
    required this.primaryColor,
    required this.onDecrement,
    required this.onIncrement,
  });

  final int qty;
  final Color primaryColor;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.sm),
        color: primaryColor.withValues(alpha: 0.08),
        border: Border.all(color: primaryColor.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onDecrement,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Icon(
                  qty == 1 ? Icons.delete_outline : Icons.remove,
                  size: 16,
                  color: qty == 1 ? Colors.red.shade400 : primaryColor,
                ),
              ),
            ),
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            child: Text(
              '$qty',
              style: AppTextStyles.labelLarge.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onIncrement,
              behavior: HitTestBehavior.opaque,
              child: Center(
                child: Icon(Icons.add, size: 16, color: primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Imagen del producto ───────────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    this.imageUrl,
    required this.backgroundColor,
    required this.placeholderColor,
  });

  final String? imageUrl;
  final Color backgroundColor;
  final Color placeholderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? _Placeholder(color: placeholderColor)
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.contain,
              width: double.infinity,
              placeholder: (_, _) => _Placeholder(color: placeholderColor),
              errorWidget: (_, _, _) => _Placeholder(color: placeholderColor),
            ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Icon(Icons.inventory_2_outlined, color: color, size: 36),
    );
  }
}
