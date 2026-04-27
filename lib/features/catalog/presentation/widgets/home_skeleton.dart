import 'package:flutter/material.dart';

import '../../../../shared/widgets/shimmer_box.dart';

/// Skeleton loading del Home. Dibuja el esqueleto de todas las secciones
/// mientras el catálogo carga. Mismo layout que el Home real.
class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGreetingSkeleton(),
          const SizedBox(height: 10),
          _buildBannerSkeleton(),
          const SizedBox(height: 10),
          _buildCategoriesSkeleton(),
          const SizedBox(height: 12),
          _buildFeaturedSkeleton(),
          const SizedBox(height: 12),
          _buildGridSkeleton(),
        ],
      ),
    );
  }

  // ── Banner ────────────────────────────────────────────────────────────────

  Widget _buildBannerSkeleton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
      child: const Column(
        children: [
          ShimmerBox(height: 170, radius: 14),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ShimmerBox(height: 6, width: 20, radius: 3),
              SizedBox(width: 6),
              ShimmerBox(height: 6, width: 6, radius: 3),
              SizedBox(width: 6),
              ShimmerBox(height: 6, width: 6, radius: 3),
            ],
          ),
        ],
      ),
    );
  }

  // ── Greeting ───────────────────────────────────────────────────────────────

  Widget _buildGreetingSkeleton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: 14, width: 180),
          SizedBox(height: 8),
          ShimmerBox(height: 22, width: 240),
          SizedBox(height: 6),
          ShimmerBox(height: 13, width: 140),
        ],
      ),
    );
  }

  // ── Categorías ─────────────────────────────────────────────────────────────

  Widget _buildCategoriesSkeleton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(height: 16, width: 100),
              ShimmerBox(height: 14, width: 70),
            ],
          ),
          const SizedBox(height: 16),
          // Circles
          SizedBox(
            height: 96,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 7,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (_, _) => const Column(
                children: [
                  ShimmerBox(height: 60, width: 60, radius: 30),
                  SizedBox(height: 6),
                  ShimmerBox(height: 11, width: 58),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Destacados ─────────────────────────────────────────────────────────────

  Widget _buildFeaturedSkeleton() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 14, 0, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerBox(height: 16, width: 100),
                ShimmerBox(height: 14, width: 70),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (_, _) => const SizedBox(
                width: 140,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(height: 130, width: 140, radius: 10),
                    SizedBox(height: 8),
                    ShimmerBox(height: 12, width: 120),
                    SizedBox(height: 4),
                    ShimmerBox(height: 12, width: 80),
                    SizedBox(height: 6),
                    ShimmerBox(height: 16, width: 90),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Grid de productos ──────────────────────────────────────────────────────

  Widget _buildGridSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: ShimmerBox(height: 16, width: 140),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (_, _) => const _ProductCardSkeleton(),
          ),
        ],
      ),
    );
  }
}

// ── Product card skeleton ──────────────────────────────────────────────────────

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ShimmerBox(height: 120, radius: 10),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 11, width: double.infinity),
                SizedBox(height: 4),
                ShimmerBox(height: 11, width: 100),
                SizedBox(height: 8),
                ShimmerBox(height: 16, width: 80),
                SizedBox(height: 8),
                ShimmerBox(height: 28),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
