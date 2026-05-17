import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/E-Commerce/Cubit/checkout_state.dart';
import 'package:dx/repositories/user_repository.dart';

class CheckoutCubit extends Cubit<CheckoutState> {
  CheckoutCubit({required UserRepository repository, required String brandId})
      : _repository = repository,
        _brandId = brandId,
        super(const CheckoutState.initial());

  final UserRepository _repository;
  final String _brandId;

  Future<void> placeOrder({
    required String cartId,
    required String streetEn,
    required String streetAr,
    required String cityEn,
    required String cityAr,
    required String buildingNumber,
  }) async {
    emit(state.copyWith(status: CheckoutStatus.loading));
    try {
      await _repository.checkout(
        brandId: _brandId,
        cartId: cartId,
        streetEn: streetEn,
        streetAr: streetAr,
        cityEn: cityEn,
        cityAr: cityAr,
        buildingNumber: buildingNumber,
      );
      if (isClosed) return;
      emit(state.copyWith(status: CheckoutStatus.success));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: CheckoutStatus.failure,
        errorMessage: 'checkout.order_failed',
      ));
    }
  }
}
