import 'package:flutter/material.dart';

import '../../../../shared/constants/app_radius.dart';
import '../../../../shared/constants/app_spacing.dart';
import '../../../../shared/widgets/shimmer_box.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width >= 900;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.sm),
          _BannerSkeleton(isDesktop: isDesktop),
          _SectionHeaderSkeleton(),
          _CategoryTilesSkeleton(isDesktop: isDesktop, width: width),
          _SectionHeaderSkeleton(withAction: true),
          _ProductCarouselSkeleton(isDesktop: isDesktop, width: width),
          const SizedBox(height: AppSpacing.sm),
          _SectionHeaderSkeleton(withAction: true),
          _RankedListSkeleton(isDesktop: isDesktop, width: width),
        ],
      ),
    );
  }
}

// ── Banner ────────────────────────────────────────────────────────────────────

class _BannerSkeleton extends StatelessWidget {
  const _BannerSkeleton({required this.isDesktop});
  final bool isDesktop;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
      child: Column(
        children: [
          ShimmerBox(
            height: isDesktop ? 220 : 170,
            radius: AppRadius.lg,
          ),
          const SizedBox(height: 10),
          // Indicadores de punto
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const ShimmerBox(height: 6, width: 18, radius: 3),
              const SizedBox(width: 5),
              const ShimmerBox(height: 6, width: 6, radius: 3),
              const SizedBox(width: 5),
              const ShimmerBox(height: 6, width: 6, radius: 3),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Section header ────────────────────────────────────────────────────────────

class _SectionHeaderSkeleton extends StatelessWidget {
  const _SectionHeaderSkeleton({this.withAction = false});
  final bool withAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.base, AppSpacing.base, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ShimmerBox(height: 18, width: 120),
          if (withAction) const ShimmerBox(height: 14, width: 60),
        ],
      ),
    );
  }
}

// ── Category tiles carousel ───────────────────────────────────────────────────
// Coincide con el nuevo diseño de _HorizontalCarousel en home_page.dart.

class _CategoryTilesSkeleton extends StatelessWidget {
  const _CategoryTilesSkeleton(
      {required this.isDesktop, required this.width});
  final bool isDesktop;
  final double width;

  @override
  Widget build(BuildContext context) {
    // Desktop: si caben en 2 filas → grid, si no → carrusel
    final cols = isDesktop
        ? (width >= 1400 ? 8 : (width >= 1100 ? 7 : 6))
        : 4;
    final tileCount = isDesktop ? (cols * 2) : 6;
    final tileWidth = isDesktop ? 88.0 : 76.0;
    final tileHeight = isDesktop ? 104.0 : 96.0;

    if (isDesktop) {
      // Grid estático
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: tileCount,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (_, _) => _CategoryTileSkeleton(),
        ),
      );
    }

    // Mobile: carrusel horizontal
    return SizedBox(
      height: tileHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.sm),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: tileCount,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, _) =>
            SizedBox(width: tileWidth, child: _CategoryTileSkeleton()),
      ),
    );
  }
}

class _CategoryTileSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          ShimmerBox(height: 48, width: 48, radius: AppRadius.md),
          SizedBox(height: 8),
          ShimmerBox(height: 10, width: 48, radius: 4),
          SizedBox(height: 3),
          ShimmerBox(height: 10, width: 36, radius: 4),
        ],
      ),
    );
  }
}

// ── Product carousel (horizontal) ────────────────────────────────────────────

class _ProductCarouselSkeleton extends StatelessWidget {
  const _ProductCarouselSkeleton(
      {required this.isDesktop, required this.width});
  final bool isDesktop;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      final cols = width >= 1400 ? 5 : (width >= 1100 ? 4 : 3);
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cols,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (_, _) => const _ProductCardSkeleton(),
        ),
      );
    }

    return SizedBox(
      height: 210,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 4,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, _) => const SizedBox(
          width: 152,
          child: _ProductCardSkeleton(),
        ),
      ),
    );
  }
}

// ── Ranked list skeleton ──────────────────────────────────────────────────────

class _RankedListSkeleton extends StatelessWidget {
  const _RankedListSkeleton(
      {required this.isDesktop, required this.width});
  final bool isDesktop;
  final double width;

  @override
  Widget build(BuildContext context) {
    if (isDesktop) {
      final cols = width >= 1400 ? 3 : 2;
      return Padding(
        padding: const EdgeInsets.fromLTRB(
            AppSpacing.base, AppSpacing.md, AppSpacing.base, AppSpacing.xs),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: cols * 2,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: cols,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 3.8,
          ),
          itemBuilder: (_, _) => const _RankedItemSkeleton(),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.base, AppSpacing.sm, AppSpacing.base, AppSpacing.xs),
      child: Column(
        children: List.generate(
          4,
          (i) => Padding(
            padding: EdgeInsets.only(
                bottom: i < 3 ? AppSpacing.sm : 0),
            child: const _RankedItemSkeleton(),
          ),
        ),
      ),
    );
  }
}

// ── Componentes atómicos ──────────────────────────────────────────────────────

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: 120, radius: AppRadius.md),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 10, width: 60, radius: 3),
                SizedBox(height: 5),
                ShimmerBox(height: 11, width: double.infinity),
                SizedBox(height: 4),
                ShimmerBox(height: 11, width: 100),
                SizedBox(height: 8),
                ShimmerBox(height: 16, width: 80),
                SizedBox(height: 8),
                ShimmerBox(height: 36, radius: AppRadius.sm),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RankedItemSkeleton extends StatelessWidget {
  const _RankedItemSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        children: [
          ShimmerBox(height: 20, width: 20, radius: 4),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(height: 56, width: 56, radius: AppRadius.sm),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 12, width: double.infinity),
                SizedBox(height: 5),
                ShimmerBox(height: 12, width: 120),
                SizedBox(height: 6),
                ShimmerBox(height: 14, width: 80),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          ShimmerBox(height: 18, width: 18, radius: 4),
        ],
      ),
    );
  }
}
