import 'package:equatable/equatable.dart';
import 'package:dx/E-Commerce/Models/get_cart_model.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  const CartState({
    required this.status,
    required this.items,
    this.errorMessage,
  });

  const CartState.initial()
      : status = CartStatus.initial,
        items = const [],
        errorMessage = null;

  final CartStatus status;
  final List<ProductModel> items;
  final String? errorMessage;

  num get totalPrice =>
      items.fold(0, (sum, item) => sum + item.totalPrice * item.qantity);

  CartState copyWith({
    CartStatus? status,
    List<ProductModel>? items,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      items: items ?? this.items,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, errorMessage];
}
