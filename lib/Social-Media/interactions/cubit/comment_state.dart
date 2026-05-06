import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/interactions/models/comment_model.dart';

enum CommentStatus {
  initial,
  loading,
  loadingMore,
  success,
  failure,
  submitting,
}

class CommentState extends Equatable {
  const CommentState({
    this.status = CommentStatus.initial,
    this.comments = const [],
    this.hasMore = true,
    this.offset = 0,
    this.errorMessage,
    this.errorCount = 0,
  });

  final CommentStatus status;
  final List<CommentModel> comments;
  final bool hasMore;
  final int offset;
  final String? errorMessage;
  final int errorCount;

  CommentState copyWith({
    CommentStatus? status,
    List<CommentModel>? comments,
    bool? hasMore,
    int? offset,
    String? errorMessage,
    int? errorCount,
  }) =>
      CommentState(
        status: status ?? this.status,
        comments: comments ?? this.comments,
        hasMore: hasMore ?? this.hasMore,
        offset: offset ?? this.offset,
        errorMessage: errorMessage,
        errorCount: errorCount ?? this.errorCount,
      );

  @override
  List<Object?> get props =>
      [status, comments, hasMore, offset, errorMessage, errorCount];
}
