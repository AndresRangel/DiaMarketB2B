import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../notifiers/cart_notifier.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final config = ref.watch(themeProvider);
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: isDesktop ? null : _buildAppBar(context, cart, config.theme.primaryColor),
      body: cart.isEmpty
          ? _buildEmptyCart(config.theme.primaryColor)
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: isDesktop ? 1400 : double.infinity),
                child: isDesktop
                    ? _CartDesktopLayout(cart: cart, config: config)
                    : _CartMobileLayout(cart: cart, config: config),
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      BuildContext context, CartEntity cart, Color primaryColor) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text(
            'Carrito',
            style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          if (cart.itemCount > 0) ...[
            const SizedBox(width: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${cart.itemCount} ${cart.itemCount == 1 ? 'unidad' : 'unidades'}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!cart.isEmpty)
          TextButton.icon(
            onPressed: () => _confirmClear(context),
            icon: const Icon(Icons.delete_outline,
                color: Colors.white70, size: 18),
            label: const Text('Vaciar',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildEmptyCart(Color primaryColor) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      message: 'Tu carrito está vacío',
      subtitle: 'Agrega productos desde el catálogo para comenzar tu pedido.',
    );
  }

  void _confirmClear(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Vaciar carrito'),
        content: const Text(
            '¿Seguro que quieres eliminar todos los productos del carrito?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Vaciar',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        ProviderScope.containerOf(context)
            .read(cartProvider.notifier)
            .clear();
      }
    });
  }
}

// ── Desktop: dos columnas ─────────────────────────────────────────────────────

class _CartDesktopLayout extends ConsumerWidget {
  const _CartDesktopLayout({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Columna izquierda: lista de ítems (60%) ───────────────────
        Expanded(
          flex: 6,
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 24),
            itemCount: cart.items.length,
            itemBuilder: (_, i) => _CartItemCard(
              item: cart.items[i],
              locale: config.locale,
              primaryColor: config.theme.primaryColor,
              isDesktop: true,
            ),
          ),
        ),

        // ── Columna derecha: resumen sticky (40%) ─────────────────────
        SizedBox(
          width: 380,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 16, 16, 24),
            child: _OrderSummaryCard(cart: cart, config: config),
          ),
        ),
      ],
    );
  }
}

// ── Mobile: lista + botón sticky ─────────────────────────────────────────────

class _CartMobileLayout extends ConsumerWidget {
  const _CartMobileLayout({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            itemCount: cart.items.length,
            itemBuilder: (_, i) => _CartItemCard(
              item: cart.items[i],
              locale: config.locale,
              primaryColor: config.theme.primaryColor,
              isDesktop: false,
            ),
          ),
        ),
        _MobileSummaryBar(cart: cart, config: config),
      ],
    );
  }
}

// ── Tarjeta de ítem ───────────────────────────────────────────────────────────

class _CartItemCard extends ConsumerWidget {
  const _CartItemCard({
    required this.item,
    required this.locale,
    required this.primaryColor,
    required this.isDesktop,
  });

  final CartItemEntity item;
  final LocaleConfig locale;
  final Color primaryColor;
  final bool isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final imageSize = isDesktop ? 80.0 : 68.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen
          Container(
            width: imageSize,
            height: imageSize,
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FB),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFEEEEEE)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: (item.imageUrl != null && item.imageUrl!.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: item.imageUrl!,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFFCFD8DC),
                          size: 28),
                      errorWidget: (_, _, _) => const Icon(
                          Icons.inventory_2_outlined,
                          color: Color(0xFFCFD8DC),
                          size: 28),
                    )
                  : const Icon(Icons.inventory_2_outlined,
                      color: Color(0xFFCFD8DC), size: 28),
            ),
          ),

          const SizedBox(width: 12),

          // Info + qty
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  CurrencyFormatter.format(item.unitFinalPrice, locale),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 10),
                // Qty selector
                Row(
                  children: [
                    _QtyButton(
                      icon: item.quantity == 1
                          ? Icons.delete_outline
                          : Icons.remove,
                      color: item.quantity == 1
                          ? Colors.red.shade400
                          : primaryColor,
                      onTap: () {
                        if (item.quantity == 1) {
                          ref
                              .read(cartProvider.notifier)
                              .removeItem(item.sku);
                        } else {
                          ref.read(cartProvider.notifier).updateQuantity(
                              item.sku, item.quantity - 1);
                        }
                      },
                    ),
                    Container(
                      width: 44,
                      alignment: Alignment.center,
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ),
                    _QtyButton(
                      icon: Icons.add,
                      color: primaryColor,
                      onTap: () => ref
                          .read(cartProvider.notifier)
                          .updateQuantity(item.sku, item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Total línea
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                CurrencyFormatter.format(item.lineTotal, locale),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              if (item.quantity > 1)
                Text(
                  '${item.quantity} uds.',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF9E9E9E)),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Botón de cantidad ─────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

// ── Resumen del pedido (desktop card) ─────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context) {
    final locale = config.locale;
    final primary = config.theme.primaryColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen del pedido',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 16),
          _SummaryRow(
            label: 'Subtotal (${cart.items.length} productos)',
            value: CurrencyFormatter.format(cart.totalBruto, locale),
          ),
          const SizedBox(height: 10),
          _SummaryRow(
            label: 'IVA',
            value: '+ ${CurrencyFormatter.format(cart.totalIVA, locale)}',
            valueColor: const Color(0xFFE65100),
          ),
          // ICO — solo se muestra si algún producto lo tiene
          if (cart.totalICO > 0) ...[
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Imp. Consumo (ICO)',
              value: '+ ${CurrencyFormatter.format(cart.totalICO, locale)}',
              valueColor: const Color(0xFFE65100),
            ),
          ],
          // Descuentos de producto
          if (cart.totalProductDiscounts > 0) ...[
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Descuentos',
              value: '− ${CurrencyFormatter.format(cart.totalProductDiscounts, locale)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],
          // Descuento de cupón (Fase 4)
          if (cart.couponDiscount > 0) ...[
            const SizedBox(height: 10),
            _SummaryRow(
              label: 'Cupón ${cart.couponCode ?? ""}',
              value: '− ${CurrencyFormatter.format(cart.couponDiscount, locale)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],
          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                CurrencyFormatter.format(cart.totalOrden, locale),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppButton(
            label: 'Finalizar pedido',
            onPressed: () {}, // TODO Bloque 6
            isFullWidth: true,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              '${cart.itemCount} unidades en el carrito',
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF9E9E9E)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Barra de resumen móvil (sticky bottom) ────────────────────────────────────

class _MobileSummaryBar extends StatelessWidget {
  const _MobileSummaryBar({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context) {
    final locale = config.locale;
    final primary = config.theme.primaryColor;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottom),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Subtotal rápido
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'IVA incluido',
                style: TextStyle(
                    fontSize: 11, color: Colors.grey.shade500),
              ),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Total ',
                      style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF666666)),
                    ),
                    TextSpan(
                      text: CurrencyFormatter.format(
                          cart.totalOrden, locale),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          AppButton(
            label: 'Finalizar pedido',
            onPressed: () {}, // TODO Bloque 6
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13, color: Color(0xFF666666))),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}
