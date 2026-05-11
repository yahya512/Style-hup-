import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dx/Social-Media/chat/cubit/chat_cubit.dart';
import 'package:dx/Social-Media/chat/cubit/chat_state.dart';
import 'package:dx/Social-Media/chat/widgets/message_bubble.dart';
import 'package:dx/Social-Media/chat/widgets/typing_indicator.dart';
import 'package:dx/Social-Media/chat/services/chat_service.dart';
import 'package:dx/Social-Media/notifications/services/socket_service.dart';
import 'package:dx/core/services/service_locator.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.otherParticipantName,
    required this.currentUserId,
    this.otherParticipantAvatar,
  });

  final String conversationId;
  final String otherParticipantName;
  final String? otherParticipantAvatar;
  final String currentUserId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChatCubit(
        conversationId: conversationId,
        currentUserId: currentUserId,
        chatService: getIt<ChatService>(),
        socketService: getIt<SocketService>(),
      ),
      child: _ChatView(
        otherParticipantName: otherParticipantName,
        otherParticipantAvatar: otherParticipantAvatar,
        currentUserId: currentUserId,
      ),
    );
  }
}

class _ChatView extends StatefulWidget {
  const _ChatView({
    required this.otherParticipantName,
    required this.currentUserId,
    this.otherParticipantAvatar,
  });

  final String otherParticipantName;
  final String? otherParticipantAvatar;
  final String currentUserId;

  @override
  State<_ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<_ChatView> with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _initialScrollDone = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _scrollController.addListener(_onScroll);
    // Sequenced init: load messages first, then start listening for socket
    // events, then emit seen. This ensures the message list is populated
    // before any chat:status events can arrive.
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  Future<void> _init() async {
    if (!mounted) return;
    final cubit = context.read<ChatCubit>();
    await cubit.loadInitial();
    if (!mounted) return;
    cubit.startListening();
    cubit.emitSeen();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && mounted) {
      context.read<ChatCubit>().emitSeen();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels <= 100) {
      context.read<ChatCubit>().loadMore();
    }
  }

  void _send() {
    final text = _textController.text;
    if (text.trim().isEmpty) return;
    _textController.clear();
    context.read<ChatCubit>().sendMessage(text);
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scrollController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          // Disconnected banner
          BlocBuilder<ChatCubit, ChatState>(
            buildWhen: (p, c) => p.isConnected != c.isConnected,
            builder: (_, state) => state.isConnected
                ? const SizedBox.shrink()
                : Container(
                    width: double.infinity,
                    color: Colors.amber.shade700,
                    padding: EdgeInsets.symmetric(
                        vertical: 6.h, horizontal: 16.w),
                    child: Text(
                      'Reconnecting…',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 12.sp, color: Colors.white),
                    ),
                  ),
          ),

          // Message list
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listenWhen: (p, c) =>
                  p.sendError != c.sendError && c.sendError != null,
              listener: (context, state) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.sendError!),
                    backgroundColor: const Color(0xFF800020),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
                context.read<ChatCubit>().clearSendError();
              },
              builder: (context, state) {
                if (state.isInitialLoading) {
                  return const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF800020)),
                  );
                }

                if (state.status == ChatStatus.failure &&
                    state.messages.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.error ?? 'Failed to load messages.',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.grey.shade600),
                        ),
                        SizedBox(height: 12.h),
                        TextButton(
                          onPressed: () =>
                              context.read<ChatCubit>().loadInitial(),
                          child: const Text('Retry',
                              style: TextStyle(
                                  color: Color(0xFF800020))),
                        ),
                      ],
                    ),
                  );
                }

                // Jump to bottom on first successful load.
                if (!_initialScrollDone &&
                    state.status == ChatStatus.success &&
                    state.messages.isNotEmpty) {
                  _initialScrollDone = true;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_scrollController.hasClients) {
                      _scrollController.jumpTo(
                          _scrollController.position.maxScrollExtent);
                    }
                  });
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  itemCount:
                      state.messages.length + (state.isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == state.messages.length) {
                      return const TypingIndicator();
                    }
                    final msg = state.messages[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: MessageBubble(
                        message: msg,
                        isMine: msg.senderId == widget.currentUserId,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          _buildInputRow(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF800020),
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      title: Row(
        children: [
          CircleAvatar(
            radius: 18.r,
            backgroundColor: const Color(0xFFB05070),
            backgroundImage: widget.otherParticipantAvatar != null
                ? NetworkImage(widget.otherParticipantAvatar!)
                : null,
            child: widget.otherParticipantAvatar == null
                ? Icon(Icons.person, size: 18.r, color: Colors.white70)
                : null,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              widget.otherParticipantName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputRow() {
    return BlocBuilder<ChatCubit, ChatState>(
      buildWhen: (p, c) => p.isConnected != c.isConnected,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h)
              .copyWith(
                  bottom: 8.h + MediaQuery.of(context).viewInsets.bottom),
          decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      enabled: state.isConnected,
                      maxLines: 4,
                      minLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      onChanged: (text) =>
                          context.read<ChatCubit>().onTextChanged(text),
                      decoration: InputDecoration(
                        hintText: state.isConnected
                            ? 'Message…'
                            : 'Reconnecting…',
                        hintStyle: TextStyle(
                            fontSize: 14.sp, color: Colors.grey.shade400),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 10.h),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                          fontSize: 14.sp, color: Colors.black87),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: state.isConnected ? _send : null,
                  child: Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: state.isConnected
                          ? const Color(0xFF800020)
                          : Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send_rounded,
                        color: Colors.white, size: 20.r),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
