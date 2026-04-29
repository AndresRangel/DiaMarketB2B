import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/responsive_extensions.dart';
import '../../../../core/shell/shell_key.dart';
import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
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
      backgroundColor: const Color(0xFFF2F4F7),
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
                onRefresh: () =>
                    ref.read(catalogProvider.notifier).refresh(),
                child: CustomScrollView(
                  slivers: [
                    // ── Banners ──────────────────────────────────────────
                    if (catalog.products.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
                          child: BannerCarousel(
                            products: ([...catalog.products]
                                  ..sort((a, b) {
                                    final aImg =
                                        a.imageUrl?.isNotEmpty == true
                                            ? 0
                                            : 1;
                                    final bImg =
                                        b.imageUrl?.isNotEmpty == true
                                            ? 0
                                            : 1;
                                    return aImg.compareTo(bImg);
                                  }))
                                .take(5)
                                .toList(),
                          ),
                        ),
                      ),

                    // ── Categorías ───────────────────────────────────────
                    if (rootCategories.isNotEmpty) ...[
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Categorías',
                          actionLabel: 'Ver todas',
                          primaryColor: primary,
                          onAction: () => context.push('/products'),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _CategoryCardGrid(
                          categories: rootCategories,
                          primaryColor: primary,
                          products: catalog.products,
                        ),
                      ),
                    ],

                    // ── Destacados ───────────────────────────────────────
                    if (featured.isNotEmpty) ...[
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Destacados',
                          primaryColor: primary,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _HorizontalProductScroll(products: featured),
                      ),
                    ],

                    // ── Más comprados ────────────────────────────────────
                    if (mostPurchased.isNotEmpty) ...[
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Más comprados',
                          primaryColor: primary,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _HorizontalProductScroll(
                            products: mostPurchased),
                      ),
                    ],

                    // ── Ofertas del día ──────────────────────────────────
                    if (offers.isNotEmpty) ...[
                      const SliverToBoxAdapter(child: SizedBox(height: 8)),
                      SliverToBoxAdapter(
                        child: _SectionHeader(
                          title: 'Ofertas del día',
                          primaryColor: primary,
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: _HorizontalProductScroll(products: offers),
                      ),
                    ],

                    const SliverToBoxAdapter(child: SizedBox(height: 32)),
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

// ── AppBar moderno con búsqueda ───────────────────────────────────────────────

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
            // ── Logo + empresa + notificaciones ───────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 2, 8, 0),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (session?.selectedCompany.name != null)
                    Container(
                      constraints: const BoxConstraints(maxWidth: 140),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        session!.selectedCompany.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.notifications_outlined,
                        color: Colors.white, size: 22),
                    onPressed: () {},
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),

            // ── Search bar ────────────────────────────────────────────
            GestureDetector(
              onTap: () => context.push('/search'),
              child: Container(
                height: 44,
                margin: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(Icons.search, color: Colors.grey.shade400, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      'Buscar productos...',
                      style:
                          TextStyle(color: Colors.grey.shade400, fontSize: 14),
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

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.primaryColor,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final Color primaryColor;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Row(
                children: [
                  Text(
                    actionLabel!,
                    style: TextStyle(
                      fontSize: 13,
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(Icons.chevron_right, size: 16, color: primaryColor),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ── Category cards ────────────────────────────────────────────────────────────

class _CategoryCardGrid extends StatelessWidget {
  const _CategoryCardGrid({
    required this.categories,
    required this.primaryColor,
    required this.products,
  });

  final List<CategoryEntity> categories;
  final Color primaryColor;
  final List<ProductEntity> products;

  static IconData _icon(String name) {
    final n = name.toLowerCase();
    if (n.contains('bebida') || n.contains('jugo') || n.contains('refresco')) return Icons.local_drink_outlined;
    if (n.contains('licor') || n.contains('aguardient') || n.contains('vino') || n.contains('whisky') || n.contains('cerveza')) return Icons.wine_bar_outlined;
    if (n.contains('lácteo') || n.contains('lacteo') || n.contains('leche')) return Icons.egg_alt_outlined;
    if (n.contains('panade') || n.contains('pan ') || n.contains('pastel')) return Icons.bakery_dining_outlined;
    if (n.contains('limpieza') || n.contains('aseo hogar') || n.contains('detergente')) return Icons.cleaning_services_outlined;
    if (n.contains('personal') || n.contains('higiene') || n.contains('cuidado')) return Icons.face_retouching_natural_outlined;
    if (n.contains('snack') || n.contains('dulce') || n.contains('confite') || n.contains('galleta')) return Icons.cookie_outlined;
    if (n.contains('congelad') || n.contains('helado')) return Icons.ac_unit_outlined;
    if (n.contains('carne') || n.contains('pollo') || n.contains('cerdo')) return Icons.set_meal_outlined;
    if (n.contains('fruta') || n.contains('verdura') || n.contains('vegetal')) return Icons.local_florist_outlined;
    if (n.contains('despensa') || n.contains('granos') || n.contains('arroz') || n.contains('aceite')) return Icons.kitchen_outlined;
    if (n.contains('mascota')) return Icons.pets_outlined;
    if (n.contains('bebé') || n.contains('bebe') || n.contains('infantil')) return Icons.child_care_outlined;
    if (n.contains('tabaco') || n.contains('cigarro')) return Icons.smoking_rooms_outlined;
    if (n.contains('papel') || n.contains('servilleta') || n.contains('toalla')) return Icons.article_outlined;
    return Icons.storefront_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;

    if (isDesktop) {
      final width = MediaQuery.sizeOf(context).width;
      final cols = width >= 1400 ? 8 : width >= 1100 ? 7 : 6;
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (_, i) {
            final cat = categories[i];
            return _CategoryCard(
              category: cat,
              primaryColor: primaryColor,
              icon: _icon(cat.name),
              onTap: () => context.push(
                '/products?categoryId=${cat.id}&name=${Uri.encodeComponent(cat.name.split(' - ').first.trim())}',
              ),
            );
          },
        ),
      );
    }

    // Mobile: scroll horizontal
    return SizedBox(
      height: 148,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final cat = categories[i];
          return _CategoryCard(
            category: cat,
            primaryColor: primaryColor,
            icon: _icon(cat.name),
            onTap: () => context.push(
              '/products?categoryId=${cat.id}&name=${Uri.encodeComponent(cat.name.split(' - ').first.trim())}',
            ),
          );
        },
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({
    required this.category,
    required this.primaryColor,
    required this.icon,
    required this.onTap,
  });

  final CategoryEntity category;
  final Color primaryColor;
  final IconData icon;
  final VoidCallback onTap;

  bool get _hasImage =>
      category.imageUrl != null && category.imageUrl!.isNotEmpty;

  String get _label => category.name.split(' - ').first.trim();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(12, 16, 12, 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Badge con ícono o imagen
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: _hasImage
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: CachedNetworkImage(
                          imageUrl: category.imageUrl!,
                          fit: BoxFit.contain,
                          placeholder: (_, _) => _iconWidget(),
                          errorWidget: (_, _, _) => _iconWidget(),
                        ),
                      ),
                    )
                  : _iconWidget(),
            ),
            const SizedBox(height: 10),
            // Nombre
            Text(
              _label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconWidget() => Center(
        child: Icon(icon, size: 28, color: primaryColor),
      );
}

// ── Horizontal product scroll (Destacados / Ofertas) ─────────────────────────

class _HorizontalProductScroll extends StatelessWidget {
  const _HorizontalProductScroll({required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (_, i) => FeaturedProductCard(product: products[i]),
      ),
    );
  }
}
