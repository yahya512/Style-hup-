import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/user/models/user_profile_model.dart';

enum UserProfileStatus { initial, loading, success, updating, failure }

class UserProfileState extends Equatable {
  const UserProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
    this.errorCount = 0,
  });

  const UserProfileState.initial()
      : status = UserProfileStatus.initial,
        profile = null,
        errorMessage = null,
        errorCount = 0;

  final UserProfileStatus status;
  final UserProfileModel? profile;
  final String? errorMessage;
  final int errorCount;

  UserProfileState copyWith({
    UserProfileStatus? status,
    UserProfileModel? profile,
    String? errorMessage,
    int? errorCount,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, errorCount];
}
