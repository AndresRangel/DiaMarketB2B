import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/utils/nav.dart';

import '../../../../core/theme/app_config_model.dart';
import '../../../../core/theme/theme_notifier.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/constants/app_text_styles.dart';
import '../../domain/entities/product_entity.dart';

/// Carrusel de banners en el Home. Auto-avanza cada [autoPlaySeconds] segundos.
/// Se pausa al hacer hover (desktop). En Fase 2/4 se conectará a S38.
class BannerCarousel extends ConsumerStatefulWidget {
  const BannerCarousel({
    super.key,
    required this.products,
    this.autoPlaySeconds = 4,
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
  bool _hovered = false;

  List<ProductEntity> get _items => widget.products.take(5).toList();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(
      Duration(seconds: widget.autoPlaySeconds),
      (_) {
        if (_hovered || !_pageController.hasClients) return;
        final next = (_currentPage + 1) % _items.length;
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 400),
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
    final theme = ref.watch(themeProvider);
    final primary = theme.theme.primaryColor;
    final background = theme.theme.backgroundColor;

    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final bannerHeight = isDesktop ? 240.0 : 180.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        color: theme.theme.surfaceColor,
        padding: const EdgeInsets.only(bottom: AppSpacing.md),
        child: Column(
          children: [
            SizedBox(
              height: bannerHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: _items.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md, AppSpacing.md, AppSpacing.md, 0),
                  child: _BannerCard(
                    product: _items[i],
                    locale: locale,
                    primaryColor: primary,
                    backgroundColor: background,
                    isDesktop: isDesktop,
                  ),
                ),
              ),
            ),

            // ── Indicadores de página ────────────────────────────────────
            const SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _items.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _currentPage ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? primary
                        : primary.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(AppRadius.full),
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

// ── Banner card — split layout ────────────────────────────────────────────────

class _BannerCard extends StatelessWidget {
  const _BannerCard({
    required this.product,
    required this.locale,
    required this.primaryColor,
    required this.backgroundColor,
    required this.isDesktop,
  });

  final ProductEntity product;
  final LocaleConfig locale;
  final Color primaryColor;
  final Color backgroundColor;
  final bool isDesktop;

  // Oscurece el color para el gradiente interno
  Color get _primaryDark {
    final hsl = HSLColor.fromColor(primaryColor);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discount > 0;
    final discountedPrice = product.basePrice - product.discountAmount;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.openProductDetail(product.sku),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Row(
            children: [
              // ── Izquierda: gradiente primario + info ─────────────────────
              Expanded(
                flex: isDesktop ? 42 : 50,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [primaryColor, _primaryDark],
                    ),
                  ),
                  padding: EdgeInsets.all(
                      isDesktop ? AppSpacing.xl : AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge
                      _Badge(
                        hasDiscount: hasDiscount,
                        discount: product.discount,
                        primaryColor: primaryColor,
                      ),
                      SizedBox(
                          height: isDesktop ? AppSpacing.md : AppSpacing.sm),

                      // Nombre
                      Text(
                        product.name,
                        style: (isDesktop
                                ? AppTextStyles.titleMedium
                                : AppTextStyles.titleSmall)
                            .copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          shadows: const [
                            Shadow(
                                color: Colors.black26, blurRadius: 4),
                          ],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.xs),

                      // Precio
                      if (hasDiscount) ...[
                        Text(
                          CurrencyFormatter.format(product.basePrice, locale),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: Colors.white.withValues(alpha: 0.6),
                            decoration: TextDecoration.lineThrough,
                            decorationColor:
                                Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                        Text(
                          CurrencyFormatter.format(discountedPrice, locale),
                          style: (isDesktop
                                  ? AppTextStyles.priceMedium
                                  : AppTextStyles.priceSmall)
                              .copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ] else
                        Text(
                          CurrencyFormatter.format(product.basePrice, locale),
                          style: (isDesktop
                                  ? AppTextStyles.priceMedium
                                  : AppTextStyles.priceSmall)
                              .copyWith(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                      SizedBox(
                          height: isDesktop ? AppSpacing.md : AppSpacing.sm),

                      // CTA
                      _CtaButton(isDesktop: isDesktop),
                    ],
                  ),
                ),
              ),

              // ── Derecha: imagen contenida sobre fondo neutro ─────────────
              Expanded(
                flex: isDesktop ? 58 : 50,
                child: Container(
                  color: backgroundColor,
                  padding: EdgeInsets.all(
                      isDesktop ? AppSpacing.xl : AppSpacing.md),
                  child: _buildImage(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (product.imageUrl != null && product.imageUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: product.imageUrl!,
        fit: BoxFit.contain,
        placeholder: (_, _) => _imagePlaceholder(),
        errorWidget: (_, _, _) => _imagePlaceholder(),
      );
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() => Center(
        child: Icon(
          Icons.inventory_2_outlined,
          size: isDesktop ? 72 : 52,
          color: primaryColor.withValues(alpha: 0.20),
        ),
      );
}

// ── Badge dinámico ────────────────────────────────────────────────────────────

class _Badge extends StatelessWidget {
  const _Badge({
    required this.hasDiscount,
    required this.discount,
    required this.primaryColor,
  });

  final bool hasDiscount;
  final double discount;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    if (hasDiscount) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFE53935),
          borderRadius: BorderRadius.circular(AppRadius.xs),
        ),
        child: Text(
          '-${(discount * 100).round()}% OFF',
          style: AppTextStyles.labelSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      );
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(AppRadius.xs),
        border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
      ),
      child: Text(
        'Destacado',
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ── CTA button ────────────────────────────────────────────────────────────────

class _CtaButton extends StatelessWidget {
  const _CtaButton({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? AppSpacing.md : AppSpacing.sm,
        vertical: isDesktop ? AppSpacing.sm : AppSpacing.xs + 2,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Ver producto',
            style: AppTextStyles.labelMedium.copyWith(
              color: const Color(0xFF1A1A2E),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(Icons.arrow_forward_rounded,
              size: 14, color: Color(0xFF1A1A2E)),
        ],
      ),
    );
  }
}
