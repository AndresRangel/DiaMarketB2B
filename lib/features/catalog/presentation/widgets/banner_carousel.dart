import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/product_entity.dart';

/// Carrusel de banners en el Home. Auto-avanza cada [autoPlaySeconds] segundos.
/// Por ahora usa [products] aleatorios como contenido de los banners.
/// En Fase 2/4 se conectará a productos marcados o banners del backend (S38).
class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({
    super.key,
    required this.products,
    this.autoPlaySeconds = 3,
  });

  final List<ProductEntity> products;
  final int autoPlaySeconds;

  @override
  ConsumerState<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends ConsumerState<BannerCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;

  // Máximo 5 banners para no saturar
  List<ProductEntity> get _items => widget.products.take(5).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1);
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(
      Duration(seconds: widget.autoPlaySeconds),
      (_) {
        if (!_pageController.hasClients) return;
        final next = (_currentPage + 1) % _items.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 450),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_items.isEmpty) return const SizedBox.shrink();

    final locale = ref.watch(themeProvider.select((c) => c.locale));
    final primaryColor = ref.watch(themeProvider.select((c) => c.theme.primaryColor));

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          // ── PageView de banners ────────────────────────────────────────
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: _BannerCard(
                  product: _items[i],
                  locale: locale,
                  primaryColor: primaryColor,
                ),
              ),
            ),
          ),

          // ── Indicadores de página ──────────────────────────────────────
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
              (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 280),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: i == _currentPage ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: i == _currentPage
                      ? primaryColor
                      : primaryColor.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Banner card individual ────────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  const _BannerCard({
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
      onTap: () => context.push('/product/${product.sku}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ── Fondo: imagen del producto ─────────────────────────────
            _buildBackground(),

            // ── Gradiente oscuro inferior ──────────────────────────────
            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.35, 1.0],
                  colors: [
                    Colors.transparent,
                    Color(0xCC1A1A2E),
                  ],
                ),
              ),
            ),

            // ── Badge "Destacado" ──────────────────────────────────────
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Destacado',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),

            // ── Info inferior ──────────────────────────────────────────
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Nombre + precio
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            shadows: [
                              Shadow(color: Colors.black26, blurRadius: 4),
                            ],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(product.basePrice, locale),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botón ver
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Ver',
                      style: TextStyle(
                        color: primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    // Si hay imagen: usa CachedNetworkImage con BoxFit.cover (banners sí son cover)
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.cover,
        placeholder: (_, _) => _colorFallback(),
        errorWidget: (_, _, _) => _colorFallback(),
      );
    }
    return _colorFallback();
  }

  Widget _colorFallback() {
    // Gradiente de color cuando no hay imagen
    final colors = [
      [const Color(0xFF1565C0), const Color(0xFF0D47A1)],
      [const Color(0xFF2E7D32), const Color(0xFF1B5E20)],
      [const Color(0xFFE65100), const Color(0xFFBF360C)],
      [const Color(0xFF6A1B9A), const Color(0xFF4A148C)],
    ];
    final idx = product.sku.hashCode.abs() % colors.length;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors[idx],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: 56,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
