import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/shell/top_bar.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_shadows.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../../../shared/widgets/animated_card.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../../cart/presentation/notifiers/cart_notifier.dart';
import '../../domain/entities/category_entity.dart';
import '../notifiers/catalog_notifier.dart';
import '../widgets/product_card.dart';

class ProductListPage extends ConsumerStatefulWidget {
  const ProductListPage({
    super.key,
    this.categoryId,
    this.categoryName,
  });

  final String? categoryId;
  final String? categoryName;

  @override
  ConsumerState<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends ConsumerState<ProductListPage> {
  String? _selectedSubcategoryId;
  String? _selectedRootCategoryId;

  bool get _isAllCategories => widget.categoryId == null;

  int _gridColumns(double width, {bool hasSidebar = false}) {
    if (hasSidebar) {
      if (width >= Breakpoints.desktop) return 4;
      return 3;
    }
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.tablet) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogProvider);
    final config = ref.watch(themeProvider);
    final cartCount = ref.watch(cartProvider.select((c) => c.itemCount));
    final primary = config.theme.primaryColor;
    final title = widget.categoryName ?? 'Catálogo';
    final isDesktop = MediaQuery.sizeOf(context).width >= Breakpoints.tablet;

    final bodyContent = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: context.catalogMaxWidth),
        child: catalogAsync.when(
          loading: () => _buildLoadingGrid(config, isDesktop),
          error: (e, _) => AppErrorWidget(
            message: e.toString(),
            onRetry: () => ref.invalidate(catalogProvider),
          ),
          data: (catalog) {
            final rootCategories =
                catalog.categories.where((c) => c.isRoot).toList();

            List filtered;
            List<CategoryEntity> filterCategories;
            String? activeId;
            String activeLabel;

            if (_isAllCategories) {
              filterCategories = rootCategories;
              activeId = _selectedRootCategoryId;
              filtered = _selectedRootCategoryId == null
                  ? catalog.products
                  : catalog.products.where((p) {
                      if (p.categoryId == _selectedRootCategoryId) return true;
                      return catalog.categories.any((c) =>
                          c.id == p.categoryId &&
                          c.parentId == _selectedRootCategoryId);
                    }).toList();
              activeLabel = _selectedRootCategoryId != null
                  ? rootCategories
                      .firstWhere((c) => c.id == _selectedRootCategoryId,
                          orElse: () => rootCategories.first)
                      .name
                      .split(' - ')
                      .first
                      .trim()
                  : 'Todos los productos';
            } else {
              final subcategories = catalog.categories
                  .where((c) => c.parentId == widget.categoryId)
                  .toList();
              filterCategories = subcategories;
              activeId = _selectedSubcategoryId;
              final subcatIds = subcategories.map((c) => c.id).toSet();
              filtered = catalog.products.where((p) {
                if (_selectedSubcategoryId != null) {
                  return p.categoryId == _selectedSubcategoryId;
                }
                if (subcatIds.isNotEmpty) {
                  return subcatIds.contains(p.categoryId) ||
                      p.categoryId == widget.categoryId;
                }
                return p.categoryId == widget.categoryId;
              }).toList();
              activeLabel = _selectedSubcategoryId != null
                  ? subcategories
                      .firstWhere((c) => c.id == _selectedSubcategoryId)
                      .name
                      .split(' - ')
                      .first
                      .trim()
                  : title;
            }

            if (isDesktop && filterCategories.isNotEmpty) {
              return _DesktopLayout(
                categories: filterCategories,
                selectedId: activeId,
                primaryColor: primary,
                config: config,
                onSelected: (id) => setState(() {
                  if (_isAllCategories) {
                    _selectedRootCategoryId = id;
                  } else {
                    _selectedSubcategoryId = id;
                  }
                }),
                gridContent: _buildGrid(
                  filtered,
                  config,
                  activeLabel,
                  hasSidebar: true,
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                if (filterCategories.isNotEmpty)
                  SliverToBoxAdapter(
                    child: _MobileFilterRow(
                      categories: filterCategories,
                      selectedId: activeId,
                      primaryColor: primary,
                      surfaceColor: config.theme.surfaceColor,
                      textSecondary: config.theme.textSecondaryColor,
                      onSelected: (id) => setState(() {
                        if (_isAllCategories) {
                          _selectedRootCategoryId = id;
                        } else {
                          _selectedSubcategoryId = id;
                        }
                      }),
                    ),
                  ),
                ..._buildGrid(filtered, config, activeLabel, hasSidebar: false),
              ],
            );
          },
        ),
      ),
    );

    // ── Desktop: TopBar + breadcrumb + contenido ─────────────────────────────
    if (isDesktop) {
      return Scaffold(
        backgroundColor: config.theme.backgroundColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const DesktopTopBar(),
            _BreadcrumbBar(
              title: title,
              primary: primary,
              surface: config.theme.surfaceColor,
              textPrimary: config.theme.textPrimaryColor,
              textSecondary: config.theme.textSecondaryColor,
            ),
            Expanded(child: bodyContent),
          ],
        ),
      );
    }

    // ── Mobile: AppBar de marca ───────────────────────────────────────────────
    return Scaffold(
      backgroundColor: config.theme.backgroundColor,
      appBar: _buildMobileAppBar(config, primary, title, cartCount),
      body: bodyContent,
    );
  }

  PreferredSizeWidget _buildMobileAppBar(
    RemoteAppConfig config,
    Color primary,
    String title,
    int cartCount,
  ) {
    final logoUrl = config.branding.logoLightUrl.isNotEmpty
        ? config.branding.logoLightUrl
        : config.branding.logoUrl;

    return AppBar(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          if (logoUrl.isNotEmpty) ...[
            CachedNetworkImage(
              imageUrl: logoUrl,
              height: 22,
              fit: BoxFit.contain,
              placeholder: (_, _) => const SizedBox(width: 56),
              errorWidget: (_, _, _) => const SizedBox.shrink(),
            ),
            Container(
              width: 1,
              height: 16,
              color: Colors.white.withValues(alpha: 0.35),
              margin:
                  const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            ),
          ],
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.titleSmall.copyWith(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => context.push('/search'),
        ),
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.sm),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () => context.go('/cart'),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.red.shade600,
                      shape: BoxShape.circle,
                      border: Border.all(color: primary, width: 1.5),
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _buildGrid(
    List filtered,
    RemoteAppConfig config,
    String activeLabel, {
    required bool hasSidebar,
  }) {
    if (filtered.isEmpty) {
      return [
        SliverFillRemaining(
          child: Center(
            child: Text(
              'Sin productos en esta categoría',
              style: AppTextStyles.bodyMedium.copyWith(
                  color: config.theme.textSecondaryColor),
            ),
          ),
        ),
      ];
    }

    final width = MediaQuery.sizeOf(context).width;
    final cols = _gridColumns(width, hasSidebar: hasSidebar);

    return [
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Expanded(
                child: Text(
                  activeLabel,
                  style: AppTextStyles.titleMedium.copyWith(
                      color: config.theme.textPrimaryColor),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: 3),
                decoration: BoxDecoration(
                  color: config.theme.textSecondaryColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  '${filtered.length} productos',
                  style: AppTextStyles.labelSmall.copyWith(
                      color: config.theme.textSecondaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.md, 0, AppSpacing.md, AppSpacing.xxl),
        sliver: SliverGrid(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.62,
          ),
          delegate: SliverChildBuilderDelegate(
            (_, i) => AnimatedCard(
              index: i,
              child: ProductCard(product: filtered[i]),
            ),
            childCount: filtered.length,
          ),
        ),
      ),
    ];
  }

  Widget _buildLoadingGrid(RemoteAppConfig config, bool isDesktop) {
    final surface = config.theme.surfaceColor;
    final cols = isDesktop ? 4 : 2;

    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar skeleton
          Container(
            width: 240,
            color: surface,
            padding: const EdgeInsets.all(AppSpacing.base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(height: 12, width: 80),
                const SizedBox(height: AppSpacing.md),
                ...List.generate(
                  7,
                  (_) => const Padding(
                    padding:
                        EdgeInsets.only(bottom: AppSpacing.md),
                    child: ShimmerBox(
                        height: 16, width: double.infinity),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),
          // Grid skeleton
          Expanded(
            child: _GridSkeleton(cols: cols, surface: surface),
          ),
        ],
      );
    }

    return _GridSkeleton(cols: cols, surface: surface);
  }
}

// ── Breadcrumb bar (desktop) ──────────────────────────────────────────────────

class _BreadcrumbBar extends StatelessWidget {
  const _BreadcrumbBar({
    required this.title,
    required this.primary,
    required this.surface,
    required this.textPrimary,
    required this.textSecondary,
  });

  final String title;
  final Color primary;
  final Color surface;
  final Color textPrimary;
  final Color textSecondary;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surface,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.sm + 2),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.pop(),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.chevron_left_rounded,
                      size: 18, color: textSecondary),
                  Text(
                    'Inicio',
                    style: AppTextStyles.labelMedium.copyWith(
                        color: textSecondary),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
            child: Icon(Icons.chevron_right_rounded,
                size: 14,
                color: textSecondary.withValues(alpha: 0.4)),
          ),
          Text(
            title,
            style: AppTextStyles.labelMedium.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton grid ─────────────────────────────────────────────────────────────

class _GridSkeleton extends StatelessWidget {
  const _GridSkeleton({required this.cols, required this.surface});

  final int cols;
  final Color surface;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: cols * 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: cols,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.62,
        ),
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: surface,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                flex: 6,
                child: ShimmerBox(
                    height: double.infinity, radius: AppRadius.md),
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    ShimmerBox(height: 12, width: double.infinity),
                    SizedBox(height: 3),
                    ShimmerBox(height: 10, width: 80),
                    SizedBox(height: AppSpacing.xs),
                    ShimmerBox(height: 14, width: 100),
                    SizedBox(height: AppSpacing.xs),
                    ShimmerBox(
                        height: 36,
                        width: double.infinity,
                        radius: AppRadius.sm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Desktop: sidebar fijo + grid ──────────────────────────────────────────────

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.categories,
    required this.selectedId,
    required this.primaryColor,
    required this.config,
    required this.onSelected,
    required this.gridContent,
  });

  final List<CategoryEntity> categories;
  final String? selectedId;
  final Color primaryColor;
  final RemoteAppConfig config;
  final void Function(String? id) onSelected;
  final List<Widget> gridContent;

  @override
  Widget build(BuildContext context) {
    final surface = config.theme.surfaceColor;
    final textPrimary = config.theme.textPrimaryColor;
    final textSecondary = config.theme.textSecondaryColor;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Sidebar 240px ─────────────────────────────────────────────
        Container(
          width: 240,
          decoration: BoxDecoration(
            color: surface,
            border: Border(
              right: BorderSide(
                color: textSecondary.withValues(alpha: 0.10),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(AppSpacing.base,
                    AppSpacing.base, AppSpacing.base, AppSpacing.sm),
                child: Text(
                  'CATEGORÍAS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: textSecondary,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _SidebarItem(
                label: 'Todos',
                selected: selectedId == null,
                primaryColor: primaryColor,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onTap: () => onSelected(null),
              ),
              Divider(
                height: 1,
                indent: AppSpacing.base,
                endIndent: AppSpacing.base,
                color: textSecondary.withValues(alpha: 0.08),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                  itemCount: categories.length,
                  itemBuilder: (_, i) {
                    final cat = categories[i];
                    final label = cat.name.split(' - ').first.trim();
                    return _SidebarItem(
                      label: label,
                      selected: selectedId == cat.id,
                      primaryColor: primaryColor,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () =>
                          onSelected(selectedId == cat.id ? null : cat.id),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ── Grid área ────────────────────────────────────────────────
        Expanded(
          child: CustomScrollView(slivers: gridContent),
        ),
      ],
    );
  }
}

// ── Sidebar item ─────────────────────────────────────────────────────────────

class _SidebarItem extends StatefulWidget {
  const _SidebarItem({
    required this.label,
    required this.selected,
    required this.primaryColor,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primaryColor;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.base, vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: widget.selected
                ? widget.primaryColor.withValues(alpha: 0.08)
                : _hovered
                    ? widget.primaryColor.withValues(alpha: 0.04)
                    : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: widget.selected
                    ? widget.primaryColor
                    : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Text(
            widget.label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: widget.selected
                  ? widget.primaryColor
                  : widget.textSecondary,
              fontWeight:
                  widget.selected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Mobile filter row (pills horizontales) ────────────────────────────────────

class _MobileFilterRow extends StatelessWidget {
  const _MobileFilterRow({
    required this.categories,
    required this.selectedId,
    required this.primaryColor,
    required this.surfaceColor,
    required this.textSecondary,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedId;
  final Color primaryColor;
  final Color surfaceColor;
  final Color textSecondary;
  final void Function(String? id) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: surfaceColor,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding:
              const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (_, i) {
            if (i == 0) {
              return _FilterPill(
                label: 'Todos',
                selected: selectedId == null,
                primaryColor: primaryColor,
                textSecondary: textSecondary,
                onTap: () => onSelected(null),
              );
            }
            final cat = categories[i - 1];
            final label = cat.name.split(' - ').first.trim();
            return _FilterPill(
              label: label.length > 16 ? '${label.substring(0, 15)}…' : label,
              selected: selectedId == cat.id,
              primaryColor: primaryColor,
              textSecondary: textSecondary,
              onTap: () => onSelected(selectedId == cat.id ? null : cat.id),
            );
          },
        ),
      ),
    );
  }
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({
    required this.label,
    required this.selected,
    required this.primaryColor,
    required this.textSecondary,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primaryColor;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.base),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? primaryColor
                : primaryColor.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(AppRadius.full),
            border: Border.all(
              color: selected
                  ? primaryColor
                  : primaryColor.withValues(alpha: 0.20),
            ),
            boxShadow: selected ? AppShadows.level2 : null,
          ),
          child: Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? Colors.white : primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
