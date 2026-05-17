import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/E-Commerce/Cubit/product_search_state.dart';
import 'package:dx/repositories/user_repository.dart';

class ProductSearchCubit extends Cubit<ProductSearchState> {
  ProductSearchCubit({required UserRepository repository, required String brandId})
      : _repository = repository,
        _brandId = brandId,
        super(const ProductSearchState.initial());

  final UserRepository _repository;
  final String _brandId;
  Timer? _debounce;

  static const Duration _debounceDuration = Duration(milliseconds: 350);

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      emit(const ProductSearchState.initial());
      return;
    }

    emit(state.copyWith(query: trimmed, status: ProductSearchStatus.loading));
    _debounce = Timer(_debounceDuration, () => _search(trimmed));
  }

  void clearSearch() {
    _debounce?.cancel();
    emit(const ProductSearchState.initial());
  }

  Future<void> _search(String query) async {
    try {
      final result = await _repository.searchBrandProducts(_brandId, query, 0, 10);
      if (isClosed) return;
      emit(state.copyWith(
        status: ProductSearchStatus.success,
        results: result.items,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: ProductSearchStatus.failure,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
