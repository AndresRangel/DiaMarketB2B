import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/widgets/app_error_widget.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../../../shared/widgets/shimmer_box.dart';
import '../../domain/entities/product_entity.dart';
import '../notifiers/search_notifier.dart';
import '../notifiers/search_state.dart';
import '../widgets/product_card.dart';

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

  // Columnas de grilla según ancho — igual que HomePage
  int _gridColumns(double width) {
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.tablet) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchProvider);
    final primaryColor =
        ref.watch(themeProvider.select((c) => c.theme.primaryColor));
    final LocaleConfig locale =
        ref.watch(themeProvider.select((c) => c.locale));
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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(primaryColor, isDesktop),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: isDesktop ? 1400 : double.infinity),
          child: switch (searchState) {
            SearchStateInitial() => _buildInitial(primaryColor),
            SearchStateLoading() =>
              isDesktop ? _SearchGridSkeleton(columns: _gridColumns(width)) : const _SearchListSkeleton(),
            SearchStateResults(:final products) => isDesktop
                ? _buildDesktopResults(products, width)
                : _buildMobileResults(products, locale, primaryColor),
            SearchStateEmpty(:final query) => EmptyState(
                icon: Icons.search_off_outlined,
                message: 'Sin resultados para "$query"',
                subtitle: 'Intenta con otro término o revisa la ortografía.',
              ),
            SearchStateError() => AppErrorWidget(
                message: searchState.message,
                onRetry: () => ref
                    .read(searchProvider.notifier)
                    .search(_controller.text),
              ),
          },
        ),
      ),
    );
  }

  // ── AppBar ────────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(Color primaryColor, bool isDesktop) {
    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      toolbarHeight: isDesktop ? 64 : kToolbarHeight,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Container(
        height: isDesktop ? 44 : 40,
        constraints: isDesktop ? const BoxConstraints(maxWidth: 600) : null,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            Icon(Icons.search,
                color: Colors.white.withValues(alpha: 0.7),
                size: isDesktop ? 22 : 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                style: TextStyle(
                    color: Colors.white, fontSize: isDesktop ? 16 : 15),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Buscar productos...',
                  hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: isDesktop ? 16 : 15),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                textInputAction: TextInputAction.search,
                onChanged: (q) =>
                    ref.read(searchProvider.notifier).search(q),
                onSubmitted: (q) =>
                    ref.read(searchProvider.notifier).search(q),
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
                      child: Icon(Icons.close,
                          color: Colors.white.withValues(alpha: 0.8),
                          size: 18),
                    ),
            ),
          ],
        ),
      ),
      titleSpacing: 0,
    );
  }

  // ── Initial state ─────────────────────────────────────────────────────────

  Widget _buildInitial(Color primaryColor) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 56),
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.search_rounded,
                  size: 48, color: primaryColor.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 20),
            const Text(
              'Busca en el catálogo',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 8),
            Text(
              'Escribe el nombre del producto, marca o código',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'CONSEJOS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey.shade400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _TipRow(icon: Icons.label_outline, text: 'Por nombre: "Agua Cristal"'),
            _TipRow(icon: Icons.qr_code_outlined, text: 'Por código: "7702001"'),
            _TipRow(icon: Icons.business_outlined, text: 'Por marca: "Postobón"'),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Desktop: grilla igual que el catálogo ─────────────────────────────────

  Widget _buildDesktopResults(List<ProductEntity> products, double width) {
    final cols = _gridColumns(width);
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                Text(
                  'Resultados',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${products.length} productos',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 32),
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
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

  // ── Mobile: lista compacta ────────────────────────────────────────────────

  Widget _buildMobileResults(
    List<ProductEntity> products,
    LocaleConfig locale,
    Color primaryColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: Text(
            '${products.length} resultado${products.length != 1 ? 's' : ''}',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 24),
            itemCount: products.length,
            itemBuilder: (_, i) => _SearchResultCard(
              product: products[i],
              locale: locale,
              primaryColor: primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Skeleton desktop: grilla ──────────────────────────────────────────────────

class _SearchGridSkeleton extends StatelessWidget {
  const _SearchGridSkeleton({required this.columns});
  final int columns;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 24),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: columns * 3,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.68,
        ),
        itemBuilder: (_, _) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerBox(height: 130, radius: 10),
              Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 12, width: double.infinity),
                    SizedBox(height: 5),
                    ShimmerBox(height: 12, width: 100),
                    SizedBox(height: 10),
                    ShimmerBox(height: 16, width: 80),
                    SizedBox(height: 10),
                    ShimmerBox(height: 28),
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

// ── Skeleton mobile: lista ────────────────────────────────────────────────────

class _SearchListSkeleton extends StatelessWidget {
  const _SearchListSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 24),
      itemCount: 8,
      itemBuilder: (_, _) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Row(
          children: [
            ShimmerBox(height: 60, width: 60, radius: 10),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14, width: double.infinity),
                  SizedBox(height: 6),
                  ShimmerBox(height: 11, width: 120),
                  SizedBox(height: 10),
                  ShimmerBox(height: 16, width: 90),
                ],
              ),
            ),
            SizedBox(width: 12),
            ShimmerBox(height: 14, width: 20, radius: 4),
          ],
        ),
      ),
    );
  }
}

// ── Card resultado mobile ─────────────────────────────────────────────────────

class _SearchResultCard extends StatelessWidget {
  const _SearchResultCard({
    required this.product,
    required this.locale,
    required this.primaryColor,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => context.push('/product/${product.sku}'),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFEEEEEE)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: (product.imageUrl != null &&
                            product.imageUrl!.isNotEmpty)
                        ? CachedNetworkImage(
                            imageUrl: product.imageUrl!,
                            fit: BoxFit.contain,
                            placeholder: (_, _) => const Icon(
                              Icons.inventory_2_outlined,
                              size: 26,
                              color: Color(0xFFCFD8DC),
                            ),
                            errorWidget: (_, _, _) => const Icon(
                              Icons.inventory_2_outlined,
                              size: 26,
                              color: Color(0xFFCFD8DC),
                            ),
                          )
                        : const Icon(Icons.inventory_2_outlined,
                            size: 26, color: Color(0xFFCFD8DC)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SKU: ${product.sku}',
                        style: const TextStyle(
                            fontSize: 11, color: Color(0xFF9E9E9E)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      CurrencyFormatter.format(product.finalPrice, locale),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(Icons.chevron_right_rounded,
                        size: 20, color: Colors.grey.shade300),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tip helper ────────────────────────────────────────────────────────────────

class _TipRow extends StatelessWidget {
  const _TipRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade400),
          const SizedBox(width: 10),
          Text(text,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}
