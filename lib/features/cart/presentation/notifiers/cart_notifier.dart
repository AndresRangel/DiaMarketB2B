import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../../../features/catalog/domain/entities/product_entity.dart';

part 'cart_notifier.g.dart';

@Riverpod(keepAlive: true)
class CartNotifier extends _$CartNotifier {
  @override
  CartEntity build() => const CartEntity();

  void addItem(ProductEntity product) {
    final items = [...state.items];
    final index = items.indexWhere((i) => i.sku == product.sku);

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + 1,
      );
    } else {
      items.add(_itemFromProduct(product));
    }
    state = state.copyWith(items: items);
  }

  void addItemWithQuantity(ProductEntity product, int quantity) {
    if (quantity <= 0) return;
    final items = [...state.items];
    final index = items.indexWhere((i) => i.sku == product.sku);

    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + quantity,
      );
    } else {
      items.add(_itemFromProduct(product, quantity: quantity));
    }
    state = state.copyWith(items: items);
  }

  void removeItem(String sku) {
    state = state.copyWith(
      items: state.items.where((i) => i.sku != sku).toList(),
    );
  }

  void updateQuantity(String sku, int quantity) {
    if (quantity <= 0) {
      removeItem(sku);
      return;
    }
    state = state.copyWith(
      items: state.items
          .map((i) => i.sku == sku ? i.copyWith(quantity: quantity) : i)
          .toList(),
    );
  }

  void clear() => state = const CartEntity();

  CartItemEntity _itemFromProduct(ProductEntity p, {int quantity = 1}) =>
      CartItemEntity(
        sku: p.sku,
        name: p.name,
        imageUrl: p.imageUrl,
        basePrice: p.basePrice,
        taxRate: p.taxRate,
        icoAmount: p.icoAmount,
        discount: p.discount,
        quantity: quantity,
      );
}
