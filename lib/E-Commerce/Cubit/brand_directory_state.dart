import 'package:dx/E-Commerce/Models/brand_directory_model.dart';
import 'package:equatable/equatable.dart';

enum BrandDirectoryStatus { initial, loading, loadingMore, success, failure }

class BrandDirectoryState extends Equatable {
  final BrandDirectoryStatus status;
  final List<BrandDirectoryItem> items;
  final bool hasMore;
  final int offset;
  final String? errorMessage;

  const BrandDirectoryState({
    this.status = BrandDirectoryStatus.initial,
    this.items = const [],
    this.hasMore = true,
    this.offset = 0,
    this.errorMessage,
  });

  BrandDirectoryState copyWith({
    BrandDirectoryStatus? status,
    List<BrandDirectoryItem>? items,
    bool? hasMore,
    int? offset,
    String? errorMessage,
  }) {
    return BrandDirectoryState(
      status: status ?? this.status,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      offset: offset ?? this.offset,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, items, hasMore, offset, errorMessage];
}
