import 'package:flutter/material.dart';

import '../../../../shared/widgets/shimmer_box.dart';

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
          const SizedBox(height: 12),
          _buildBannerSkeleton(),
          _buildCategoriesSkeleton(),
          _buildFeaturedSkeleton(),
          const SizedBox(height: 8),
          _buildGridSkeleton(),
        ],
      ),
    );
  }

  Widget _buildBannerSkeleton() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(12, 0, 12, 16),
      child: Column(
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

  Widget _buildCategoriesSkeleton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 14),
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 7,
          separatorBuilder: (_, _) => const SizedBox(width: 8),
          itemBuilder: (_, i) => ShimmerBox(
            height: 40,
            width: i == 0 ? 70.0 : (i % 3 == 0 ? 95.0 : 82.0),
            radius: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ShimmerBox(height: 18, width: 110),
              ShimmerBox(height: 14, width: 60),
            ],
          ),
        ),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (_, _) => const SizedBox(
              width: 152,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 124, width: 152, radius: 14),
                  SizedBox(height: 8),
                  ShimmerBox(height: 11, width: 130),
                  SizedBox(height: 4),
                  ShimmerBox(height: 11, width: 90),
                  SizedBox(height: 6),
                  ShimmerBox(height: 14, width: 80),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGridSkeleton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: ShimmerBox(height: 18, width: 140),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (_, _) => const _ProductCardSkeleton(),
          ),
        ],
      ),
    );
  }
}

class _ProductCardSkeleton extends StatelessWidget {
  const _ProductCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          ShimmerBox(height: 120, radius: 14),
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(height: 11, width: double.infinity),
                SizedBox(height: 4),
                ShimmerBox(height: 11, width: 100),
                SizedBox(height: 8),
                ShimmerBox(height: 17, width: 80),
                SizedBox(height: 8),
                ShimmerBox(height: 34),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
