import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_state.dart';
import 'package:dx/Social-Media/interactions/services/interaction_service.dart';

class ReactionCubit extends Cubit<ReactionState> {
  ReactionCubit({required InteractionService service})
      : _service = service,
        super(const ReactionState());

  final InteractionService _service;

  /// Tracks posts with an in-flight toggle to prevent double-taps.
  final Set<String> _inFlight = {};

  /// Seed initial state from feed data. Safe to call multiple times —
  /// only seeds posts not yet tracked (preserves user-toggled state).
  void seedPost({
    required String postId,
    required bool isReacted,
    required int reactionCount,
    required int commentCount,
  }) {
    if (state.reacted.containsKey(postId)) return;
    emit(state.copyWith(
      reacted: {...state.reacted, postId: isReacted},
      reactionCounts: {...state.reactionCounts, postId: reactionCount},
      commentCounts: {...state.commentCounts, postId: commentCount},
    ));
  }

  /// Toggle reaction with optimistic update + rollback on error.
  Future<void> toggleReaction(String postId) async {
    if (_inFlight.contains(postId)) return;

    final wasReacted = state.reacted[postId] ?? false;
    final oldCount = state.reactionCounts[postId] ?? 0;
    final newReacted = !wasReacted;
    final newCount =
        newReacted ? oldCount + 1 : (oldCount - 1).clamp(0, 999999);

    _inFlight.add(postId);
    emit(state.copyWith(
      reacted: {...state.reacted, postId: newReacted},
      reactionCounts: {...state.reactionCounts, postId: newCount},
    ));

    try {
      if (newReacted) {
        await _service.toggleReaction(postId);
      } else {
        await _service.removeReaction(postId);
      }
    } catch (_) {
      emit(state.copyWith(
        reacted: {...state.reacted, postId: wasReacted},
        reactionCounts: {...state.reactionCounts, postId: oldCount},
        errorMessage: 'Failed to update reaction. Please try again.',
        errorCount: state.errorCount + 1,
      ));
    } finally {
      _inFlight.remove(postId);
    }
  }

  /// Fetches the true reaction status from the server and updates state.
  /// Always overrides the seeded value — call this when opening a post detail
  /// so the heart icon reflects the user's actual server-side reaction.
  Future<void> fetchReactionStatus(String postId) async {
    try {
      final reacted = await _service.checkReactionStatus(postId);
      emit(state.copyWith(
        reacted: {...state.reacted, postId: reacted},
      ));
    } catch (_) {
      // Silently ignore — UI keeps the seeded value.
    }
  }

  /// Called by comment bottom sheet after add (+1) or delete (-1).
  void updateCommentCount(String postId, int delta) {
    final current = state.commentCounts[postId] ?? 0;
    final updated = (current + delta).clamp(0, 999999);
    emit(state.copyWith(
      commentCounts: {...state.commentCounts, postId: updated},
    ));
  }
}
