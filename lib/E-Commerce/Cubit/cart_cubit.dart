import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/E-Commerce/Cubit/cart_state.dart';
import 'package:dx/E-Commerce/Models/get_cart_model.dart';
import 'package:dx/repositories/user_repository.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({required UserRepository repository, required String brandId})
      : _repository = repository,
        _brandId = brandId,
        super(const CartState.initial());

  final UserRepository _repository;
  final String _brandId;

  Future<void> loadCart() async {
    emit(state.copyWith(status: CartStatus.loading, items: []));
    try {
      final cart = await _repository.getCart(_brandId);
      if (isClosed) return;
      emit(state.copyWith(status: CartStatus.success, items: cart.items));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CartStatus.failure,
        errorMessage: 'Failed to load cart. Please try again.',
      ));
    }
  }

  Future<void> incrementQuantity(ProductModel item) async {
    final newQty = item.qantity.toInt() + 1;
    final updated = _updateItemQty(item, newQty);
    emit(state.copyWith(status: CartStatus.success, items: updated));
    try {
      await _repository.updateCartItemQuantity(
          _brandId, item.cartId, item.cartItemId, newQty);
    } catch (_) {
      if (isClosed) return;
      await loadCart();
    }
  }

  Future<void> decrementQuantity(ProductModel item) async {
    if (item.qantity <= 1) {
      await removeItem(item);
      return;
    }
    final newQty = item.qantity.toInt() - 1;
    final updated = _updateItemQty(item, newQty);
    emit(state.copyWith(status: CartStatus.success, items: updated));
    try {
      await _repository.updateCartItemQuantity(
          _brandId, item.cartId, item.cartItemId, newQty);
    } catch (_) {
      if (isClosed) return;
      await loadCart();
    }
  }

  Future<void> removeItem(ProductModel item) async {
    final updated =
        state.items.where((i) => i.cartItemId != item.cartItemId).toList();
    emit(state.copyWith(status: CartStatus.success, items: updated));
    try {
      await _repository.deleteFromCart(_brandId, item.cartId, item.cartItemId);
    } catch (_) {
      if (isClosed) return;
      await loadCart();
    }
  }

  List<ProductModel> _updateItemQty(ProductModel item, num newQty) {
    return state.items.map((i) {
      if (i.cartItemId != item.cartItemId) return i;
      return ProductModel(
        productId: i.productId,
        thumbnail: i.thumbnail,
        productNameEn: i.productNameEn,
        productNameAr: i.productNameAr,
        size: i.size,
        cartId: i.cartId,
        cartItemId: i.cartItemId,
        cartStatus: i.cartStatus,
        productVariantId: i.productVariantId,
        sku: i.sku,
        colorCode: i.colorCode,
        totalPrice: i.totalPrice,
        qantity: newQty,
      );
    }).toList();
  }
}
