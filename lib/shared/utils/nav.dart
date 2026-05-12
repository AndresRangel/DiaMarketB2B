import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/responsive/breakpoints.dart';
import '../../features/catalog/presentation/pages/product_detail_page.dart';

extension NavigationX on BuildContext {
  /// Mobile → bottom sheet draggable. Desktop → full page.
  ///
  /// Si se llama desde dentro de otro sheet (PopupRoute), cierra el actual
  /// primero y abre el nuevo en el siguiente frame — evita apilar sheets.
  void openProductDetail(String sku) {
    if (MediaQuery.sizeOf(this).width >= Breakpoints.tablet) {
      final currentPath = GoRouterState.of(this).uri.path;
      if (currentPath.startsWith('/product/')) {
        pushReplacement('/product/$sku');
      } else {
        push('/product/$sku');
      }
      return;
    }

    // Detectar si estamos dentro de un modal (bottom sheet)
    final isInsideSheet = ModalRoute.of(this) is PopupRoute;

    if (isInsideSheet) {
      // Guardar el navigator ANTES del pop — su contexto sobrevive
      final nav = Navigator.of(this);
      nav.pop();
      // Abrir nuevo sheet en el siguiente frame, desde el contexto del navigator
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (nav.context.mounted) {
          _showSheet(nav.context, sku);
        }
      });
      return;
    }

    _showSheet(this, sku);
  }
}

void _showSheet(BuildContext context, String sku) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    useSafeArea: true,
    builder: (_) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.93,
      minChildSize: 0.0,
      maxChildSize: 0.93,
      shouldCloseOnMinExtent: true,
      snap: true,
      builder: (_, scrollController) => ProductDetailPage(
        sku: sku,
        isSheet: true,
        scrollController: scrollController,
      ),
    ),
  );
}
