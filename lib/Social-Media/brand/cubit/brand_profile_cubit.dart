import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/brand/cubit/brand_profile_state.dart';
import 'package:dx/Social-Media/brand/services/brand_profile_service.dart';

class BrandProfileCubit extends Cubit<BrandProfileState> {
  BrandProfileCubit({required BrandProfileService service})
      : _service = service,
        super(const BrandProfileState.initial());

  final BrandProfileService _service;

  Future<void> loadProfile() async {
    if (state.status == BrandProfileStatus.loading) return;
    emit(state.copyWith(status: BrandProfileStatus.loading));
    try {
      final profile = await _service.getProfile();
      emit(state.copyWith(status: BrandProfileStatus.success, profile: profile));
    } on DioException catch (e) {
      _emitError(e.message ?? 'Network error — please try again.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  Future<void> updateProfile(Map<String, dynamic> updates) async {
    if (state.status == BrandProfileStatus.updating) return;
    emit(state.copyWith(status: BrandProfileStatus.updating));
    try {
      final updated = await _service.updateProfile(updates);
      emit(state.copyWith(status: BrandProfileStatus.success, profile: updated));
    } on DioException catch (e) {
      _emitError(e.message ?? 'Failed to update profile.');
    } catch (_) {
      _emitError('Something went wrong. Please try again.');
    }
  }

  Future<void> uploadImage(File image) async {
    if (state.status == BrandProfileStatus.updating) return;
    emit(state.copyWith(status: BrandProfileStatus.updating));
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
          ? BrandProfileStatus.success
          : BrandProfileStatus.failure,
      errorMessage: message,
      errorCount: state.errorCount + 1,
    ));
  }
}
