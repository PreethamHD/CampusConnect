import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/chat/controller/chat_controller.dart';
import 'package:campusconnect/models/chat_model.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageScreen extends ConsumerStatefulWidget {
  final String chatId;
  final String receiverId;

  const MessageScreen({
    super.key,
    required this.chatId,
    required this.receiverId,
  });

  @override
  ConsumerState<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends ConsumerState<MessageScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendTextMessage() {
    final currentUser = ref.read(userProvider);
    if (_controller.text.trim().isEmpty || currentUser == null) return;

    final msg = Message(
      text: _controller.text.trim(),
      timestamp: DateTime.now(),
      senderId: currentUser.uid,
      receiverId: widget.receiverId,
      isRead: false,
      id: '',
      imageUrl: null,
    );

    ref
        .read(ChatControllerProvider.notifier)
        .sendMessages(widget.chatId, msg, context);

    _controller.clear();
  }

  Future<void> _sendImage() async {}

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);

    final messagesStream = ref
        .watch(ChatControllerProvider.notifier)
        .getMessage(widget.chatId);

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = currentUser?.uid == msg.senderId;

                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isMe ? Pallete.brownColor : Pallete.brownColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child:
                            msg.imageUrl != null
                                ? Image.network(msg.imageUrl!)
                                : Text(msg.text),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _sendImage,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendTextMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
