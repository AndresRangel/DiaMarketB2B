# Page Override: ShimmerBox

## Problem: Hardcoded Colors

```dart
// CURRENT — hardcoded grays, breaks on dark themes or unusual backgrounds
baseColor: const Color(0xFFE0E0E0),
highlightColor: const Color(0xFFF5F5F5),
```

## Fix: Theme-Derived Colors

ShimmerBox needs to accept theme colors. Two approaches:

### Option A: Pass colors explicitly (pure widget)
```dart
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    super.key,
    required this.height,
    this.width = double.infinity,
    this.radius = 8,
    this.baseColor,      // null = use theme default
    this.highlightColor, // null = use theme default
  });

  final double height;
  final double width;
  final double radius;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Shimmer.fromColors(
      baseColor: baseColor ?? theme.colorScheme.onSurface.withValues(alpha: 0.10),
      highlightColor: highlightColor ?? theme.colorScheme.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white, // shimmer package requires white
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
```

### Option B: ConsumerWidget with themeProvider (preferred for this project)
```dart
class ShimmerBox extends ConsumerWidget {
  // ... same params ...

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Shimmer.fromColors(
      baseColor: theme.theme.textSecondaryColor.withValues(alpha: 0.12),
      highlightColor: theme.theme.surfaceColor,
      child: Container(...),
    );
  }
}
```

Option B is preferred — consistent with project's theming approach.
