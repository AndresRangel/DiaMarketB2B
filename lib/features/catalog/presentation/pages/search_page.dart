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
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../domain/entities/product_entity.dart';
import '../notifiers/catalog_notifier.dart';
import '../notifiers/search_notifier.dart';
import '../notifiers/search_state.dart';
import '../widgets/product_card.dart';

// Términos populares hardcoded — B2B mayorista
const _popularTerms = [
  'Bebidas 2L',
  'Snacks caja',
  'Lácteos',
  'Cerveza',
  'Agua mineral',
  'Aceite cocina',
  'Limpieza hogar',
  'Confitería',
];

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  int _gridColumns(double width) {
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.tablet) return 3;
    return 2;
  }

  void _doSearch(String q) {
    _controller.text = q;
    _controller.selection = TextSelection.fromPosition(
        TextPosition(offset: q.length));
    ref.read(recentSearchesProvider.notifier).add(q);
    ref.read(searchProvider.notifier).search(q);
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final config = ref.watch(themeProvider);
    final primary = config.theme.primaryColor;
    final textPrimary = config.theme.textPrimaryColor;
    final textSecondary = config.theme.textSecondaryColor;
    final surface = config.theme.surfaceColor;
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= Breakpoints.tablet;

    ref.listen<SearchState>(searchProvider, (_, next) {
      if (next is SearchStateError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.message)),
        );
      }
    });

    return Scaffold(
      backgroundColor: surface,
      // AppBar minimal blanca — barra de búsqueda dentro del appbar
      appBar: _buildAppBar(context, primary, textSecondary, surface),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: isDesktop ? 1400 : double.infinity),
          child: switch (searchState) {
            SearchStateInitial() => _buildInitial(
                config, primary, textPrimary, textSecondary, surface,
                isDesktop: isDesktop),
            SearchStateLoading() => isDesktop
                ? _SearchGridSkeleton(columns: _gridColumns(width))
                : const _SearchListSkeleton(),
            SearchStateResults(:final products) => isDesktop
                ? _buildDesktopResults(products, width)
                : _buildMobileResults(products, config),
            SearchStateEmpty(:final query) => EmptyState(
                icon: Icons.search_off_outlined,
                message: 'Sin resultados para "$query"',
                subtitle:
                    'Intenta con otro término o revisa la ortografía.',
              ),
            SearchStateError() => AppErrorWidget(
                message: searchState.message,
                onRetry: () =>
                    ref.read(searchProvider.notifier).search(_controller.text),
              ),
          },
        ),
      ),
    );
  }

  // ── AppBar blanca con campo de búsqueda ───────────────────────────────────

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    Color primary,
    Color textSecondary,
    Color surface,
  ) {
    return AppBar(
      backgroundColor: surface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: Colors.black12,
      leadingWidth: 44,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => context.pop(),
        color: Colors.black87,
        padding: const EdgeInsets.only(left: AppSpacing.md),
      ),
      title: Container(
        height: 42,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.search_rounded,
                size: 18,
                color: textSecondary.withValues(alpha: 0.5)),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.black87),
                cursorColor: primary,
                decoration: InputDecoration(
                  hintText: 'Buscar productos, marcas...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                      color: textSecondary.withValues(alpha: 0.5)),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (q) =>
                    ref.read(searchProvider.notifier).search(q),
                onSubmitted: (q) {
                  ref.read(recentSearchesProvider.notifier).add(q);
                  ref.read(searchProvider.notifier).search(q);
                },
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (_, value, _) => value.text.isEmpty
                  ? const SizedBox.shrink()
                  : GestureDetector(
                      onTap: () {
                        _controller.clear();
                        ref.read(searchProvider.notifier).clear();
                        _focusNode.requestFocus();
                      },
                      child: Icon(Icons.close_rounded,
                          size: 16,
                          color: textSecondary.withValues(alpha: 0.5)),
                    ),
            ),
          ],
        ),
      ),
      titleSpacing: AppSpacing.sm,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: AppSpacing.md),
          child: Icon(Icons.tune_rounded,
              size: 22, color: Colors.black54),
        ),
      ],
    );
  }

  // ── Estado inicial: recientes + populares + productos ─────────────────────

  Widget _buildInitial(
    RemoteAppConfig config,
    Color primary,
    Color textPrimary,
    Color textSecondary,
    Color surface, {
    bool isDesktop = false,
  }) {
    final recents = ref.watch(recentSearchesProvider);
    final catalogAsync = ref.watch(catalogProvider);

    return ListView(
      children: [
        // ── Búsquedas recientes ─────────────────────────────────────
        if (recents.isNotEmpty) ...[
          _SectionHeader(
            title: 'Búsquedas recientes',
            action: 'Borrar',
            actionColor: primary,
            onAction: () => ref
                .read(recentSearchesProvider.notifier)
                .clearAll(),
          ),
          ...recents.map((q) => _RecentRow(
                query: q,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onTap: () => _doSearch(q),
              )),
          const SizedBox(height: AppSpacing.base),
        ],

        // ── Búsquedas populares ─────────────────────────────────────
        _SectionHeader(title: 'Búsquedas populares'),
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.base),
          child: Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: _popularTerms
                .map((term) => _PopularPill(
                      label: term,
                      textPrimary: textPrimary,
                      textSecondary: textSecondary,
                      onTap: () => _doSearch(term),
                    ))
                .toList(),
          ),
        ),

        // ── Productos populares ─────────────────────────────────────
        if (catalogAsync.hasValue &&
            catalogAsync.value!.products.isNotEmpty) ...[
          _SectionHeader(title: 'Productos Populares'),
          if (isDesktop)
            _PopularProductsGrid(
              products: catalogAsync.value!.products.take(12).toList(),
              config: config,
              primary: primary,
              textPrimary: textPrimary,
              textSecondary: textSecondary,
              onTap: (sku) => context.openProductDetail(sku),
            )
          else
            ...catalogAsync.value!.products.take(8).map((p) => _PopularProductRow(
                  product: p,
                  locale: config.locale,
                  primary: primary,
                  textPrimary: textPrimary,
                  textSecondary: textSecondary,
                  onTap: () => context.openProductDetail(p.sku),
                )),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ],
    );
  }

  // ── Desktop: grilla ───────────────────────────────────────────────────────

  Widget _buildDesktopResults(List<ProductEntity> products, double width) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
                AppSpacing.base, AppSpacing.base, AppSpacing.base, AppSpacing.sm),
            child: Text(
              '${products.length} productos',
              style: AppTextStyles.labelMedium,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, 0, AppSpacing.md, AppSpacing.xxl),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _gridColumns(width),
              crossAxisSpacing: AppSpacing.sm,
              mainAxisSpacing: AppSpacing.sm,
              childAspectRatio: 0.68,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) => ProductCard(product: products[i]),
              childCount: products.length,
            ),
          ),
        ),
      ],
    );
  }

  // ── Mobile: lista de resultados ───────────────────────────────────────────

  Widget _buildMobileResults(
      List<ProductEntity> products, RemoteAppConfig config) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
          child: Text(
            '${products.length} resultado${products.length != 1 ? 's' : ''}',
            style: AppTextStyles.labelSmall.copyWith(
                color: config.theme.textSecondaryColor),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            itemCount: products.length,
            itemBuilder: (_, i) => _SearchResultRow(
              product: products[i],
              locale: config.locale,
              primary: config.theme.primaryColor,
              textPrimary: config.theme.textPrimaryColor,
              textSecondary: config.theme.textSecondaryColor,
              surface: config.theme.surfaceColor,
              background: config.theme.backgroundColor,
              onTap: () => context.openProductDetail(products[i].sku),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.action,
    this.actionColor,
    this.onAction,
  });

  final String title;
  final String? action;
  final Color? actionColor;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.base, AppSpacing.base, AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700)),
          if (action != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(action!,
                  style: AppTextStyles.labelMedium.copyWith(
                      color: actionColor ?? Colors.red)),
            ),
        ],
      ),
    );
  }
}

// ── Fila de búsqueda reciente ─────────────────────────────────────────────────

class _RecentRow extends StatelessWidget {
  const _RecentRow({
    required this.query,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final String query;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.base, vertical: AppSpacing.md),
            child: Row(
              children: [
                Icon(Icons.history_rounded,
                    size: 20,
                    color: textSecondary.withValues(alpha: 0.4)),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(query,
                      style: AppTextStyles.bodyMedium.copyWith(
                          color: textPrimary)),
                ),
                Icon(Icons.chevron_right_rounded,
                    size: 18,
                    color: textSecondary.withValues(alpha: 0.3)),
              ],
            ),
          ),
        ),
        Divider(
          height: 1,
          indent: AppSpacing.base + 20 + AppSpacing.md,
          endIndent: AppSpacing.base,
          color: Colors.black.withValues(alpha: 0.06),
        ),
      ],
    );
  }
}

// ── Pill de búsqueda popular ──────────────────────────────────────────────────

class _PopularPill extends StatelessWidget {
  const _PopularPill({
    required this.label,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final String label;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F7),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Text(label,
            style: AppTextStyles.labelMedium.copyWith(
              color: textPrimary,
              fontWeight: FontWeight.w400,
            )),
      ),
    );
  }
}

// ── Grid de productos populares (desktop) ────────────────────────────────────

class _PopularProductsGrid extends StatelessWidget {
  const _PopularProductsGrid({
    required this.products,
    required this.config,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final List<ProductEntity> products;
  final RemoteAppConfig config;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final void Function(String sku) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 3.2,
        ),
        itemCount: products.length,
        itemBuilder: (_, i) {
          final p = products[i];
          return _PopularProductRow(
            product: p,
            locale: config.locale,
            primary: primary,
            textPrimary: textPrimary,
            textSecondary: textSecondary,
            onTap: () => onTap(p.sku),
          );
        },
      ),
    );
  }
}

// ── Producto popular (estado inicial) ────────────────────────────────────────

class _PopularProductRow extends StatelessWidget {
  const _PopularProductRow({
    required this.product,
    required this.locale,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.onTap,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base, vertical: AppSpacing.sm + 2),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: (product.imageUrl?.isNotEmpty == true)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => const SizedBox(),
                        errorWidget: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            size: 28,
                            color: textSecondary.withValues(alpha: 0.3)),
                      ),
                    )
                  : Icon(Icons.inventory_2_outlined,
                      size: 28,
                      color: textSecondary.withValues(alpha: 0.3)),
            ),
            const SizedBox(width: AppSpacing.md),

            // Nombre + SKU
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('SKU: ${product.sku}',
                      style: AppTextStyles.labelSmall.copyWith(
                          color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),

            // Precio
            Text(
              CurrencyFormatter.format(product.basePrice, locale),
              style: AppTextStyles.priceMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Fila de resultado de búsqueda ─────────────────────────────────────────────

class _SearchResultRow extends StatelessWidget {
  const _SearchResultRow({
    required this.product,
    required this.locale,
    required this.primary,
    required this.textPrimary,
    required this.textSecondary,
    required this.surface,
    required this.background,
    required this.onTap,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primary;
  final Color textPrimary;
  final Color textSecondary;
  final Color surface;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.base, vertical: AppSpacing.sm + 2),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: (product.imageUrl?.isNotEmpty == true)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: CachedNetworkImage(
                        imageUrl: product.imageUrl!,
                        fit: BoxFit.contain,
                        placeholder: (_, _) => const SizedBox(),
                        errorWidget: (_, _, _) => Icon(
                            Icons.inventory_2_outlined,
                            size: 28,
                            color: textSecondary.withValues(alpha: 0.3)),
                      ),
                    )
                  : Icon(Icons.inventory_2_outlined,
                      size: 28,
                      color: textSecondary.withValues(alpha: 0.3)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 3),
                  Text('SKU: ${product.sku}',
                      style: AppTextStyles.labelSmall.copyWith(
                          color: textSecondary)),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              CurrencyFormatter.format(product.basePrice, locale),
              style: AppTextStyles.priceMedium.copyWith(
                color: textPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Skeleton desktop ──────────────────────────────────────────────────────────

class _SearchGridSkeleton extends StatelessWidget {
  const _SearchGridSkeleton({required this.columns});
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, AppSpacing.base, AppSpacing.md, AppSpacing.xl),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: columns * 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: AppSpacing.sm,
          mainAxisSpacing: AppSpacing.sm,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              ShimmerBox(height: 130, radius: AppRadius.md),
              Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 12, width: double.infinity),
                    SizedBox(height: AppSpacing.xs),
                    ShimmerBox(height: 12, width: 100),
                    SizedBox(height: AppSpacing.sm),
                    ShimmerBox(height: 16, width: 80),
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

// ── Skeleton mobile ───────────────────────────────────────────────────────────

class _SearchListSkeleton extends StatelessWidget {
  const _SearchListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.base, vertical: AppSpacing.base),
      itemCount: 8,
      itemBuilder: (_, _) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.base),
        child: Row(
          children: [
            ShimmerBox(height: 68, width: 68, radius: AppRadius.sm),
            SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14, width: double.infinity),
                  SizedBox(height: AppSpacing.xs),
                  ShimmerBox(height: 11, width: 120),
                  SizedBox(height: AppSpacing.sm),
                  ShimmerBox(height: 14, width: 80),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
