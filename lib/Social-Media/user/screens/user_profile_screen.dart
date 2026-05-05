// lib/Social-Media/user/screens/user_profile_screen.dart

import 'package:dx/Social-Media/user/widgets/user_profile_body.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_cubit.dart';
import 'package:dx/Social-Media/user/cubit/user_profile_state.dart';
import 'package:dx/Social-Media/feed/widgets/error_view.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileCubit, UserProfileState>(
      builder: (context, state) {
        if (state.status == UserProfileStatus.loading || state.status == UserProfileStatus.initial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: Color(0xFF32DBE6))),
          );
        }

        if (state.status == UserProfileStatus.failure && state.profile == null) {
          return Scaffold(
            body: ErrorView(
              message: state.errorMessage ?? 'Failed to load profile.',
              onRetry: () => context.read<UserProfileCubit>().loadProfile(),
            ),
          );
        }

        // Once data is available, show the layout "wedge"
        return UserProfileBody(profile: state.profile!);
      },
    );
  }
}