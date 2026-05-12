import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/shell/shell_key.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_shadows.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
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
      backgroundColor: config.theme.backgroundColor,
      appBar: isDesktop
          ? null
          : _buildAppBar(context, ref, cart, config),
      body: cart.isEmpty
          ? _buildEmptyCart(context, config)
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

  PreferredSizeWidget _buildAppBar(BuildContext context, WidgetRef ref,
      CartEntity cart, RemoteAppConfig config) {
    final primary = config.theme.primaryColor;
    return AppBar(
      backgroundColor: primary,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 22),
        onPressed: () => mainScaffoldKey.currentState?.openDrawer(),
      ),
      title: Row(
        children: [
          Text(
            'Carrito',
            style: AppTextStyles.titleMedium.copyWith(
                color: Colors.white, fontWeight: FontWeight.w700),
          ),
          if (cart.itemCount > 0) ...[
            const SizedBox(width: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '${cart.itemCount} uds.',
                style: AppTextStyles.labelSmall.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!cart.isEmpty)
          TextButton.icon(
            onPressed: () => confirmClearCart(context, ref),
            icon: const Icon(Icons.delete_outline,
                color: Colors.white70, size: 18),
            label: Text('Vaciar',
                style: AppTextStyles.labelMedium
                    .copyWith(color: Colors.white70)),
          ),
        const SizedBox(width: AppSpacing.xs),
      ],
    );
  }

  Widget _buildEmptyCart(BuildContext context, RemoteAppConfig config) {
    final primary = config.theme.primaryColor;
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      message: 'Tu carrito está vacío',
      subtitle: 'Agrega productos desde el catálogo para comenzar tu pedido.',
      action: FilledButton.icon(
        onPressed: () => context.go('/home'),
        icon: const Icon(Icons.storefront_outlined, size: 18),
        label: const Text('Ir al catálogo'),
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}

void confirmClearCart(BuildContext context, WidgetRef ref) {
  showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Vaciar carrito'),
      content: const Text(
          '¿Seguro que quieres eliminar todos los productos del carrito?'),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancelar')),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text('Vaciar',
              style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  ).then((confirmed) {
    if (confirmed == true && context.mounted) {
      ref.read(cartProvider.notifier).clear();
    }
  });
}

// ── Desktop: dos columnas ─────────────────────────────────────────────────────

class _CartDesktopLayout extends ConsumerWidget {
  const _CartDesktopLayout({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primary = config.theme.primaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Lista de ítems (60%) ──────────────────────────────────────
        Expanded(
          flex: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.base, AppSpacing.base, AppSpacing.sm, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cart.items.length} ${cart.items.length == 1 ? 'producto' : 'productos'}',
                      style: AppTextStyles.labelMedium.copyWith(
                          color: config.theme.textSecondaryColor),
                    ),
                    TextButton.icon(
                      onPressed: () => confirmClearCart(context, ref),
                      icon: Icon(Icons.delete_outline,
                          size: 16, color: config.theme.errorColor),
                      label: Text('Vaciar carrito',
                          style: AppTextStyles.labelMedium.copyWith(
                              color: config.theme.errorColor)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.base,
                      AppSpacing.sm, AppSpacing.sm, AppSpacing.xl),
                  itemCount: cart.items.length,
                  itemBuilder: (_, i) => _CartItemCard(
                    item: cart.items[i],
                    config: config,
                    isDesktop: true,
                  ),
                ),
              ),
            ],
          ),
        ),

        // ── Resumen sticky (40%) ──────────────────────────────────────
        SizedBox(
          width: 360,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.sm,
                AppSpacing.base, AppSpacing.base, AppSpacing.xl),
            child: _OrderSummaryCard(
                cart: cart, config: config, primary: primary),
          ),
        ),
      ],
    );
  }
}

// ── Mobile: lista + sticky bar ────────────────────────────────────────────────

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
            padding: const EdgeInsets.fromLTRB(AppSpacing.md,
                AppSpacing.md, AppSpacing.md, AppSpacing.sm),
            itemCount: cart.items.length,
            itemBuilder: (_, i) {
              final item = cart.items[i];
              return _SwipableCartItem(
                key: ValueKey(item.sku),
                item: item,
                config: config,
                onDismissed: () =>
                    ref.read(cartProvider.notifier).removeItem(item.sku),
              );
            },
          ),
        ),
        _MobileSummaryBar(cart: cart, config: config),
      ],
    );
  }
}

// ── Swipe-to-delete wrapper (mobile only) ─────────────────────────────────────

class _SwipableCartItem extends StatelessWidget {
  const _SwipableCartItem({
    super.key,
    required this.item,
    required this.config,
    required this.onDismissed,
  });

  final CartItemEntity item;
  final RemoteAppConfig config;
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.sku),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.red.shade600,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline, color: Colors.white, size: 24),
            const SizedBox(height: 4),
            Text(
              'Eliminar',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      child: _CartItemCard(item: item, config: config, isDesktop: false),
    );
  }
}

// ── Tarjeta de ítem ───────────────────────────────────────────────────────────

class _CartItemCard extends ConsumerStatefulWidget {
  const _CartItemCard({
    required this.item,
    required this.config,
    required this.isDesktop,
  });

  final CartItemEntity item;
  final RemoteAppConfig config;
  final bool isDesktop;

  @override
  ConsumerState<_CartItemCard> createState() => _CartItemCardState();
}

class _CartItemCardState extends ConsumerState<_CartItemCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final locale = widget.config.locale;
    final primary = widget.config.theme.primaryColor;
    final surface = widget.config.theme.surfaceColor;
    final textPrimary = widget.config.theme.textPrimaryColor;
    final textSecondary = widget.config.theme.textSecondaryColor;
    final imageSize = widget.isDesktop ? 96.0 : 80.0;
    final hasDiscount = widget.item.discount > 0;

    return MouseRegion(
      cursor: SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: _hovered
                ? primary.withValues(alpha: 0.20)
                : textSecondary.withValues(alpha: 0.08),
          ),
          boxShadow: _hovered ? AppShadows.level2 : AppShadows.level1,
        ),
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Imagen ────────────────────────────────────────────────
            Stack(
              children: [
                Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    color: widget.config.theme.backgroundColor,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                        color: textSecondary.withValues(alpha: 0.10)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: (widget.item.imageUrl != null &&
                            widget.item.imageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: widget.item.imageUrl!,
                            fit: BoxFit.contain,
                            placeholder: (_, _) => Icon(
                                Icons.inventory_2_outlined,
                                color: textSecondary.withValues(alpha: 0.3),
                                size: 28),
                            errorWidget: (_, _, _) => Icon(
                                Icons.inventory_2_outlined,
                                color: textSecondary.withValues(alpha: 0.3),
                                size: 28),
                          )
                        : Icon(Icons.inventory_2_outlined,
                            color: textSecondary.withValues(alpha: 0.3),
                            size: 28),
                  ),
                ),
                // Badge de descuento sobre la imagen
                if (hasDiscount)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.shade600,
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                      ),
                      child: Text(
                        '-${(widget.item.discount * 100).round()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: AppSpacing.md),

            // ── Info + qty selector ───────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SKU
                  Text(
                    widget.item.sku,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: textSecondary.withValues(alpha: 0.6),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // Nombre
                  Text(
                    widget.item.name,
                    style: AppTextStyles.productName.copyWith(
                      color: textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  // Precios: si hay descuento → tachado + final
                  if (hasDiscount) ...[
                    Row(
                      children: [
                        Text(
                          CurrencyFormatter.format(
                              widget.item.basePrice +
                                  widget.item.taxAmount +
                                  widget.item.icoAmount,
                              locale),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: textSecondary.withValues(alpha: 0.5),
                            decoration: TextDecoration.lineThrough,
                            decorationColor: textSecondary.withValues(alpha: 0.5),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          CurrencyFormatter.format(
                              widget.item.unitFinalPrice, locale),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: Colors.red.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    // Ahorro por unidad
                    Text(
                      'Ahorras ${CurrencyFormatter.format(widget.item.discountAmount, locale)} c/u',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: widget.config.theme.successColor,
                        fontSize: 10,
                      ),
                    ),
                  ] else
                    Text(
                      CurrencyFormatter.format(
                          widget.item.unitFinalPrice, locale),
                      style: AppTextStyles.labelMedium.copyWith(
                          color: textSecondary),
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  // Qty selector
                  _QtySelector(
                    qty: widget.item.quantity,
                    primaryColor: primary,
                    onDecrement: () {
                      if (widget.item.quantity == 1) {
                        ref
                            .read(cartProvider.notifier)
                            .removeItem(widget.item.sku);
                      } else {
                        ref.read(cartProvider.notifier).updateQuantity(
                            widget.item.sku, widget.item.quantity - 1);
                      }
                    },
                    onIncrement: () => ref
                        .read(cartProvider.notifier)
                        .updateQuantity(
                            widget.item.sku, widget.item.quantity + 1),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // ── Total de línea ────────────────────────────────────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  CurrencyFormatter.format(widget.item.lineTotal, locale),
                  style: AppTextStyles.priceMedium.copyWith(
                      color: textPrimary),
                ),
                if (widget.item.quantity > 1)
                  Text(
                    '${widget.item.quantity} uds.',
                    style: AppTextStyles.labelSmall.copyWith(
                        color: textSecondary),
                  ),
                if (hasDiscount && widget.item.quantity > 1) ...[
                  const SizedBox(height: 2),
                  Text(
                    '− ${CurrencyFormatter.format(widget.item.lineDiscountTotal, locale)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: widget.config.theme.successColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Selector cantidad — touch target 44px ────────────────────────────────────

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
    final isDelete = qty == 1;
    final decrementColor = isDelete ? Colors.red.shade400 : primaryColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyBtn(
          icon: isDelete ? Icons.delete_outline : Icons.remove,
          color: decrementColor,
          onTap: onDecrement,
        ),
        SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: Text(
              '$qty',
              style: AppTextStyles.titleSmall.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        _QtyBtn(
          icon: Icons.add,
          color: primaryColor,
          onTap: onIncrement,
        ),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(color: color.withValues(alpha: 0.30)),
        ),
        child: Icon(icon, size: 18, color: color),
      ),
    );
  }
}

// ── Resumen del pedido — desktop ──────────────────────────────────────────────

class _OrderSummaryCard extends StatelessWidget {
  const _OrderSummaryCard({
    required this.cart,
    required this.config,
    required this.primary,
  });

  final CartEntity cart;
  final RemoteAppConfig config;
  final Color primary;

  @override
  Widget build(BuildContext context) {
    final locale = config.locale;
    final textPrimary = config.theme.textPrimaryColor;
    final textSecondary = config.theme.textSecondaryColor;

    return Container(
      decoration: BoxDecoration(
        color: config.theme.surfaceColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
            color: textSecondary.withValues(alpha: 0.10)),
        boxShadow: AppShadows.level1,
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Resumen del pedido',
            style: AppTextStyles.titleSmall.copyWith(color: textPrimary),
          ),
          const SizedBox(height: AppSpacing.base),

          _SummaryRow(
            label: 'Subtotal (${cart.items.length} productos)',
            value: CurrencyFormatter.format(cart.totalBruto, locale),
            textSecondary: textSecondary,
            textPrimary: textPrimary,
          ),
          const SizedBox(height: AppSpacing.sm),
          _SummaryRow(
            label: 'IVA',
            value: '+ ${CurrencyFormatter.format(cart.totalIVA, locale)}',
            textSecondary: textSecondary,
            valueColor: config.theme.warningColor,
          ),
          if (cart.totalICO > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Imp. Consumo (ICO)',
              value:
                  '+ ${CurrencyFormatter.format(cart.totalICO, locale)}',
              textSecondary: textSecondary,
              valueColor: config.theme.warningColor,
            ),
          ],
          if (cart.totalProductDiscounts > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Descuentos',
              value:
                  '− ${CurrencyFormatter.format(cart.totalProductDiscounts, locale)}',
              textSecondary: textSecondary,
              valueColor: config.theme.successColor,
            ),
          ],
          if (cart.couponDiscount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _SummaryRow(
              label: 'Cupón ${cart.couponCode ?? ""}',
              value:
                  '− ${CurrencyFormatter.format(cart.couponDiscount, locale)}',
              textSecondary: textSecondary,
              valueColor: config.theme.successColor,
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: textSecondary.withValues(alpha: 0.12)),
          const SizedBox(height: AppSpacing.md),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',
                  style: AppTextStyles.titleSmall.copyWith(
                      color: textPrimary)),
              Text(
                CurrencyFormatter.format(cart.totalOrden, locale),
                style:
                    AppTextStyles.priceDisplay.copyWith(color: primary),
              ),
            ],
          ),

          // Ahorro total si hay descuentos
          if (cart.totalDescuentos > 0) ...[
            const SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: 3),
                  decoration: BoxDecoration(
                    color: config.theme.successColor.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    'Ahorrás ${CurrencyFormatter.format(cart.totalDescuentos, locale)}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: config.theme.successColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],

          const SizedBox(height: AppSpacing.base),
          AppButton(
            label: 'Finalizar pedido',
            onPressed: () {}, // TODO Fase 3 Bloque 6
            isFullWidth: true,
          ),
          const SizedBox(height: AppSpacing.sm),
          Center(
            child: Text(
              '${cart.itemCount} unidades en el carrito',
              style: AppTextStyles.labelSmall.copyWith(
                  color: textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Barra resumen mobile (sticky bottom) expandible ───────────────────────────

class _MobileSummaryBar extends StatefulWidget {
  const _MobileSummaryBar({required this.cart, required this.config});

  final CartEntity cart;
  final RemoteAppConfig config;

  @override
  State<_MobileSummaryBar> createState() => _MobileSummaryBarState();
}

class _MobileSummaryBarState extends State<_MobileSummaryBar> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final locale = widget.config.locale;
    final primary = widget.config.theme.primaryColor;
    final textSecondary = widget.config.theme.textSecondaryColor;
    final textPrimary = widget.config.theme.textPrimaryColor;
    final bottom = MediaQuery.of(context).padding.bottom;
    final cart = widget.cart;
    final config = widget.config;

    return Container(
      decoration: BoxDecoration(
        color: config.theme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Toggle para expandir desglose ─────────────────────────
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Ver desglose',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 4),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(Icons.expand_less_rounded,
                            size: 16, color: primary),
                      ),
                    ],
                  ),
                  if (cart.totalDescuentos > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xs + 2, vertical: 2),
                      decoration: BoxDecoration(
                        color: config.theme.successColor
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        'Ahorrás ${CurrencyFormatter.format(cart.totalDescuentos, locale)}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: config.theme.successColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Desglose expandible ────────────────────────────────────
          AnimatedSize(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: _expanded
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.base, AppSpacing.sm,
                        AppSpacing.base, 0),
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value: CurrencyFormatter.format(
                              cart.totalBruto, locale),
                          textSecondary: textSecondary,
                          textPrimary: textPrimary,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        _SummaryRow(
                          label: 'IVA',
                          value: '+ ${CurrencyFormatter.format(cart.totalIVA, locale)}',
                          textSecondary: textSecondary,
                          valueColor: config.theme.warningColor,
                        ),
                        if (cart.totalICO > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _SummaryRow(
                            label: 'ICO',
                            value: '+ ${CurrencyFormatter.format(cart.totalICO, locale)}',
                            textSecondary: textSecondary,
                            valueColor: config.theme.warningColor,
                          ),
                        ],
                        if (cart.totalProductDiscounts > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _SummaryRow(
                            label: 'Descuentos',
                            value: '− ${CurrencyFormatter.format(cart.totalProductDiscounts, locale)}',
                            textSecondary: textSecondary,
                            valueColor: config.theme.successColor,
                          ),
                        ],
                        if (cart.couponDiscount > 0) ...[
                          const SizedBox(height: AppSpacing.xs),
                          _SummaryRow(
                            label: 'Cupón ${cart.couponCode ?? ""}',
                            value: '− ${CurrencyFormatter.format(cart.couponDiscount, locale)}',
                            textSecondary: textSecondary,
                            valueColor: config.theme.successColor,
                          ),
                        ],
                        const SizedBox(height: AppSpacing.sm),
                        Divider(
                            height: 1,
                            color: textSecondary.withValues(alpha: 0.12)),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // ── Total + botón ──────────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm,
                AppSpacing.base, AppSpacing.md + bottom),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cart.itemCount} uds.',
                      style: AppTextStyles.labelSmall
                          .copyWith(color: textSecondary),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Total  ',
                            style: AppTextStyles.labelMedium.copyWith(
                                color: textSecondary),
                          ),
                          TextSpan(
                            text: CurrencyFormatter.format(
                                cart.totalOrden, locale),
                            style: AppTextStyles.priceDisplay.copyWith(
                                color: primary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Finalizar pedido',
                  onPressed: () {}, // TODO Fase 3 Bloque 6
                  isFullWidth: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Fila de resumen ───────────────────────────────────────────────────────────

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    required this.textSecondary,
    this.textPrimary,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color textSecondary;
  final Color? textPrimary;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: AppTextStyles.bodyMedium.copyWith(
                color: textSecondary)),
        Text(
          value,
          style: AppTextStyles.priceSmall.copyWith(
            color: valueColor ?? textPrimary ?? textSecondary,
          ),
        ),
      ],
    );
  }
}
