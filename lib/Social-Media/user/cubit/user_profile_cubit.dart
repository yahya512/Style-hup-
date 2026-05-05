import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_state.dart';
import 'package:dx/Social-Media/user/services/user_profile_service.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit({required UserProfileService service})
      : _service = service,
        super(const UserProfileState.initial());

  final UserProfileService _service;

  Future<void> loadProfile() async {
    if (state.status == UserProfileStatus.loading) return;
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final profile = await _service.getProfile();
      emit(state.copyWith(status: UserProfileStatus.success, profile: profile));
    } on DioException catch (e) {
      _emitError(e.message ?? 'Network error — please try again.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (state.status == UserProfileStatus.updating) return;
    emit(state.copyWith(status: UserProfileStatus.updating));
    try {
      final updated = await _service.updateProfile(updates);
      emit(state.copyWith(status: UserProfileStatus.success, profile: updated));
    } on DioException catch (e) {
      _emitError(e.message ?? 'Failed to update profile.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  Future<void> uploadImage(File image) async {
    if (state.status == UserProfileStatus.updating) return;
    emit(state.copyWith(status: UserProfileStatus.updating));
    try {
      await _service.uploadProfileImage(image);
      if (!isClosed) await loadProfile();
    } on DioException catch (e) {
      _emitError(e.message ?? 'Failed to upload image.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  Future<void> deleteAccount() async {
    try {
      await _service.deleteAccount();
    } on DioException catch (e) {
      _emitError(e.message ?? 'Failed to delete account.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  void _emitError(String message) {
    emit(state.copyWith(
      status: state.profile != null
          ? UserProfileStatus.success
          : UserProfileStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
