import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/discussion/controller/discussion_controller.dart';
import 'package:campusconnect/models/discussion_model.dart';
import 'package:campusconnect/theme/pallete.dart';

class DiscussionScreen extends ConsumerStatefulWidget {
  const DiscussionScreen({super.key});

  @override
  ConsumerState<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends ConsumerState<DiscussionScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendTextMessage() {
    final currentUser = ref.read(userProvider);
    if (_controller.text.trim().isEmpty || currentUser == null) return;

    ref
        .read(discussionControllerProvider.notifier)
        .sendTextMessage(
          senderId: currentUser.uid,
          text: _controller.text.trim(),
        );

    _controller.clear();
  }

  void _sendImageMessage() {
    /* final currentUser = ref.read(userProvider);
    if (currentUser == null) return;

    ref
        .read(discussionControllerProvider.notifier)
        .pickAndSendImage(senderId: currentUser.uid);*/
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(userProvider);
    final messagesStream =
        ref.watch(discussionControllerProvider.notifier).discussions;
    final usersMapAsync = ref.watch(usersMapProvider); // <-- use this

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: usersMapAsync.when(
              data: (usersMap) {
                return StreamBuilder<List<DiscussionModel>>(
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
                        final user = usersMap[msg.senderId];
                        final name = user?.Name ?? "Unknown";
                        final photo = user?.ProfilePic ?? "";

                        return Align(
                          alignment:
                              isMe
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  isMe
                                      ? Pallete.brownColor
                                      : Pallete.brownColor.withOpacity(0.85),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe)
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12,
                                        backgroundImage:
                                            photo.isNotEmpty
                                                ? NetworkImage(photo)
                                                : null,
                                        child:
                                            photo.isEmpty
                                                ? const Icon(
                                                  Icons.person,
                                                  size: 16,
                                                )
                                                : null,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                if (!isMe) const SizedBox(height: 4),
                                msg.imageUrl != null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        msg.imageUrl!,
                                        height: 160,
                                        width: 160,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Text(
                                      msg.text,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                const SizedBox(height: 4),
                                Text(
                                  TimeOfDay.fromDateTime(
                                    msg.timestamp,
                                  ).format(context),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error loading users')),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _sendImageMessage,
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
