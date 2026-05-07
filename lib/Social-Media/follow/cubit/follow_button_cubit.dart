import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/follow/cubit/follow_button_state.dart';
import 'package:dx/Social-Media/follow/services/follow_service.dart';

class FollowButtonCubit extends Cubit<FollowButtonState> {
  FollowButtonCubit({
    required FollowService service,
    required this.targetUserId,
  })  : _service = service,
        super(const FollowButtonState.loading());

  final FollowService _service;
  final String targetUserId;

  Future<void> init() async {
    try {
      final isFollowing = await _service.checkFollowStatus(targetUserId);
      emit(isFollowing
          ? const FollowButtonState.following()
          : const FollowButtonState.notFollowing());
    } catch (_) {
      emit(const FollowButtonState.notFollowing());
    }
  }

  /// Optimistically toggles follow state and rolls back on API error.
  /// Rethrows [DioException] so the UI can show a snackbar.
  Future<void> toggle() async {
    final previous = state;
    final wasFollowing = previous.status == FollowButtonStatus.following;

    emit(wasFollowing
        ? const FollowButtonState.notFollowing()
        : const FollowButtonState.following());

    try {
      if (wasFollowing) {
        await _service.unfollow(targetUserId);
      } else {
        await _service.follow(targetUserId);
      }
    } on DioException catch (e) {
      emit(previous);
      final code = e.response?.statusCode;
      if (code == 409) {
        emit(const FollowButtonState.following());
      } else if (code == 404 && wasFollowing) {
        emit(const FollowButtonState.notFollowing());
      }
      rethrow;
    }
  }
}
