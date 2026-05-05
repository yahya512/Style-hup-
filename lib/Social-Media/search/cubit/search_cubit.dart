import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/search/cubit/search_state.dart';
import 'package:dx/Social-Media/search/services/search_service.dart';

class SearchCubit extends Cubit<SearchState> {
  SearchCubit({required SearchService service})
      : _service = service,
        super(const SearchState.initial());

  final SearchService _service;
  Timer? _debounce;

  static const Duration _debounceDuration = Duration(milliseconds: 350);

  void onQueryChanged(String query) {
    _debounce?.cancel();
    final trimmed = query.trim();

    if (trimmed.isEmpty) {
      emit(const SearchState.initial());
      return;
    }

    emit(state.copyWith(query: trimmed, status: SearchStatus.loading));
    _debounce = Timer(_debounceDuration, () => _search(trimmed));
  }

  void clearSearch() {
    _debounce?.cancel();
    emit(const SearchState.initial());
  }

  Future<void> _search(String query) async {
    try {
      final results = await _service.search(query);
      if (isClosed) return;
      emit(state.copyWith(status: SearchStatus.success, results: results));
    } on DioException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(
        status: SearchStatus.failure,
        errorMessage: e.message ?? 'Network error — please try again.',
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: SearchStatus.failure,
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
