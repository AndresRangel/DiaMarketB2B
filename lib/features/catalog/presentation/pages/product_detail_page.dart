import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/nav.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_shadows.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../domain/entities/product_entity.dart';
import '../notifiers/catalog_notifier.dart';
import '../notifiers/product_detail_notifier.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';

class ProductDetailPage extends ConsumerWidget {
  const ProductDetailPage({
    super.key,
    required this.sku,
    this.isSheet = false,
    this.scrollController,
  });

  final String sku;
  final bool isSheet;
  final ScrollController? scrollController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productDetailProvider(sku));
    final config = ref.watch(themeProvider);

    return productAsync.when(
      loading: () => const _ProductDetailSkeleton(),
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
        return _ProductDetailScreen(
            product: product, config: config, ref: ref,
            isSheet: isSheet, scrollController: scrollController);
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
    this.isSheet = false,
    this.scrollController,
  });

  final ProductEntity product;
  final RemoteAppConfig config;
  final WidgetRef ref;
  final bool isSheet;
  final ScrollController? scrollController;

  @override
  State<_ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<_ProductDetailScreen> {
  int _quantity = 1;

  ProductEntity get product => widget.product;
  RemoteAppConfig get config => widget.config;
  Color get primary => config.theme.primaryColor;
  Color get textPrimary => config.theme.textPrimaryColor;
  Color get textSecondary => config.theme.textSecondaryColor;
  Color get surface => config.theme.surfaceColor;
  Color get background => config.theme.backgroundColor;
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
    _showToast(context, '$_quantity × ${product.name} agregado al carrito');
  }

  void _showToast(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => _CartToast(
        message: message,
        primaryColor: primary,
        successColor: config.theme.successColor,
        surfaceColor: surface,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
        isDesktop: isDesktop,
        bottomPad: bottomPad,
        onViewCart: () {
          entry.remove();
          if (widget.isSheet) {
            final nav = Navigator.of(context);
            nav.pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (nav.context.mounted) {
                nav.context.go('/cart');
              }
            });
          } else {
            context.go('/cart');
          }
        },
        onDismiss: () => entry.remove(),
      ),
    );

    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = widget.ref.read(catalogProvider);
    String? categoryName;
    List<ProductEntity> related = [];

    if (catalogAsync.hasValue) {
      final catalog = catalogAsync.value!;
      categoryName = catalog.categories
          .where((c) => c.id == product.categoryId)
          .map((c) => c.name.split(' - ').first.trim())
          .firstOrNull;

      final sameCategory = catalog.products
          .where((p) =>
              p.sku != product.sku && p.categoryId == product.categoryId)
          .take(10)
          .toList();

      related = [...sameCategory];
      if (related.length < 6) {
        final others = catalog.products
            .where((p) =>
                p.sku != product.sku &&
                p.categoryId != product.categoryId)
            .take(10 - related.length)
            .toList();
        related.addAll(others);
      }
    }

    final isDesktop =
        MediaQuery.sizeOf(context).width >= Breakpoints.tablet;
    if (isDesktop) return _buildDesktopLayout(context, categoryName, related);
    if (widget.isSheet) return _buildSheetLayout(context, categoryName, related);
    return _buildMobileLayout(context, categoryName, related);
  }

  // ── Desktop: dos columnas ─────────────────────────────────────────────────

  Widget _buildDesktopLayout(
    BuildContext context,
    String? categoryName,
    List<ProductEntity> related,
  ) {
    return Scaffold(
      backgroundColor: background,
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
          style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Columna izquierda: imagen ────────────────────────
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: background,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        boxShadow: AppShadows.level1,
                      ),
                      padding: const EdgeInsets.all(AppSpacing.xxl),
                      height: 420,
                      child: _buildImage(),
                    ),
                  ),

                  const SizedBox(width: AppSpacing.xl),

                  // ── Columna derecha: info + precio + cantidad + botón ──
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _desktopCard(_buildInfoContent(categoryName)),
                        const SizedBox(height: AppSpacing.md),
                        _desktopCard(_buildPriceContent()),
                        const SizedBox(height: AppSpacing.md),
                        _desktopCard(_buildQuantityContent()),
                        const SizedBox(height: AppSpacing.md),
                        Builder(
                            builder: (ctx) => _buildDesktopAddButton(ctx)),
                        if (related.isNotEmpty) ...[
                          const SizedBox(height: AppSpacing.md),
                          _buildRelatedSection(related, categoryName),
                        ],
                        const SizedBox(height: AppSpacing.xl),
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

  Widget _buildDesktopAddButton(BuildContext innerContext) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.level1,
      ),
      padding: const EdgeInsets.all(AppSpacing.base),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style: AppTextStyles.labelSmall.copyWith(
                    color: textSecondary),
              ),
              Text(
                CurrencyFormatter.format(_total, locale),
                style: AppTextStyles.displayLarge.copyWith(color: primary),
              ),
            ],
          ),
          const SizedBox(width: AppSpacing.base),
          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => _addToCart(innerContext),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md)),
                ),
                icon: const Icon(Icons.add_shopping_cart_outlined,
                    color: Colors.white),
                label: Text(
                  'Agregar al carrito',
                  style: AppTextStyles.titleSmall.copyWith(
                      color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Mobile: layout principal ──────────────────────────────────────────────

  Widget _buildMobileLayout(
    BuildContext context,
    String? categoryName,
    List<ProductEntity> related,
  ) {
    return Scaffold(
      backgroundColor: background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Imagen sobre fondo gris — contraste con el sheet blanco
            _buildImageSection(),

            // Sheet blanco con bordes redondeados y sombra hacia arriba.
            // El contraste image(gris)/sheet(blanco) + sombra crea el efecto
            // de sheet flotando sobre la imagen sin necesitar margin negativo.
            Container(
              decoration: BoxDecoration(
                color: surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.xl),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: _buildMobileContent(categoryName, related),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (innerContext) => _buildStickyBar(innerContext),
      ),
    );
  }

  // ── Sheet layout (bottom sheet) ──────────────────────────────────────────
  // Sin Scaffold: Scaffold dentro de showModalBottomSheet bloquea drag-to-dismiss.
  // Estructura: ClipRRect → Column([Expanded(scroll)] + [stickyBar])

  Widget _buildSheetLayout(
    BuildContext context,
    String? categoryName,
    List<ProductEntity> related,
  ) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.xl)),
      child: Container(
        color: surface,
        child: Column(
          children: [
            // Handle visual — el drag lo maneja DraggableScrollableSheet
            // via el scrollController que recibimos de nav.dart.
            Container(
              color: background,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              child: Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: textSecondary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
            ),

            // scrollController conecta el scroll del contenido con el drag
            // del sheet: al llegar al tope y seguir jalando, el sheet baja.
            Expanded(
              child: SingleChildScrollView(
                controller: widget.scrollController,
                physics: const ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Stack(
                      children: [
                        _buildSheetImageSection(),
                        Positioned(
                          top: AppSpacing.xs,
                          right: AppSpacing.sm,
                          child: _CloseButton(
                              onClose: () => Navigator.of(context).pop()),
                        ),
                      ],
                    ),
                    Container(
                      color: surface,
                      child: _buildMobileContent(categoryName, related,
                          showHandle: true),
                    ),
                  ],
                ),
              ),
            ),
            Builder(builder: (ctx) => _buildStickyBar(ctx)),
          ],
        ),
      ),
    );
  }

  // ── Contenido del sheet mobile ────────────────────────────────────────────

  Widget _buildMobileContent(
      String? categoryName, List<ProductEntity> related,
      {bool showHandle = false}) {
    final divider = Divider(
      height: 1,
      indent: AppSpacing.base,
      endIndent: AppSpacing.base,
      color: textSecondary.withValues(alpha: 0.1),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Drag handle — solo en sheet, no en página completa
        if (showHandle)
          Center(
            child: Container(
              width: 32,
              height: 3,
              margin: const EdgeInsets.only(top: AppSpacing.sm),
              decoration: BoxDecoration(
                color: textSecondary.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),

        // ── Nombre + chips ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.base),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: AppTextStyles.titleLarge.copyWith(
                  color: textPrimary,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs + 2,
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
                    color: textSecondary,
                    outlined: true,
                    outlinedBorderColor: textSecondary.withValues(alpha: 0.3),
                  ),
                  if (product.isActive)
                    _InfoChip(
                      icon: Icons.check_circle_outline,
                      label: 'Disponible',
                      color: config.theme.successColor,
                    ),
                ],
              ),
            ],
          ),
        ),

        divider,

        // ── Precio ───────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: _buildPriceContent(),
        ),

        divider,

        // ── Cantidad ─────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(AppSpacing.base),
          child: _buildQuantityContent(),
        ),

        // ── Relacionados ─────────────────────────────────────────────
        if (related.isNotEmpty) ...[
          divider,
          _buildRelatedContent(related, categoryName),
        ],

        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }

  // ── AppBar transparente ───────────────────────────────────────────────────

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: CircleAvatar(
          backgroundColor: Colors.black.withValues(alpha: 0.35),
          radius: 18,
          child: IconButton(
            icon: Icon(Icons.arrow_back_ios_new,
                size: 16, color: Colors.white),
            onPressed: () => context.pop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: CircleAvatar(
            backgroundColor: Colors.black.withValues(alpha: 0.35),
            radius: 18,
            child: const Icon(Icons.share_outlined,
                size: 18, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // ── Imagen ────────────────────────────────────────────────────────────────

  Widget _buildImageSection() {
    return Stack(
      children: [
        Container(
          height: 300,
          color: background,
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl, 80, AppSpacing.xl, AppSpacing.xl),
          child: _buildImage(),
        ),
        if (product.discount > 0)
          Positioned(
            bottom: AppSpacing.base,
            left: AppSpacing.base,
            child: _DiscountBadge(discount: product.discount),
          ),
      ],
    );
  }

  // Sheet: sin padding top de AppBar, imagen centrada
  Widget _buildSheetImageSection() {
    return Stack(
      children: [
        Container(
          height: 240,
          width: double.infinity,
          color: background,
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(child: _buildImage()),
        ),
        if (product.discount > 0)
          Positioned(
            bottom: AppSpacing.base,
            left: AppSpacing.base,
            child: _DiscountBadge(discount: product.discount),
          ),
      ],
    );
  }

  Widget _buildImage() {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.contain,
        placeholder: (_, _) =>
            ShimmerBox(height: double.infinity, radius: AppRadius.md),
        errorWidget: (_, _, _) => _imagePlaceholder(),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() => Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 80,
          color: textSecondary.withValues(alpha: 0.35),
        ),
      );

  // ── Price content (sin card wrapper) ────────────────────────────────────

  Widget _buildPriceContent() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRECIO',
            style: AppTextStyles.labelSmall.copyWith(
              color: textSecondary,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          _PriceRow(
            label: 'Precio base',
            value: CurrencyFormatter.format(product.basePrice, locale),
            labelColor: textSecondary,
            valueColor: textPrimary,
          ),

          if (product.taxRate > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _PriceRow(
              label: 'IVA ${(product.taxRate * 100).toStringAsFixed(0)}%',
              value: '+ ${CurrencyFormatter.format(product.taxAmount, locale)}',
              labelColor: textSecondary,
              valueColor: config.theme.warningColor,
            ),
          ],

          if (product.icoAmount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _PriceRow(
              label: 'Imp. Consumo (ICO)',
              value: '+ ${CurrencyFormatter.format(product.icoAmount, locale)}',
              labelColor: textSecondary,
              valueColor: config.theme.warningColor,
            ),
          ],

          if (product.discount > 0) ...[
            const SizedBox(height: AppSpacing.sm),
            _PriceRow(
              label:
                  'Descuento ${(product.discount * 100).toStringAsFixed(0)}%',
              value:
                  '− ${CurrencyFormatter.format(product.discountAmount, locale)}',
              labelColor: textSecondary,
              valueColor: config.theme.successColor,
            ),
          ],

          const SizedBox(height: AppSpacing.md),
          Divider(height: 1, color: textSecondary.withValues(alpha: 0.15)),
          const SizedBox(height: AppSpacing.md),

          // Precio final — elemento más prominente
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Precio final / unidad',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                CurrencyFormatter.format(product.finalPrice, locale),
                style: AppTextStyles.priceDisplay.copyWith(color: primary),
              ),
            ],
          ),
        ],
      );
  }

  // ── Quantity content (sin card wrapper) ───────────────────────────────────

  Widget _buildQuantityContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CANTIDAD',
          style: AppTextStyles.labelSmall.copyWith(
            color: textSecondary,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _QuantityButton(
              icon: Icons.remove,
              onTap: _decrement,
              enabled: _quantity > 1,
              color: primary,
            ),
            Container(
              width: 56,
              height: 44,
              alignment: Alignment.center,
              child: Text(
                '$_quantity',
                style: AppTextStyles.titleMedium.copyWith(color: textPrimary),
              ),
            ),
            _QuantityButton(
              icon: Icons.add,
              onTap: _increment,
              enabled: true,
              color: primary,
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '$_quantity × ${CurrencyFormatter.format(_unitPrice, locale)}',
                  style: AppTextStyles.labelSmall.copyWith(color: textSecondary),
                ),
                const SizedBox(height: 2),
                Text(
                  CurrencyFormatter.format(_total, locale),
                  style: AppTextStyles.priceMedium.copyWith(color: primary),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  // ── Helper: envuelve contenido en card (usado en desktop) ─────────────────

  Widget _desktopCard(Widget child) => Container(
        decoration: BoxDecoration(
          color: surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: AppShadows.level1,
        ),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: child,
      );

  Widget _buildInfoContent(String? categoryName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(product.name,
            style: AppTextStyles.titleLarge.copyWith(color: textPrimary)),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs + 2,
          children: [
            if (categoryName != null)
              _InfoChip(icon: Icons.category_outlined, label: categoryName, color: primary),
            _InfoChip(
              icon: Icons.qr_code_outlined,
              label: 'SKU: ${product.sku}',
              color: textSecondary,
              outlined: true,
              outlinedBorderColor: textSecondary.withValues(alpha: 0.3),
            ),
            if (product.isActive)
              _InfoChip(
                icon: Icons.check_circle_outline,
                label: 'Disponible',
                color: config.theme.successColor,
              ),
            if (product.discount > 0)
              _InfoChip(
                icon: Icons.local_offer_outlined,
                label: '-${(product.discount * 100).round()}% descuento',
                color: Colors.red.shade600,
              ),
          ],
        ),
      ],
    );
  }

  // ── Related content (mobile — sin card wrapper) ──────────────────────────

  Widget _buildRelatedContent(
      List<ProductEntity> products, String? categoryName) {
    final isRelated =
        products.any((p) => p.categoryId == product.categoryId);
    final title = isRelated && categoryName != null
        ? 'Más de $categoryName'
        : 'También te puede interesar';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.base, AppSpacing.base, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style:
                      AppTextStyles.titleSmall.copyWith(color: textPrimary)),
              Text('${products.length} productos',
                  style: AppTextStyles.labelSmall
                      .copyWith(color: textSecondary)),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
            itemBuilder: (_, i) => _RelatedProductCard(
              product: products[i],
              locale: locale,
              primaryColor: primary,
              backgroundColor: background,
              textPrimaryColor: textPrimary,
              textSecondaryColor: textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  // ── Related products (desktop — con card wrapper) ─────────────────────────

  Widget _buildRelatedSection(
      List<ProductEntity> products, String? categoryName) {
    final isRelated =
        products.any((p) => p.categoryId == product.categoryId);
    final title = isRelated && categoryName != null
        ? 'Más de $categoryName'
        : 'También te puede interesar';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: AppShadows.level1,
      ),
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.base, 0, AppSpacing.base),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.base),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                      color: textPrimary),
                ),
                Text(
                  '${products.length} productos',
                  style: AppTextStyles.labelSmall.copyWith(
                      color: textSecondary),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              padding:
                  const EdgeInsets.only(right: AppSpacing.base),
              itemBuilder: (_, i) => _RelatedProductCard(
                product: products[i],
                locale: locale,
                primaryColor: primary,
                backgroundColor: background,
                textPrimaryColor: textPrimary,
                textSecondaryColor: textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Sticky bar ────────────────────────────────────────────────────────────

  Widget _buildStickyBar(BuildContext innerContext) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.base,
        AppSpacing.md,
        AppSpacing.base,
        AppSpacing.md + MediaQuery.of(innerContext).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total',
                style:
                    AppTextStyles.labelSmall.copyWith(color: textSecondary),
              ),
              Text(
                CurrencyFormatter.format(_total, locale),
                style: AppTextStyles.priceDisplay.copyWith(color: primary),
              ),
            ],
          ),

          const SizedBox(width: AppSpacing.base),

          Expanded(
            child: SizedBox(
              height: 48,
              child: FilledButton.icon(
                onPressed: () => _addToCart(innerContext),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                icon: const Icon(Icons.add_shopping_cart_outlined,
                    color: Colors.white),
                label: Text(
                  'Agregar al carrito',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: Colors.white,
                    fontSize: 15,
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

class _RelatedProductCard extends StatefulWidget {
  const _RelatedProductCard({
    required this.product,
    required this.locale,
    required this.primaryColor,
    required this.backgroundColor,
    required this.textPrimaryColor,
    required this.textSecondaryColor,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primaryColor;
  final Color backgroundColor;
  final Color textPrimaryColor;
  final Color textSecondaryColor;

  @override
  State<_RelatedProductCard> createState() => _RelatedProductCardState();
}

class _RelatedProductCardState extends State<_RelatedProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.openProductDetail(widget.product.sku),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: 140,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hovered
                  ? widget.primaryColor.withValues(alpha: 0.3)
                  : widget.textSecondaryColor.withValues(alpha: 0.12),
            ),
            boxShadow: _hovered
                ? AppShadows.level3(widget.primaryColor)
                : AppShadows.none,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.md)),
                child: SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: (widget.product.imageUrl != null &&
                          widget.product.imageUrl!.isNotEmpty)
                      ? CachedNetworkImage(
                          imageUrl: widget.product.imageUrl!,
                          fit: BoxFit.contain,
                          placeholder: (_, _) => ShimmerBox(
                              height: 120, radius: 0),
                          errorWidget: (_, _, _) => Center(
                            child: Icon(
                              Icons.inventory_2_outlined,
                              color: widget.textSecondaryColor
                                  .withValues(alpha: 0.35),
                              size: 36,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: widget.textSecondaryColor
                                .withValues(alpha: 0.35),
                            size: 36,
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm,
                      AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.product.name,
                        style: AppTextStyles.productNameSmall.copyWith(
                            color: widget.textPrimaryColor),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        CurrencyFormatter.format(
                            widget.product.basePrice, widget.locale),
                        style: AppTextStyles.priceSmall.copyWith(
                            color: widget.primaryColor),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Widgets auxiliares ────────────────────────────────────────────────────────

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.discount});
  final double discount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.red.shade600,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        boxShadow: AppShadows.level2,
      ),
      child: Text(
        '-${(discount * 100).round()}%',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.label,
    required this.color,
    this.outlined = false,
    this.outlinedBorderColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool outlined;
  final Color? outlinedBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs + 1),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(
          color: outlined
              ? (outlinedBorderColor ?? color.withValues(alpha: 0.3))
              : color.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
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
    required this.labelColor,
    required this.valueColor,
  });

  final String label;
  final String value;
  final Color labelColor;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(color: labelColor),
        ),
        Text(
          value,
          style:
              AppTextStyles.priceSmall.copyWith(color: valueColor),
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
    return InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: enabled
              ? color.withValues(alpha: 0.10)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(AppRadius.sm),
          border: Border.all(
            color: enabled
                ? color.withValues(alpha: 0.30)
                : Colors.grey.shade200,
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

class _ProductDetailSkeleton extends ConsumerWidget {
  const _ProductDetailSkeleton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final bg = theme.theme.backgroundColor;
    final surface = theme.theme.surfaceColor;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            Container(
              height: 300,
              color: bg,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xxl, 80, AppSpacing.xxl, AppSpacing.xxl),
              child: const ShimmerBox(
                  height: double.infinity, radius: AppRadius.md),
            ),

            const SizedBox(height: AppSpacing.md),

            _skeletonCard(
              surface: surface,
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(children: [
                    ShimmerBox(height: 26, width: 90, radius: AppRadius.full),
                    SizedBox(width: AppSpacing.sm),
                    ShimmerBox(height: 26, width: 110, radius: AppRadius.full),
                  ]),
                  SizedBox(height: AppSpacing.md),
                  ShimmerBox(height: 22, width: double.infinity),
                  SizedBox(height: AppSpacing.sm),
                  ShimmerBox(height: 22, width: 200),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            _skeletonCard(
              surface: surface,
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerBox(height: 12, width: 60),
                  SizedBox(height: AppSpacing.md),
                  _SkeletonPriceRow(),
                  SizedBox(height: AppSpacing.sm),
                  _SkeletonPriceRow(),
                  SizedBox(height: AppSpacing.md),
                  Divider(height: 1),
                  SizedBox(height: AppSpacing.md),
                  _SkeletonPriceRow(valueWidth: 100),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            _skeletonCard(
              surface: surface,
              padding: const EdgeInsets.all(AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ShimmerBox(height: 12, width: 70),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: const [
                      ShimmerBox(height: 44, width: 44, radius: AppRadius.sm),
                      SizedBox(width: AppSpacing.base),
                      ShimmerBox(height: 24, width: 40),
                      SizedBox(width: AppSpacing.base),
                      ShimmerBox(height: 44, width: 44, radius: AppRadius.sm),
                      Spacer(),
                      ShimmerBox(height: 36, width: 90),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            _skeletonCard(
              surface: surface,
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.base, AppSpacing.base, 0, AppSpacing.base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: AppSpacing.base),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(height: 14, width: 160),
                        ShimmerBox(height: 12, width: 80),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 210,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      padding:
                          const EdgeInsets.only(right: AppSpacing.base),
                      itemBuilder: (_, _) => const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ShimmerBox(
                              height: 120,
                              width: 140,
                              radius: AppRadius.md),
                          SizedBox(height: AppSpacing.sm),
                          ShimmerBox(height: 11, width: 120),
                          SizedBox(height: AppSpacing.xs),
                          ShimmerBox(height: 11, width: 90),
                          SizedBox(height: AppSpacing.sm),
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
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xl),
        color: surface,
        child: Row(
          children: const [
            ShimmerBox(height: 44, width: 90),
            SizedBox(width: AppSpacing.base),
            Expanded(child: ShimmerBox(height: 48, radius: AppRadius.md)),
          ],
        ),
      ),
    );
  }

  static Widget _skeletonCard({
    required Color surface,
    required Widget child,
    required EdgeInsets padding,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
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

// ── Toast animado "agregado al carrito" ───────────────────────────────────────
// Mobile: slide-up desde abajo, ancho completo con padding.
// Desktop: slide-up en esquina inferior derecha, ancho fijo 360px.

class _CartToast extends StatefulWidget {
  const _CartToast({
    required this.message,
    required this.primaryColor,
    required this.successColor,
    required this.surfaceColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.isDesktop,
    required this.bottomPad,
    required this.onViewCart,
    required this.onDismiss,
  });

  final String message;
  final Color primaryColor;
  final Color successColor;
  final Color surfaceColor;
  final Color textPrimary;
  final Color textSecondary;
  final bool isDesktop;
  final double bottomPad;
  final VoidCallback onViewCart;
  final VoidCallback onDismiss;

  @override
  State<_CartToast> createState() => _CartToastState();
}

class _CartToastState extends State<_CartToast>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _progressController;
  late Animation<double> _fade;
  late Animation<double> _progress;

  static const _duration = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _progressController = AnimationController(
      vsync: this,
      duration: _duration,
    );

    _fade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _progress = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.linear),
    );

    _controller.forward();
    _progressController.forward();

    Future.delayed(_duration, () {
      if (mounted) _dismiss();
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomOffset = widget.bottomPad + (widget.isDesktop ? 24.0 : 80.0);

    return Positioned(
      bottom: bottomOffset,
      left: widget.isDesktop ? null : AppSpacing.md,
      right: AppSpacing.md,
      width: widget.isDesktop ? 360 : null,
      child: FadeTransition(
        opacity: _fade,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
          ),
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: widget.surfaceColor,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: AppShadows.level4,
                border: Border.all(
                  color: widget.successColor.withValues(alpha: 0.20),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Contenido principal ─────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md, AppSpacing.md,
                        AppSpacing.sm, AppSpacing.md),
                    child: Row(
                      children: [
                        // Ícono carrito en círculo success
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: widget.successColor.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: widget.successColor,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),

                        // Texto
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Agregado al carrito',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: widget.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.message,
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: widget.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Botón "Ver carrito"
                        TextButton(
                          onPressed: widget.onViewCart,
                          style: TextButton.styleFrom(
                            foregroundColor: widget.primaryColor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sm,
                                vertical: AppSpacing.xs),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            'Ver',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: widget.primaryColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        // Botón cerrar
                        GestureDetector(
                          onTap: _dismiss,
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            child: Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: widget.textSecondary
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Barra de progreso de auto-dismiss ───────────────
                  AnimatedBuilder(
                    animation: _progress,
                    builder: (_, _) => LinearProgressIndicator(
                      value: _progress.value,
                      minHeight: 3,
                      backgroundColor:
                          widget.successColor.withValues(alpha: 0.10),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.successColor.withValues(alpha: 0.60),
                      ),
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

// ── Botón cerrar sheet ────────────────────────────────────────────────────────

class _CloseButton extends StatelessWidget {
  const _CloseButton({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClose,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close_rounded, size: 18, color: Colors.white),
      ),
    );
  }
}
