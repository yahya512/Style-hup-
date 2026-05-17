import 'package:dx/E-Commerce/Cubit/brand_directory_state.dart';
import 'package:dx/E-Commerce/Services/brand_directory_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BrandDirectoryCubit extends Cubit<BrandDirectoryState> {
  final BrandDirectoryService _service;
  static const int _limit = 20;
  bool _isFetching = false;

  BrandDirectoryCubit({required BrandDirectoryService service})
      : _service = service,
        super(const BrandDirectoryState());

  Future<void> loadBrands() async {
    if (_isFetching) return;
    _isFetching = true;
    emit(state.copyWith(
      status: BrandDirectoryStatus.loading,
      items: [],
      offset: 0,
      hasMore: true,
    ));
    try {
      final result = await _service.getBrands(limit: _limit, offset: 0);
      emit(state.copyWith(
        status: BrandDirectoryStatus.success,
        items: result.items,
        hasMore: result.hasMore,
        offset: result.items.length,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: BrandDirectoryStatus.failure,
        errorMessage: e.toString(),
      ));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> loadMoreBrands() async {
    if (_isFetching || !state.hasMore) return;
    if (state.status != BrandDirectoryStatus.success) return;
    _isFetching = true;
    emit(state.copyWith(status: BrandDirectoryStatus.loadingMore));
    try {
      final result =
          await _service.getBrands(limit: _limit, offset: state.offset);
      final merged = [...state.items, ...result.items];
      emit(state.copyWith(
        status: BrandDirectoryStatus.success,
        items: merged,
        hasMore: result.hasMore,
        offset: merged.length,
      ));
    } catch (_) {
      // Keep current items on pagination error
      emit(state.copyWith(status: BrandDirectoryStatus.success));
    } finally {
      _isFetching = false;
    }
  }
}
