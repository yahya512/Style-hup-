import 'package:equatable/equatable.dart';

enum CheckoutStatus { initial, loading, success, failure }

class CheckoutState extends Equatable {
  const CheckoutState({
    required this.status,
    this.errorMessage,
  });

  const CheckoutState.initial()
      : status = CheckoutStatus.initial,
        errorMessage = null;

  final CheckoutStatus status;
  final String? errorMessage;

  CheckoutState copyWith({
    CheckoutStatus? status,
    String? errorMessage,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
