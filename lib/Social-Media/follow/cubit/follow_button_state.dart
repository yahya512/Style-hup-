enum FollowButtonStatus { loading, following, notFollowing }

class FollowButtonState {
  const FollowButtonState({required this.status});

  const FollowButtonState.loading() : status = FollowButtonStatus.loading;
  const FollowButtonState.following() : status = FollowButtonStatus.following;
  const FollowButtonState.notFollowing()
      : status = FollowButtonStatus.notFollowing;

  final FollowButtonStatus status;
}
