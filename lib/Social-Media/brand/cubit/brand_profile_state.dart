import 'package:equatable/equatable.dart';
import 'package:dx/Social-Media/brand/models/brand_profile_model.dart';

enum BrandProfileStatus { initial, loading, success, updating, failure }

class BrandProfileState extends Equatable {
  const BrandProfileState({
    required this.status,
    this.profile,
    this.errorMessage,
    this.errorCount = 0,
  });

  const BrandProfileState.initial()
      : status = BrandProfileStatus.initial,
        profile = null,
        errorMessage = null,
        errorCount = 0;

  final BrandProfileStatus status;
  final BrandProfileModel? profile;
  final String? errorMessage;
  final int errorCount;

  BrandProfileState copyWith({
    BrandProfileStatus? status,
    BrandProfileModel? profile,
    String? errorMessage,
    int? errorCount,
  }) {
    return BrandProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
      errorMessage: errorMessage,
      errorCount: errorCount ?? this.errorCount,
    );
  }

  @override
  List<Object?> get props => [status, profile, errorMessage, errorCount];
}
