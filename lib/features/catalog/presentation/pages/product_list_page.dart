import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../cart/domain/entities/cart_entity.dart';
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
  // Filtro de subcategoría (cuando categoryId != null y llegan subcats del backend)
  String? _selectedSubcategoryId;

  // Filtro de categoría raíz (solo cuando categoryId == null = "Ver todas")
  String? _selectedRootCategoryId;

  bool get _isAllCategories => widget.categoryId == null;

  int _gridColumns(double width) {
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.tablet) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final catalogAsync = ref.watch(catalogProvider);
    final config = ref.watch(themeProvider);
    final cartCount =
        ref.watch(cartProvider.select((c) => c.itemCount));
    final primary = config.theme.primaryColor;
    final title = widget.categoryName ?? 'Catálogo';

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(config, primary, title, cartCount),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: context.catalogMaxWidth),
          child: catalogAsync.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) => AppErrorWidget(
              message: e.toString(),
              onRetry: () => ref.invalidate(catalogProvider),
            ),
            data: (catalog) {
              // ── Modo "Ver todas" ────────────────────────────────────
              if (_isAllCategories) {
                final rootCategories =
                    catalog.categories.where((c) => c.isRoot).toList();

                // Incluye productos de la categoría raíz Y de sus subcategorías
                final filtered = _selectedRootCategoryId == null
                    ? catalog.products
                    : catalog.products.where((p) {
                        if (p.categoryId == _selectedRootCategoryId) return true;
                        return catalog.categories.any((c) =>
                            c.id == p.categoryId &&
                            c.parentId == _selectedRootCategoryId);
                      }).toList();

                final activeLabel = _selectedRootCategoryId != null
                    ? rootCategories
                        .firstWhere(
                            (c) => c.id == _selectedRootCategoryId,
                            orElse: () => rootCategories.first)
                        .name
                        .split(' - ')
                        .first
                        .trim()
                    : 'Todos los productos';

                return CustomScrollView(
                  slivers: [
                    // ── Filtro de categorías ─────────────────────────
                    if (rootCategories.isNotEmpty)
                      SliverToBoxAdapter(
                        child: _CategoryFilterRow(
                          categories: rootCategories,
                          selectedId: _selectedRootCategoryId,
                          primaryColor: primary,
                          onSelected: (id) => setState(
                              () => _selectedRootCategoryId = id),
                        ),
                      ),

                    // ── Header ──────────────────────────────────────
                    SliverToBoxAdapter(
                      child: _GridHeader(
                        label: activeLabel,
                        count: filtered.length,
                      ),
                    ),

                    // ── Grid ────────────────────────────────────────
                    _buildGrid(filtered),
                  ],
                );
              }

              // ── Modo categoría específica ────────────────────────────
              final subcategories = catalog.categories
                  .where((c) => c.parentId == widget.categoryId)
                  .toList();
              final subcatIds = subcategories.map((c) => c.id).toSet();

              final filtered = catalog.products.where((p) {
                if (_selectedSubcategoryId != null) {
                  return p.categoryId == _selectedSubcategoryId;
                }
                if (subcatIds.isNotEmpty) {
                  return subcatIds.contains(p.categoryId) ||
                      p.categoryId == widget.categoryId;
                }
                return p.categoryId == widget.categoryId;
              }).toList();

              final activeLabel = _selectedSubcategoryId != null
                  ? subcategories
                      .firstWhere((c) => c.id == _selectedSubcategoryId)
                      .name
                      .split(' - ')
                      .first
                      .trim()
                  : title;

              return CustomScrollView(
                slivers: [
                  // ── Subcategorías ─────────────────────────────────
                  if (subcategories.isNotEmpty)
                    SliverToBoxAdapter(
                      child: _CategoryFilterRow(
                        categories: subcategories,
                        selectedId: _selectedSubcategoryId,
                        primaryColor: primary,
                        onSelected: (id) =>
                            setState(() => _selectedSubcategoryId = id),
                      ),
                    ),

                  // ── Header ─────────────────────────────────────
                  SliverToBoxAdapter(
                    child: _GridHeader(
                      label: activeLabel,
                      count: filtered.length,
                    ),
                  ),

                  // ── Grid ─────────────────────────────────────────
                  _buildGrid(filtered),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    dynamic config,
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
              height: 24,
              fit: BoxFit.contain,
              placeholder: (_, _) => const SizedBox(width: 60),
              errorWidget: (_, _, _) => const SizedBox.shrink(),
            ),
            Container(
              width: 1,
              height: 18,
              color: Colors.white.withValues(alpha: 0.3),
              margin: const EdgeInsets.symmetric(horizontal: 10),
            ),
          ],
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      actions: [
        // Búsqueda
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () => context.push('/search'),
          tooltip: 'Buscar',
        ),
        // Carrito con badge
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () => context.go('/cart'),
                tooltip: 'Carrito',
              ),
              if (cartCount > 0)
                Positioned(
                  right: 4,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    child: Text(
                      cartCount > 99 ? '99+' : '$cartCount',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
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

  Widget _buildGrid(List filtered) {
    if (filtered.isEmpty) {
      return const SliverFillRemaining(
        child: Center(
          child: Text(
            'Sin productos en esta categoría',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              _gridColumns(MediaQuery.sizeOf(context).width),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => ProductCard(product: filtered[i]),
          childCount: filtered.length,
        ),
      ),
    );
  }
}

// ── Grid header ───────────────────────────────────────────────────────────────

class _GridHeader extends StatelessWidget {
  const _GridHeader({required this.label, required this.count});
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '$count productos',
            style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ── Category filter row (pills) ───────────────────────────────────────────────

class _CategoryFilterRow extends StatelessWidget {
  const _CategoryFilterRow({
    required this.categories,
    required this.selectedId,
    required this.primaryColor,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedId;
  final Color primaryColor;
  final void Function(String? id) onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length + 1,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            if (i == 0) {
              return _Pill(
                label: 'Todos',
                selected: selectedId == null,
                primaryColor: primaryColor,
                onTap: () => onSelected(null),
              );
            }
            final cat = categories[i - 1];
            final label = cat.name.split(' - ').first.trim();
            return _Pill(
              label: label.length > 16
                  ? '${label.substring(0, 15)}…'
                  : label,
              selected: selectedId == cat.id,
              primaryColor: primaryColor,
              onTap: () =>
                  onSelected(selectedId == cat.id ? null : cat.id),
            );
          },
        ),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.selected,
    required this.primaryColor,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color primaryColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? primaryColor : const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? primaryColor : Colors.grey.shade200,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
            color:
                selected ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}
