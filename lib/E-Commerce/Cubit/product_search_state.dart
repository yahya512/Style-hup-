import 'package:equatable/equatable.dart';
import 'package:dx/E-Commerce/Models/all_products_list_model.dart';

enum ProductSearchStatus { initial, loading, success, failure }

class ProductSearchState extends Equatable {
  const ProductSearchState({
    required this.status,
    required this.results,
    this.query = '',
    this.errorMessage,
  });

  const ProductSearchState.initial()
      : status = ProductSearchStatus.initial,
        results = const [],
        query = '',
        errorMessage = null;

  final ProductSearchStatus status;
  final List<ProductModel> results;
  final String query;
  final String? errorMessage;

  ProductSearchState copyWith({
    ProductSearchStatus? status,
    List<ProductModel>? results,
    String? query,
    String? errorMessage,
  }) {
    return ProductSearchState(
      status: status ?? this.status,
      results: results ?? this.results,
      query: query ?? this.query,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, results, query, errorMessage];
}
