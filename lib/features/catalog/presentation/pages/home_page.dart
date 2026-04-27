import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/responsive/breakpoints.dart';
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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _selectedCategoryId;

  // Saludo según hora del día
  String get _greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Buenos días';
    if (h < 18) return 'Buenas tardes';
    return 'Buenas noches';
  }

  // Columnas de grilla según ancho de pantalla
  int _gridColumns(double width) {
    if (width >= Breakpoints.desktop) return 4;
    if (width >= Breakpoints.tablet) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final catalogState = ref.watch(catalogProvider);
    final config = ref.watch(themeProvider);
    final authState = ref.watch(authProvider);

    final session =
        authState is AuthStateAuthenticated ? authState.session : null;
    final primaryColor = config.theme.primaryColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: context.isDesktop ? null : _buildAppBar(config, session, primaryColor),
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
          final filtered = _selectedCategoryId == null
              ? catalog.products
              : catalog.products
                  .where((p) => p.categoryId == _selectedCategoryId)
                  .toList();
          // Primeros 10 productos para "Destacados"
          final featured = catalog.products.take(10).toList();

          return RefreshIndicator(
            onRefresh: () => ref.read(catalogProvider.notifier).refresh(),
            child: CustomScrollView(
              slivers: [
                // ── Greeting ──────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _GreetingSection(
                    greeting: _greeting,
                    username: session?.user.username,
                    companyName: session?.selectedCompany.name,
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // ── Banner carousel ───────────────────────────────────────
                if (catalog.products.isNotEmpty)
                  SliverToBoxAdapter(
                    child: BannerCarousel(
                      // Prioriza productos con imagen para los banners
                      products: ([...catalog.products]
                            ..sort((a, b) {
                              final aHasImg =
                                  a.imageUrl?.isNotEmpty == true ? 0 : 1;
                              final bHasImg =
                                  b.imageUrl?.isNotEmpty == true ? 0 : 1;
                              return aHasImg.compareTo(bHasImg);
                            }))
                          .take(5)
                          .toList(),
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // ── Categorías ────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: _CategoriesSection(
                    categories: rootCategories,
                    selectedId: _selectedCategoryId,
                    primaryColor: primaryColor,
                    onSelected: (id) =>
                        setState(() => _selectedCategoryId = id),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 10)),

                // ── Destacados ────────────────────────────────────────────
                if (_selectedCategoryId == null && featured.isNotEmpty) ...[
                  SliverToBoxAdapter(
                    child: _FeaturedSection(products: featured),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 10)),
                ],

                // ── Header grilla ─────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        const EdgeInsets.fromLTRB(16, 4, 16, 10),
                    child: Row(
                      children: [
                        Text(
                          _selectedCategoryId == null
                              ? 'Catálogo'
                              : rootCategories
                                  .firstWhere(
                                      (c) => c.id == _selectedCategoryId,
                                      orElse: () => rootCategories.first)
                                  .name
                                  .split(' - ')
                                  .first,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${filtered.length} productos',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Grilla de productos ───────────────────────────────────
                filtered.isEmpty
                    ? const SliverFillRemaining(
                        child: Center(
                          child: Text(
                            'Sin productos en esta categoría',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: _gridColumns(
                                MediaQuery.sizeOf(context).width),
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.68,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (_, i) => ProductCard(product: filtered[i]),
                            childCount: filtered.length,
                          ),
                        ),
                      ),
              ],
            ),
          );
        },
      ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    RemoteAppConfig config,
    AuthSessionEntity? session,
    Color primaryColor,
  ) {
    final isDesktop = context.isDesktop;

    return AppBar(
      backgroundColor: primaryColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      // Hamburger solo en móvil — en desktop el sidebar ya está visible.
      leading: isDesktop
          ? null
          : IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => mainScaffoldKey.currentState?.openDrawer(),
            ),
      titleSpacing: 12,
      title: Row(
        children: [
          // Logo pequeño
          if (config.branding.logoLightUrl.isNotEmpty ||
              config.branding.logoUrl.isNotEmpty)
            Container(
              height: 32,
              constraints: const BoxConstraints(maxWidth: 80),
              child: CachedNetworkImage(
                imageUrl: config.branding.logoLightUrl.isNotEmpty
                    ? config.branding.logoLightUrl
                    : config.branding.logoUrl,
                fit: BoxFit.contain,
                errorWidget: (_, _, _) => const SizedBox.shrink(),
                placeholder: (_, _) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (session?.selectedCompany.name != null)
                  Text(
                    session!.selectedCompany.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                Text(
                  config.branding.appName,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.75),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          tooltip: 'Buscar',
          onPressed: () => context.push('/search'),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          tooltip: 'Notificaciones',
          onPressed: () {},
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ── Greeting section ──────────────────────────────────────────────────────────

class _GreetingSection extends StatelessWidget {
  const _GreetingSection({
    required this.greeting,
    this.username,
    this.companyName,
  });

  final String greeting;
  final String? username;
  final String? companyName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            greeting,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            username ?? 'Bienvenido',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
            ),
          ),
          if (companyName != null) ...[
            const SizedBox(height: 3),
            Row(
              children: [
                Icon(Icons.business_outlined,
                    size: 13, color: Colors.grey.shade500),
                const SizedBox(width: 4),
                Text(
                  companyName!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

// ── Categories section ────────────────────────────────────────────────────────

class _CategoriesSection extends StatelessWidget {
  const _CategoriesSection({
    required this.categories,
    required this.selectedId,
    required this.primaryColor,
    required this.onSelected,
  });

  final List<CategoryEntity> categories;
  final String? selectedId;
  final Color primaryColor;
  final void Function(String? id) onSelected;

  // Paleta de colores para los íconos de categoría
  static const _palette = [
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFFE65100),
    Color(0xFF6A1B9A),
    Color(0xFFC62828),
    Color(0xFF00838F),
    Color(0xFF4E342E),
    Color(0xFF37474F),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categorías',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () => onSelected(null),
                child: Text(
                  'Ver todas',
                  style: TextStyle(
                    fontSize: 12,
                    color: primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Carousel de categorías
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length + 1, // +1 para "Todos"
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, i) {
                if (i == 0) {
                  return _CategoryItem(
                    label: 'Todos',
                    color: primaryColor,
                    isSelected: selectedId == null,
                    onTap: () => onSelected(null),
                    icon: Icons.apps_rounded,
                  );
                }
                final cat = categories[i - 1];
                final color = _palette[(i - 1) % _palette.length];
                return _CategoryItem(
                  label: _short(cat.name),
                  color: color,
                  isSelected: selectedId == cat.id,
                  imageUrl: cat.imageUrl,
                  onTap: () =>
                      onSelected(selectedId == cat.id ? null : cat.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _short(String name) {
    final part = name.split(' - ').first.trim();
    return part.length > 10 ? '${part.substring(0, 9)}…' : part;
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
    this.icon,
    this.imageUrl,
  });

  final String label;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;
  /// Ícono fijo (solo para "Todos")
  final IconData? icon;
  /// URL de imagen de la categoría desde el backend. Tiene prioridad sobre icon.
  final String? imageUrl;

  bool get _hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 68,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _hasImage
                    ? Colors.transparent
                    : (isSelected ? color : color.withValues(alpha: 0.1)),
                shape: BoxShape.circle,
                border: isSelected
                    ? Border.all(color: color, width: 2.5)
                    : (_hasImage
                        ? Border.all(color: Colors.grey.shade200, width: 1.5)
                        : null),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: ClipOval(child: _buildCircleContent()),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? color : const Color(0xFF555555),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleContent() {
    // 1. Imagen del backend
    if (_hasImage) {
      return CachedNetworkImage(
        imageUrl: imageUrl!,
        fit: BoxFit.cover,
        width: 60,
        height: 60,
        placeholder: (_, _) => _fallbackIcon(),
        errorWidget: (_, _, _) => _fallbackIcon(),
      );
    }

    // 2. Ícono fijo (item "Todos")
    if (icon != null) {
      return Container(
        color: isSelected ? color : color.withValues(alpha: 0.1),
        child: Center(
          child: Icon(icon, color: isSelected ? Colors.white : color, size: 26),
        ),
      );
    }

    // 3. Fallback: tiendita + fondo de color
    return _fallbackIcon();
  }

  Widget _fallbackIcon() {
    return Container(
      color: isSelected ? color : color.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.storefront_outlined,
          color: isSelected ? Colors.white : color,
          size: 26,
        ),
      ),
    );
  }
}

// ── Featured section ──────────────────────────────────────────────────────────

class _FeaturedSection extends StatelessWidget {
  const _FeaturedSection({required this.products});

  final List<ProductEntity> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Destacados',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    'Ver más',
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Scroll horizontal de cards destacadas
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, i) =>
                  FeaturedProductCard(product: products[i]),
              padding: const EdgeInsets.only(right: 16),
            ),
          ),
        ],
      ),
    );
  }
}
