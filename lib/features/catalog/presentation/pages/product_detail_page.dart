import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../domain/entities/product_entity.dart';
import '../notifiers/catalog_notifier.dart';
import '../notifiers/product_detail_notifier.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({super.key, required this.sku});

  final String sku;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(sku));
    final config = ref.watch(themeProvider);

    return productAsync.when(
      loading: () => _ProductDetailSkeleton(primaryColor: config.theme.primaryColor),
      error: (error, _) => Scaffold(
        appBar: AppBar(),
        body: AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.invalidate(productDetailProvider(sku)),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Producto no encontrado')),
          );
        }
        return _ProductDetailScreen(product: product, config: config, ref: ref);
      },
    );
  }
}

// ── Pantalla principal ────────────────────────────────────────────────────────

class _ProductDetailScreen extends StatefulWidget {
  const _ProductDetailScreen({
    required this.product,
    required this.config,
    required this.ref,
  });

  final ProductEntity product;
  final RemoteAppConfig config;
  final WidgetRef ref;

  @override
  State<_ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<_ProductDetailScreen> {
  int _quantity = 1;

  ProductEntity get product => widget.product;
  RemoteAppConfig get config => widget.config;
  Color get primary => config.theme.primaryColor;
  LocaleConfig get locale => config.locale;

  double get _unitPrice => product.finalPrice;
  double get _total => _unitPrice * _quantity;

  void _increment() => setState(() => _quantity++);
  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  void _addToCart(BuildContext context) {
    widget.ref
        .read(cartProvider.notifier)
        .addItemWithQuantity(product, _quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_quantity × ${product.name} agregado al carrito',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        duration: const Duration(microseconds: 500),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Ver carrito',
          onPressed: () => context.go('/cart'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Datos desde catálogo en cache (no hace request adicional)
    final catalogAsync = widget.ref.read(catalogProvider);
    String? categoryName;
    List<ProductEntity> related = [];

    if (catalogAsync.hasValue) {
      final catalog = catalogAsync.value!;

      categoryName = catalog.categories
          .where((c) => c.id == product.categoryId)
          .map((c) => c.name.split(' - ').first.trim())
          .firstOrNull;

      // Productos relacionados: misma categoría primero, luego relleno con otros
      final sameCategory = catalog.products
          .where((p) => p.sku != product.sku && p.categoryId == product.categoryId)
          .take(10)
          .toList();

      related = [...sameCategory];

      if (related.length < 6) {
        final others = catalog.products
            .where((p) => p.sku != product.sku && p.categoryId != product.categoryId)
            .take(10 - related.length)
            .toList();
        related.addAll(others);
      }
    }

    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    if (isDesktop) return _buildDesktopLayout(context, categoryName, related);
    return _buildMobileLayout(context, categoryName, related);
  }

  // ── Desktop: dos columnas ─────────────────────────────────────────────────

  Widget _buildDesktopLayout(
    BuildContext context,
    String? categoryName,
    List<ProductEntity> related,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(
          product.name,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Columna izquierda: imagen ─────────────────────────
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(32),
                      height: 420,
                      child: (product.imageUrl != null &&
                              product.imageUrl!.isNotEmpty)
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl!,
                              fit: BoxFit.contain,
                              placeholder: (_, _) => const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                              errorWidget: (_, _, _) => _imagePlaceholder(),
                            )
                          : _imagePlaceholder(),
                    ),
                  ),

                  const SizedBox(width: 24),

                  // ── Columna derecha: info + precio + cantidad + botón ──
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildInfoCard(categoryName),
                        const SizedBox(height: 12),
                        _buildPriceCard(),
                        const SizedBox(height: 12),
                        _buildQuantityCard(),
                        const SizedBox(height: 12),
                        _buildDesktopAddButton(),
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          _buildRelatedSection(related, categoryName),
                        ],
                        const SizedBox(height: 24),
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

  Widget _buildDesktopAddButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
              Text(
                CurrencyFormatter.format(_total, locale),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => _addToCart(context),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_shopping_cart_outlined,
                    color: Colors.white),
                label: const Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile: layout original ───────────────────────────────────────────────

  Widget _buildMobileLayout(
    BuildContext context,
    String? categoryName,
    List<ProductEntity> related,
  ) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildImageSection()),
          SliverToBoxAdapter(child: _buildInfoCard(categoryName)),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(child: _buildPriceCard()),
          const SliverToBoxAdapter(child: SizedBox(height: 10)),
          SliverToBoxAdapter(child: _buildQuantityCard()),
          if (related.isNotEmpty) ...[
            const SliverToBoxAdapter(child: SizedBox(height: 10)),
            SliverToBoxAdapter(child: _buildRelatedSection(related, categoryName)),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
      bottomNavigationBar: _buildStickyBar(),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: const Color(0xFF1A1A2E),
      leading: Padding(
        padding: const EdgeInsets.all(8),
        child: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: 0.92),
          radius: 18,
          child: IconButton(
          icon: Icon(Icons.arrow_back, size: 20, color: Color(0xFF1A1A2E)),
          onPressed: () => context.pop(),
        ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.92),
            radius: 18,
            child: const Icon(Icons.share_outlined, size: 20, color: Color(0xFF1A1A2E)),
          ),
        ),
      ],
    );
  }

  // ── Imagen ────────────────────────────────────────────────────────────────

  Widget _buildImageSection() {
    return Container(
      height: 300,
      color: const Color(0xFFF8F9FB),
      padding: const EdgeInsets.fromLTRB(24, 80, 24, 24),
      child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
          ? CachedNetworkImage(
              imageUrl: product.imageUrl!,
              fit: BoxFit.contain,
              placeholder: (_, _) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (_, _, _) => _imagePlaceholder(),
            )
          : _imagePlaceholder(),
    );
  }

  Widget _imagePlaceholder() => Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 80,
          color: Colors.grey.shade300,
        ),
      );

  // ── Info card ─────────────────────────────────────────────────────────────

  Widget _buildInfoCard(String? categoryName) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Chips: categoría + SKU
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (categoryName != null)
                _InfoChip(
                  icon: Icons.category_outlined,
                  label: categoryName,
                  color: primary,
                ),
              _InfoChip(
                icon: Icons.qr_code_outlined,
                label: 'SKU: ${product.sku}',
                color: Colors.grey.shade600,
                outlined: true,
              ),
              if (product.isActive)
                _InfoChip(
                  icon: Icons.check_circle_outline,
                  label: 'Disponible',
                  color: const Color(0xFF2E7D32),
                ),
            ],
          ),
          const SizedBox(height: 14),

          // Nombre del producto
          Text(
            product.name,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  // ── Price card ────────────────────────────────────────────────────────────

  Widget _buildPriceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Precio',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Precio base
          _PriceRow(
            label: 'Precio base',
            value: CurrencyFormatter.format(product.basePrice, locale),
          ),

          // IVA (si aplica)
          if (product.taxRate > 0) ...[
            const SizedBox(height: 10),
            _PriceRow(
              label: 'IVA ${(product.taxRate * 100).toStringAsFixed(0)}%',
              value: '+ ${CurrencyFormatter.format(product.taxAmount, locale)}',
              valueColor: const Color(0xFFE65100),
            ),
          ],

          // ICO — Impuesto al Consumo (licores)
          if (product.icoAmount > 0) ...[
            const SizedBox(height: 10),
            _PriceRow(
              label: 'Imp. Consumo (ICO)',
              value: '+ ${CurrencyFormatter.format(product.icoAmount, locale)}',
              valueColor: const Color(0xFFE65100),
            ),
          ],

          // Descuento de producto
          if (product.discount > 0) ...[
            const SizedBox(height: 10),
            _PriceRow(
              label: 'Descuento ${(product.discount * 100).toStringAsFixed(0)}%',
              value: '− ${CurrencyFormatter.format(product.discountAmount, locale)}',
              valueColor: const Color(0xFF2E7D32),
            ),
          ],

          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Precio final
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Precio final / unidad',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              Text(
                CurrencyFormatter.format(product.finalPrice, locale),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quantity card ─────────────────────────────────────────────────────────

  Widget _buildQuantityCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cantidad',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9E9E9E),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 14),

          Row(
            children: [
              // Selector  -  número  +
              _QuantityButton(
                icon: Icons.remove,
                onTap: _decrement,
                enabled: _quantity > 1,
                color: primary,
              ),
              Container(
                width: 56,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  '$_quantity',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ),
              _QuantityButton(
                icon: Icons.add,
                onTap: _increment,
                enabled: true,
                color: primary,
              ),

              const Spacer(),

              // Subtotal
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '$_quantity × ${CurrencyFormatter.format(_unitPrice, locale)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.format(_total, locale),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Related products ──────────────────────────────────────────────────────

  Widget _buildRelatedSection(List<ProductEntity> products, String? categoryName) {
    final isRelated = products.any((p) => p.categoryId == product.categoryId);
    final title = isRelated && categoryName != null
        ? 'Más de $categoryName'
        : 'También te puede interesar';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    letterSpacing: 0.1,
                  ),
                ),
                Text(
                  '${products.length} productos',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Carousel horizontal
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              padding: const EdgeInsets.only(right: 16),
              itemBuilder: (_, i) => _RelatedProductCard(
                product: products[i],
                locale: locale,
                primaryColor: primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sticky bar ────────────────────────────────────────────────────────────

  Widget _buildStickyBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12 + MediaQuery.of(context).padding.bottom,
      ),
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
      child: Row(
        children: [
          // Total
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              Text(
                CurrencyFormatter.format(_total, locale),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(width: 16),

          // Botón agregar
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => _addToCart(context),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(
                  Icons.add_shopping_cart_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  'Agregar al carrito',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Related product card ──────────────────────────────────────────────────────

class _RelatedProductCard extends StatelessWidget {
  const _RelatedProductCard({
    required this.product,
    required this.locale,
    required this.primaryColor,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Reemplaza la ruta actual → navega al nuevo producto
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => ProductDetailPage(sku: product.sku),
          ),
        );
      },
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 120,
                width: double.infinity,
                child: (product.imageUrl != null && product.imageUrl!.isNotEmpty)
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => const Center(
                          child: Icon(Icons.inventory_2_outlined,
                              color: Color(0xFFCFD8DC), size: 36),
                        ),
                        errorWidget: (_, _, _) => const Center(
                          child: Icon(Icons.inventory_2_outlined,
                              color: Color(0xFFCFD8DC), size: 36),
                        ),
                      )
                    : const Center(
                        child: Icon(Icons.inventory_2_outlined,
                            color: Color(0xFFCFD8DC), size: 36),
                      ),
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

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    this.outlined = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: outlined ? Colors.grey.shade300 : color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: outlined ? Colors.grey.shade700 : color,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
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
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Color(0xFF666666)),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? const Color(0xFF1A1A2E),
          ),
        ),
      ],
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({
    required this.icon,
    required this.onTap,
    required this.enabled,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: enabled ? color.withValues(alpha: 0.1) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: enabled ? color.withValues(alpha: 0.3) : Colors.grey.shade200,
          ),
        ),
        child: Icon(
          icon,
          size: 20,
          color: enabled ? color : Colors.grey.shade400,
        ),
      ),
    );
  }
}

// ── Skeleton de carga ─────────────────────────────────────────────────────────

class _ProductDetailSkeleton extends StatelessWidget {
  const _ProductDetailSkeleton({required this.primaryColor});

  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 300,
              color: const Color(0xFFF8F9FB),
              padding: const EdgeInsets.fromLTRB(48, 80, 48, 32),
              child: const ShimmerBox(height: double.infinity, radius: 12),
            ),

            const SizedBox(height: 12),

            // Info card skeleton
            _skeletonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      ShimmerBox(height: 26, width: 90, radius: 13),
                      SizedBox(width: 8),
                      ShimmerBox(height: 26, width: 110, radius: 13),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const ShimmerBox(height: 22, width: double.infinity),
                  const SizedBox(height: 8),
                  const ShimmerBox(height: 22, width: 200),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Price card skeleton
            _skeletonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(height: 14, width: 60),
                  SizedBox(height: 14),
                  _SkeletonPriceRow(),
                  SizedBox(height: 10),
                  _SkeletonPriceRow(),
                  SizedBox(height: 14),
                  Divider(height: 1),
                  SizedBox(height: 14),
                  _SkeletonPriceRow(valueWidth: 100),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Quantity card skeleton
            _skeletonCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(height: 14, width: 70),
                  const SizedBox(height: 14),
                  Row(
                    children: const [
                      ShimmerBox(height: 40, width: 40, radius: 10),
                      SizedBox(width: 16),
                      ShimmerBox(height: 24, width: 40),
                      SizedBox(width: 16),
                      ShimmerBox(height: 40, width: 40, radius: 10),
                      Spacer(),
                      ShimmerBox(height: 36, width: 90),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Related products skeleton
            _skeletonCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(height: 14, width: 160),
                        ShimmerBox(height: 12, width: 80),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 210,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      padding: const EdgeInsets.only(right: 16),
                      itemBuilder: (_, _) => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(height: 120, width: 140, radius: 12),
                          SizedBox(height: 8),
                          ShimmerBox(height: 11, width: 120),
                          SizedBox(height: 4),
                          ShimmerBox(height: 11, width: 90),
                          SizedBox(height: 8),
                          ShimmerBox(height: 14, width: 70),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        color: Colors.white,
        child: Row(
          children: const [
            ShimmerBox(height: 44, width: 90),
            SizedBox(width: 16),
            Expanded(child: ShimmerBox(height: 48, radius: 12)),
          ],
        ),
      ),
    );
  }

  Widget _skeletonCard({required Widget child, required EdgeInsets padding}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: padding,
      child: child,
    );
  }
}

class _SkeletonPriceRow extends StatelessWidget {
  const _SkeletonPriceRow({this.valueWidth = 70});

  final double valueWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const ShimmerBox(height: 14, width: 120),
        ShimmerBox(height: 14, width: valueWidth),
      ],
    );
  }
}
