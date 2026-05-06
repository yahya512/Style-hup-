import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/cache/cache_helper.dart';
import 'package:dx/core/api/endpoints.dart';
import 'package:dx/core/services/service_locator.dart';
import 'package:dx/core/theme/appstyles.dart';
import 'package:dx/Social-Media/interactions/cubit/comment_cubit.dart';
import 'package:dx/Social-Media/interactions/cubit/comment_state.dart';
import 'package:dx/Social-Media/interactions/models/comment_model.dart';
import 'package:dx/Social-Media/interactions/services/interaction_service.dart';
import 'package:dx/Social-Media/interactions/widgets/comment_tile.dart';

void showCommentBottomSheet(
  BuildContext context, {
  required String postId,
  required void Function(int delta) onCountChanged,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
    ),
    builder: (_) => BlocProvider(
      create: (_) => CommentCubit(
        service: getIt<InteractionService>(),
        postId: postId,
        onCountChanged: onCountChanged,
      )..loadComments(),
      child: _CommentSheetContent(postId: postId),
    ),
  );
}

class _CommentSheetContent extends StatefulWidget {
  const _CommentSheetContent({required this.postId});
  final String postId;

  @override
  State<_CommentSheetContent> createState() => _CommentSheetContentState();
}

class _CommentSheetContentState extends State<_CommentSheetContent> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  String? _editingCommentId;

  String get _currentUserId =>
      CacheHelper.sharedPreferences.getString(ApiKey.baseUserId) ?? '';

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      context.read<CommentCubit>().loadMoreComments();
    }
  }

  void _startEdit(CommentModel comment) {
    setState(() {
      _editingCommentId = comment.id;
      _controller.text = comment.content;
    });
  }

  void _cancelEdit() {
    setState(() {
      _editingCommentId = null;
      _controller.clear();
    });
  }

  Future<void> _submit() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    FocusScope.of(context).unfocus();
    if (_editingCommentId != null) {
      final id = _editingCommentId!;
      setState(() => _editingCommentId = null);
      await context.read<CommentCubit>().editComment(id, text);
    } else {
      await context.read<CommentCubit>().addComment(text);
    }
  }

  void _confirmDelete(String commentId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete comment?'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<CommentCubit>().deleteComment(commentId);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 10.h),
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            Text('Comments', style: AppStyles.normalTextStyle),
            Divider(height: 1.h, color: Colors.grey[200]),
            Expanded(
              child: BlocConsumer<CommentCubit, CommentState>(
                listenWhen: (prev, curr) => curr.errorCount > prev.errorCount,
                listener: (context, state) {
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      content: Text(state.errorMessage ?? 'An error occurred'),
                      behavior: SnackBarBehavior.floating,
                    ));
                },
                builder: (context, state) {
                  if (state.status == CommentStatus.loading) {
                    return const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF32DBE6)),
                    );
                  }
                  if (state.status == CommentStatus.failure &&
                      state.comments.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Failed to load comments.',
                              style: AppStyles.labelTextStyle),
                          TextButton(
                            onPressed: () =>
                                context.read<CommentCubit>().loadComments(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (state.comments.isEmpty) {
                    return Center(
                      child: Text('No comments yet. Be the first!',
                          style: AppStyles.labelTextStyle),
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.comments.length +
                        (state.status == CommentStatus.loadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.comments.length) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          child: const Center(
                            child: CircularProgressIndicator(
                                color: Color(0xFF32DBE6)),
                          ),
                        );
                      }
                      final comment = state.comments[index];
                      return CommentTile(
                        comment: comment,
                        currentUserId: _currentUserId,
                        onEdit: () => _startEdit(comment),
                        onDelete: () => _confirmDelete(comment.id),
                      );
                    },
                  );
                },
              ),
            ),
            Divider(height: 1.h, color: Colors.grey[200]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Row(
                children: [
                  if (_editingCommentId != null)
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: _cancelEdit,
                    ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      maxLength: 1000,
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        hintText: _editingCommentId != null
                            ? 'Edit comment…'
                            : 'Add a comment…',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w,
                          vertical: 10.h,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  BlocBuilder<CommentCubit, CommentState>(
                    builder: (context, state) {
                      final submitting =
                          state.status == CommentStatus.submitting;
                      return IconButton(
                        icon: submitting
                            ? SizedBox(
                                width: 20.r,
                                height: 20.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF32DBE6),
                                ),
                              )
                            : Icon(Icons.send,
                                color: const Color(0xFF32DBE6), size: 24.r),
                        onPressed: submitting ? null : _submit,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
