import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/search/models/search_result_model.dart';

enum SearchStatus { initial, loading, success, failure }

class SearchState extends Equatable {
  const SearchState({
    required this.status,
    required this.results,
    this.query = '',
    this.errorMessage,
  });

  const SearchState.initial()
      : status = SearchStatus.initial,
        results = const [],
        query = '',
        errorMessage = null;

  final SearchStatus status;
  final List<SearchResultModel> results;
  final String query;
  final String? errorMessage;

  SearchState copyWith({
    SearchStatus? status,
    List<SearchResultModel>? results,
    String? query,
    String? errorMessage,
  }) {
    return SearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, query, errorMessage];
}
