import 'package:dx/Social-Media/feed/models/post_model.dart';
import 'package:dx/Social-Media/feed/widgets/post_card.dart';
import 'package:dx/Social-Media/interactions/cubit/reaction_cubit.dart';
import 'package:dx/Social-Media/interactions/services/interaction_service.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({
    super.key,
    required this.post,
    this.onDelete,
    this.onEdit,
  });

  final FeedPostModel post;
  final VoidCallback? onDelete;
  final void Function(String? content, PostVisibility visibility)? onEdit;

  @override
  Widget build(BuildContext context) {
    final item = FeedItemModel(
      id: post.id,
      type: FeedItemType.post,
      createdAt: post.createdAt,
      post: post,
    );

    return BlocProvider(
      create: (_) =>
          ReactionCubit(service: getIt<InteractionService>())
            ..seedPost(
              postId: post.id,
              isReacted: post.isReactedByMe,
              reactionCount: post.reactionsCount,
              commentCount: post.commentsCount,
            )
            ..fetchReactionStatus(post.id),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: const BackButton(color: Colors.black),
          title: const Text(
            'Post',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: PostCard(item: item, onDelete: onDelete, onEdit: onEdit),
        ),
      ),
    );
  }
}
