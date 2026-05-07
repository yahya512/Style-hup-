import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/user/cubit/other_user_profile_state.dart';
import 'package:dx/Social-Media/user/services/other_user_profile_service.dart';

class OtherUserProfileCubit extends Cubit<OtherUserProfileState> {
  OtherUserProfileCubit({
    required OtherUserProfileService service,
    required this.userId,
  })  : _service = service,
        super(const OtherUserProfileState());

  final OtherUserProfileService _service;
  final String userId;

  Future<void> loadProfile() async {
    if (state.status == OtherUserProfileStatus.loading) return;
    emit(state.copyWith(status: OtherUserProfileStatus.loading));
    try {
      final profile = await _service.getProfile(userId);
      emit(state.copyWith(
        status: OtherUserProfileStatus.success,
        profile: profile,
      ));
    } on DioException catch (e) {
      _emitError(e.message ?? 'Network error — please try again.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  void _emitError(String message) {
    emit(state.copyWith(
      status: state.profile != null
          ? OtherUserProfileStatus.success
          : OtherUserProfileStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
