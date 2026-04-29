import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/product_entity.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';

class ProductCard extends ConsumerWidget {
  const ProductCard({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(themeProvider.select((c) => c.locale));
    final primaryColor =
        ref.watch(themeProvider.select((c) => c.theme.primaryColor));
    final qty =
        ref.watch(cartProvider.select((c) => c.quantityOf(product.sku)));

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: qty > 0 ? 3 : 1,
      shadowColor: qty > 0
          ? primaryColor.withValues(alpha: 0.25)
          : Colors.black.withValues(alpha: 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: qty > 0
            ? BorderSide(
                color: primaryColor.withValues(alpha: 0.4), width: 1.5)
            : BorderSide.none,
      ),
      color: Colors.white,
      child: InkWell(
        onTap: () => context.push('/product/${product.sku}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen + badge ───────────────────────────────────────────
            Expanded(
              child: Stack(
                children: [
                  _ProductImage(imageUrl: product.imageUrl),
                  if (qty > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _CartBadge(qty: qty, color: primaryColor),
                    ),
                ],
              ),
            ),

            // ── Nombre + precio ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    CurrencyFormatter.format(product.basePrice, locale),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            // ── Botón / selector de cantidad ─────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: qty == 0
                  ? _AddButton(
                      primaryColor: primaryColor,
                      onTap: () =>
                          ref.read(cartProvider.notifier).addItem(product),
                    )
                  : _QtySelector(
                      qty: qty,
                      primaryColor: primaryColor,
                      onDecrement: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(product.sku, qty - 1),
                      onIncrement: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(product.sku, qty + 1),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Badge de cantidad ─────────────────────────────────────────────────────────

class _CartBadge extends StatelessWidget {
  const _CartBadge({required this.qty, required this.color});
  final int qty;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.shopping_cart, size: 11, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            '$qty',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón "Agregar" ───────────────────────────────────────────────────────────

class _AddButton extends StatelessWidget {
  const _AddButton({required this.primaryColor, required this.onTap});
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 34,
      child: FilledButton.icon(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: primaryColor,
          padding: EdgeInsets.zero,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.add, size: 16, color: Colors.white),
        label: const Text(
          'Agregar',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.white),
        ),
      ),
    );
  }
}

// ── Selector de cantidad inline ───────────────────────────────────────────────

class _QtySelector extends StatelessWidget {
  const _QtySelector({
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
    return SizedBox(
      height: 34,
      child: Row(
        children: [
          Expanded(
            child: _InlineBtn(
              icon: qty == 1 ? Icons.delete_outline : Icons.remove,
              color: qty == 1 ? Colors.red.shade400 : primaryColor,
              onTap: onDecrement,
              isLeft: true,
            ),
          ),
          Container(
            width: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(
                    color: primaryColor.withValues(alpha: 0.25)),
              ),
              color: primaryColor.withValues(alpha: 0.05),
            ),
            child: Text(
              '$qty',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          Expanded(
            child: _InlineBtn(
              icon: Icons.add,
              color: primaryColor,
              onTap: onIncrement,
              isLeft: false,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineBtn extends StatelessWidget {
  const _InlineBtn({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.isLeft,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.horizontal(
            left: isLeft ? const Radius.circular(10) : Radius.zero,
            right: isLeft ? Radius.zero : const Radius.circular(10),
          ),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Icon(icon, size: 15, color: color),
      ),
    );
  }
}

// ── Imagen ────────────────────────────────────────────────────────────────────

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.all(10),
      child: (imageUrl == null || imageUrl!.isEmpty)
          ? _placeholder()
          : CachedNetworkImage(
              imageUrl: imageUrl!,
              fit: BoxFit.contain,
              width: double.infinity,
              placeholder: (_, _) => _placeholder(),
              errorWidget: (_, _, _) => _placeholder(),
            ),
    );
  }

  Widget _placeholder() => const Center(
        child: Icon(Icons.inventory_2_outlined,
            color: Color(0xFFCFD8DC), size: 36),
      );
}

// ── Featured card ─────────────────────────────────────────────────────────────

class FeaturedProductCard extends ConsumerWidget {
  const FeaturedProductCard({super.key, required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(themeProvider.select((c) => c.locale));
    final primaryColor =
        ref.watch(themeProvider.select((c) => c.theme.primaryColor));
    final qty =
        ref.watch(cartProvider.select((c) => c.quantityOf(product.sku)));

    return GestureDetector(
      onTap: () => context.push('/product/${product.sku}'),
      child: Container(
        width: 152,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: qty > 0
                  ? primaryColor.withValues(alpha: 0.2)
                  : Colors.black.withValues(alpha: 0.06),
              blurRadius: qty > 0 ? 10 : 6,
              offset: const Offset(0, 2),
            ),
          ],
          border: qty > 0
              ? Border.all(
                  color: primaryColor.withValues(alpha: 0.4), width: 1.5)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen + badge
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
              child: Stack(
                children: [
                  Container(
                    height: 124,
                    color: const Color(0xFFF8F9FB),
                    padding: const EdgeInsets.all(10),
                    child: (product.imageUrl == null ||
                            product.imageUrl!.isEmpty)
                        ? const Center(
                            child: Icon(Icons.inventory_2_outlined,
                                color: Color(0xFFCFD8DC), size: 40),
                          )
                        : CachedNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            placeholder: (_, _) => const Center(
                              child: Icon(Icons.inventory_2_outlined,
                                  color: Color(0xFFCFD8DC), size: 40),
                            ),
                            errorWidget: (_, _, _) => const Center(
                              child: Icon(Icons.inventory_2_outlined,
                                  color: Color(0xFFCFD8DC), size: 40),
                            ),
                          ),
                  ),
                  if (qty > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: _CartBadge(qty: qty, color: primaryColor),
                    ),
                ],
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1A1A2E),
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      CurrencyFormatter.format(product.basePrice, locale),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
