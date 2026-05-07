import 'package:dx/Social-Media/user/models/user_profile_model.dart';

enum OtherUserProfileStatus { initial, loading, success, failure }

class OtherUserProfileState {
  const OtherUserProfileState({
    this.status = OtherUserProfileStatus.initial,
    this.profile,
    this.errorMessage,
    this.errorCount = 0,
  });

  final OtherUserProfileStatus status;
  final UserProfileModel? profile;
  final String? errorMessage;
  final int errorCount;

  OtherUserProfileState copyWith({
    OtherUserProfileStatus? status,
    UserProfileModel? profile,
    String? errorMessage,
    int? errorCount,
  }) {
    return OtherUserProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage ?? this.errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }
}
