import 'package:equatable/equatable.dart';

class ReactionState extends Equatable {
  const ReactionState({
    this.reacted = const {},
    this.reactionCounts = const {},
    this.commentCounts = const {},
    this.errorMessage,
    this.errorCount = 0,
  });

  /// postId → isReacted
  final Map<String, bool> reacted;

  /// postId → reaction count
  final Map<String, int> reactionCounts;

  /// postId → comment count
  final Map<String, int> commentCounts;

  final String? errorMessage;
  final int errorCount;

  ReactionState copyWith({
    Map<String, bool>? reacted,
    Map<String, int>? reactionCounts,
    Map<String, int>? commentCounts,
    String? errorMessage,
    int? errorCount,
  }) =>
      ReactionState(
        reacted: reacted ?? this.reacted,
        reactionCounts: reactionCounts ?? this.reactionCounts,
        commentCounts: commentCounts ?? this.commentCounts,
        errorMessage: errorMessage,
        errorCount: errorCount ?? this.errorCount,
      );

  @override
  List<Object?> get props =>
      [reacted, reactionCounts, commentCounts, errorMessage, errorCount];
}
