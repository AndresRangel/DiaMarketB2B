import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/utils/nav.dart';

import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/shell/shell_key.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_shadows.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../auth/domain/entities/auth_session_entity.dart';
import '../../../auth/presentation/notifiers/auth_notifier.dart';
import '../../../auth/presentation/notifiers/auth_state.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/product_entity.dart';
import '../notifiers/catalog_notifier.dart';
import '../widgets/banner_carousel.dart';
import '../widgets/home_skeleton.dart';
import '../widgets/product_card.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogState = ref.watch(catalogProvider);
    final config = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    final session =
        authState is AuthStateAuthenticated ? authState.session : null;
    final primary = config.theme.primaryColor;

    return Scaffold(
      backgroundColor: config.theme.backgroundColor,
      appBar: context.isDesktop
          ? null
          : _HomeAppBar(config: config, session: session),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.catalogMaxWidth),
          child: catalogState.when(
            loading: () => const HomeSkeleton(),
            error: (e, _) => AppErrorWidget(
              message: e.toString(),
              onRetry: () => ref.read(catalogProvider.notifier).refresh(),
            ),
            data: (catalog) {
              final rootCategories =
                  catalog.categories.where((c) => c.isRoot).toList();
              final featured = catalog.products.take(10).toList();
              final mostPurchased =
                  catalog.products.skip(10).take(10).toList();
              final offers = catalog.products
                  .where((p) => p.discount > 0)
                  .take(12)
                  .toList();

              return RefreshIndicator(
                color: primary,
                backgroundColor: config.theme.surfaceColor,
                onRefresh: () =>
                    ref.read(catalogProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    // ── Banners ──────────────────────────────────────────
                    if (catalog.products.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(
                              0, AppSpacing.md, 0, AppSpacing.xs),
                          child: BannerCarousel(
                            products: ([...catalog.products]
                                  ..sort((a, b) {
                                    final aImg =
                                        a.imageUrl?.isNotEmpty == true ? 0 : 1;
                                    final bImg =
                                        b.imageUrl?.isNotEmpty == true ? 0 : 1;
                                    return aImg.compareTo(bImg);
                                  }))
                                .take(5)
                                .toList(),
                          ),
                        ),
                      ),

                    // ── Categorías → grid de tiles ────────────────────────
                    if (rootCategories.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Categorías',
                          primaryColor: primary,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _CategoryGrid(
                          categories: rootCategories,
                          primaryColor: primary,
                          surfaceColor: config.theme.surfaceColor,
                          bgColor: config.theme.backgroundColor,
                          textPrimary: config.theme.textPrimaryColor,
                          textSecondary: config.theme.textSecondaryColor,
                        ),
                      ),
                    ],

                    // ── Destacados → grid sin botón, tap al detalle ───────
                    if (featured.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.sm)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Destacados',
                          icon: Icons.star_outline_rounded,
                          primaryColor: primary,
                          actionLabel: 'Ver todos',
                          onAction: () => context.push('/products'),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _ProductSection(
                          products: featured,
                          showAddButton: false,
                        ),
                      ),
                    ],

                    // ── Más comprados → lista ranked diferenciada ─────────
                    if (mostPurchased.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.sm)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Más comprados',
                          icon: Icons.trending_up_rounded,
                          primaryColor: primary,
                          actionLabel: 'Ver todos',
                          onAction: () => context.push('/products'),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _RankedProductList(
                          products: mostPurchased,
                          config: config,
                        ),
                      ),
                    ],

                    // ── Ofertas del día → grid con badge de descuento ─────
                    if (offers.isNotEmpty) ...[
                      const SliverToBoxAdapter(
                          child: SizedBox(height: AppSpacing.sm)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Ofertas del día',
                          icon: Icons.local_offer_rounded,
                          primaryColor: config.theme.accentColor,
                          actionLabel: 'Ver todas',
                          onAction: () => context.push('/products'),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _ProductSection(
                          products: offers,
                          showAddButton: false,
                        ),
                      ),
                    ],

                    const SliverToBoxAdapter(
                        child: SizedBox(height: AppSpacing.xxl)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ── AppBar ────────────────────────────────────────────────────────────────────

class _HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeAppBar({required this.config, this.session});

  final RemoteAppConfig config;
  final AuthSessionEntity? session;

  @override
  Size get preferredSize => const Size.fromHeight(108);

  Color get _primary => config.theme.primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _primary,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xs, AppSpacing.xs, AppSpacing.sm, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu_rounded,
                        color: Colors.white, size: 22),
                    onPressed: () =>
                        mainScaffoldKey.currentState?.openDrawer(),
                    visualDensity: VisualDensity.compact,
                  ),
                  if (config.branding.logoLightUrl.isNotEmpty ||
                      config.branding.logoUrl.isNotEmpty)
                    CachedNetworkImage(
                      imageUrl: config.branding.logoLightUrl.isNotEmpty
                          ? config.branding.logoLightUrl
                          : config.branding.logoUrl,
                      height: 26,
                      fit: BoxFit.contain,
                      placeholder: (_, _) => const SizedBox(width: 80),
                      errorWidget: (_, _, _) => Text(
                        config.branding.appName,
                        style: AppTextStyles.titleSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (session?.selectedCompany.name != null)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 140),
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs + 1),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        session!.selectedCompany.name,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: AppSpacing.xs),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 22),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // Search bar
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => context.push('/search'),
                child: Container(
                  height: 44,
                  margin: const EdgeInsets.fromLTRB(AppSpacing.md,
                      AppSpacing.sm, AppSpacing.md, AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    boxShadow: AppShadows.level2,
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: AppSpacing.base),
                      Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        'Buscar productos...',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.primaryColor,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Color primaryColor;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.base, AppSpacing.base, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18, color: primaryColor),
                const SizedBox(width: AppSpacing.xs),
              ],
              Text(title, style: AppTextStyles.titleMedium),
            ],
          ),
          if (actionLabel != null && onAction != null)
            InkWell(
              onTap: onAction,
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Text(
                      actionLabel!,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(Icons.chevron_right_rounded,
                        size: 16, color: primaryColor),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Category grid — reemplaza los pills ──────────────────────────────────────
// Mobile: 4 columnas, máx 2 filas (8 items + "Ver todo")
// Desktop: 6-8 columnas, todas las categorías visibles

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.primaryColor,
    required this.surfaceColor,
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final List<CategoryEntity> categories;
  final Color primaryColor;
  final Color surfaceColor;
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;

  static IconData _icon(String name) {
    final n = name.toLowerCase();
    if (n.contains('bebida') || n.contains('jugo') || n.contains('refresco')) {
      return Icons.local_drink_outlined;
    }
    if (n.contains('licor') || n.contains('aguardient') || n.contains('vino') ||
        n.contains('whisky') || n.contains('cerveza')) {
      return Icons.wine_bar_outlined;
    }
    if (n.contains('lácteo') || n.contains('lacteo') || n.contains('leche')) {
      return Icons.egg_alt_outlined;
    }
    if (n.contains('panade') || n.contains('pan ') || n.contains('pastel')) {
      return Icons.bakery_dining_outlined;
    }
    if (n.contains('limpieza') ||
        n.contains('aseo hogar') ||
        n.contains('detergente')) {
      return Icons.cleaning_services_outlined;
    }
    if (n.contains('personal') ||
        n.contains('higiene') ||
        n.contains('cuidado')) {
      return Icons.face_retouching_natural_outlined;
    }
    if (n.contains('snack') ||
        n.contains('dulce') ||
        n.contains('confite') ||
        n.contains('galleta')) {
      return Icons.cookie_outlined;
    }
    if (n.contains('congelad') || n.contains('helado')) {
      return Icons.ac_unit_outlined;
    }
    if (n.contains('carne') || n.contains('pollo') || n.contains('cerdo')) {
      return Icons.set_meal_outlined;
    }
    if (n.contains('fruta') || n.contains('verdura') || n.contains('vegetal')) {
      return Icons.local_florist_outlined;
    }
    if (n.contains('despensa') ||
        n.contains('granos') ||
        n.contains('arroz') ||
        n.contains('aceite')) {
      return Icons.kitchen_outlined;
    }
    if (n.contains('mascota')) return Icons.pets_outlined;
    if (n.contains('bebé') || n.contains('bebe') || n.contains('infantil')) {
      return Icons.child_care_outlined;
    }
    if (n.contains('tabaco') || n.contains('cigarro')) {
      return Icons.smoking_rooms_outlined;
    }
    if (n.contains('papel') ||
        n.contains('servilleta') ||
        n.contains('toalla')) {
      return Icons.article_outlined;
    }
    return Icons.storefront_outlined;
  }

  List<_CategoryTile> _buildTiles(BuildContext context) {
    return [
      _CategoryTile(
        label: 'Ver todo',
        icon: Icons.apps_rounded,
        imageUrl: null,
        isAll: true,
        onTap: () => context.push('/products'),
        primaryColor: primaryColor,
        surfaceColor: surfaceColor,
        bgColor: bgColor,
        textPrimary: textPrimary,
        textSecondary: textSecondary,
      ),
      ...categories.map((cat) {
        final label = cat.name.split(' - ').first.trim();
        return _CategoryTile(
          label: label,
          icon: _icon(cat.name),
          imageUrl: cat.imageUrl,
          isAll: false,
          onTap: () => context.push(
            '/products?categoryId=${cat.id}&name=${Uri.encodeComponent(label)}',
          ),
          primaryColor: primaryColor,
          surfaceColor: surfaceColor,
          bgColor: bgColor,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;
    final tiles = _buildTiles(context);

    if (isDesktop) {
      // Desktop: cols adaptativos, máx 2 filas. Si sobran → carrusel horizontal.
      final cols = width >= 1400 ? 8 : (width >= 1100 ? 7 : 6);
      final maxInGrid = cols * 2; // 2 filas

      if (tiles.length <= maxInGrid) {
        // Todo cabe en 2 filas → grid estático
        return Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tiles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (_, i) => tiles[i],
          ),
        );
      }

      // Más de 2 filas → carrusel horizontal (tile 88px ancho)
      return _HorizontalCarousel(tiles: tiles, tileWidth: 88, tileHeight: 104);
    }

    // Mobile: siempre carrusel horizontal
    return _HorizontalCarousel(tiles: tiles, tileWidth: 76, tileHeight: 96);
  }
}

class _HorizontalCarousel extends StatelessWidget {
  const _HorizontalCarousel({
    required this.tiles,
    required this.tileWidth,
    required this.tileHeight,
  });

  final List<_CategoryTile> tiles;
  final double tileWidth;
  final double tileHeight;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: tileHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.sm),
        itemCount: tiles.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) => SizedBox(width: tileWidth, child: tiles[i]),
      ),
    );
  }
}

class _CategoryTile extends StatefulWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.imageUrl,
    required this.isAll,
    required this.onTap,
    required this.primaryColor,
    required this.surfaceColor,
    required this.bgColor,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String label;
  final IconData icon;
  final String? imageUrl;
  final bool isAll;
  final VoidCallback onTap;
  final Color primaryColor;
  final Color surfaceColor;
  final Color bgColor;
  final Color textPrimary;
  final Color textSecondary;

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final iconBg = widget.isAll
        ? widget.primaryColor
        : widget.primaryColor.withValues(alpha: 0.10);
    final iconColor =
        widget.isAll ? Colors.white : widget.primaryColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered
                ? widget.primaryColor.withValues(alpha: 0.06)
                : widget.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: _hovered
                  ? widget.primaryColor.withValues(alpha: 0.25)
                  : widget.primaryColor.withValues(alpha: 0.08),
              width: 1,
            ),
            boxShadow: _hovered ? AppShadows.level2 : AppShadows.level1,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon area — imagen si existe, icono si no
              AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.imageUrl != null && !widget.isAll
                      ? widget.bgColor
                      : iconBg,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                clipBehavior: Clip.antiAlias,
                child: widget.imageUrl != null && !widget.isAll
                    ? CachedNetworkImage(
                        imageUrl: widget.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => Icon(
                          widget.icon,
                          size: 22,
                          color: iconColor,
                        ),
                        errorWidget: (_, _, _) => Icon(
                          widget.icon,
                          size: 22,
                          color: iconColor,
                        ),
                      )
                    : Icon(widget.icon, size: 22, color: iconColor),
              ),
              const SizedBox(height: AppSpacing.xs + 2),
              // Label
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  widget.label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: widget.isAll
                        ? widget.primaryColor
                        : widget.textPrimary,
                    fontWeight:
                        widget.isAll ? FontWeight.w700 : FontWeight.w500,
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Ranked product list — "Más comprados" ─────────────────────────────────────
// Layout completamente diferente a ProductCard: rank number + thumbnail + info.
// Diferencia visual inmediata vs la sección "Destacados".

class _RankedProductList extends StatelessWidget {
  const _RankedProductList({
    required this.products,
    required this.config,
  });

  final List<ProductEntity> products;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    if (isDesktop) {
      final cols = width >= 1400 ? 3 : 2;
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 3.8,
          ),
          itemBuilder: (_, i) => _RankedItem(
            product: products[i],
            rank: i + 1,
            config: config,
          ),
        ),
      );
    }

    // Mobile: lista vertical (no carrusel — aprovecha mejor el espacio)
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.xs),
      child: Column(
        children: [
          for (int i = 0; i < products.take(6).length; i++) ...[
            _RankedItem(
              product: products[i],
              rank: i + 1,
              config: config,
            ),
            if (i < products.take(6).length - 1)
              const SizedBox(height: AppSpacing.sm),
          ],
        ],
      ),
    );
  }
}

class _RankedItem extends ConsumerWidget {
  const _RankedItem({
    required this.product,
    required this.rank,
    required this.config,
  });

  final ProductEntity product;
  final int rank;
  final RemoteAppConfig config;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = config.locale;
    final primaryColor = config.theme.primaryColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.openProductDetail(product.sku),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: config.theme.surfaceColor,
            borderRadius: BorderRadius.circular(AppRadius.md),
            boxShadow: AppShadows.level1,
          ),
          child: Row(
            children: [
              // Número de ranking — top 3 en color primario, el resto secundario
              SizedBox(
                width: 34,
                child: Center(
                  child: Text(
                    '$rank',
                    style: AppTextStyles.titleSmall.copyWith(
                      color: rank <= 3
                          ? primaryColor
                          : config.theme.textSecondaryColor,
                      fontWeight:
                          rank <= 3 ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
              ),

              // Thumbnail cuadrado
              Container(
                width: 56,
                height: 56,
                margin: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: config.theme.backgroundColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                padding: const EdgeInsets.all(4),
                child: (product.imageUrl?.isNotEmpty == true)
                    ? CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: config.theme.textSecondaryColor
                              .withValues(alpha: 0.3),
                          size: 22,
                        ),
                        errorWidget: (_, _, _) => Icon(
                          Icons.inventory_2_outlined,
                          color: config.theme.textSecondaryColor
                              .withValues(alpha: 0.3),
                          size: 22,
                        ),
                      )
                    : Icon(
                        Icons.inventory_2_outlined,
                        color: config.theme.textSecondaryColor
                            .withValues(alpha: 0.3),
                        size: 22,
                      ),
              ),

              // Nombre + precio
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        product.name,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: config.theme.textPrimaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CurrencyFormatter.format(product.basePrice, locale),
                        style: AppTextStyles.priceSmall.copyWith(
                            color: primaryColor),
                      ),
                    ],
                  ),
                ),
              ),

              // Chevron → indica que es tappable
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: config.theme.textSecondaryColor
                      .withValues(alpha: 0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Product section — Destacados y Ofertas (grillas de ProductCard) ───────────

class _ProductSection extends StatelessWidget {
  const _ProductSection({
    required this.products,
    this.showAddButton = true,
  });

  final List<ProductEntity> products;
  final bool showAddButton;

  int _cols(double width) {
    if (width >= 1400) return 5;
    if (width >= 1100) return 4;
    return 3;
  }

  Widget _card(ProductEntity product, {required bool desktop}) {
    return desktop
        ? ProductCard(product: product, showAddButton: showAddButton)
        : FeaturedProductCard(product: product, showAddButton: showAddButton);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    if (isDesktop) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cols(width),
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            // Sin botón el info section es más corto → cards menos altas
            childAspectRatio: showAddButton ? 0.68 : 0.80,
          ),
          itemBuilder: (_, i) => AnimatedCard(
            index: i,
            child: _card(products[i], desktop: true),
          ),
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) => _card(products[i], desktop: false),
      ),
    );
  }
}

