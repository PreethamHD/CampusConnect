import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/chat/controller/chat_controller.dart';
import 'package:campusconnect/models/chat_model.dart';
import 'package:campusconnect/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:routemaster/routemaster.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body:
          currentUser == null
              ? const Center(child: CircularProgressIndicator())
              : StreamBuilder<List<Message>>(
                stream: ref
                    .watch(ChatControllerProvider.notifier)
                    .getLastMessages(currentUser.uid),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final messages = snapshot.data!;
                  final usersMap = ref
                      .watch(usersMapProvider)
                      .maybeWhen(data: (data) => data, orElse: () => {});

                  if (messages.isEmpty) {
                    return const Center(child: Text("No chats yet"));
                  }

                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final otherUser =
                          msg.senderId == currentUser.uid
                              ? usersMap[msg.receiverId]
                              : usersMap[msg.senderId];

                      final name = otherUser?.Name ?? 'Unknown';

                      return ListTile(
                        leading: const CircleAvatar(child: Icon(Icons.person)),
                        title: Text(name),
                        subtitle: Text(
                          msg.text,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          DateFormat('hh:mm a').format(msg.timestamp),
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          final chatId =
                              msg.senderId.hashCode <= msg.receiverId.hashCode
                                  ? '${msg.senderId}_${msg.receiverId}'
                                  : '${msg.receiverId}_${msg.senderId}';

                          final receiverId =
                              msg.senderId == currentUser.uid
                                  ? msg.receiverId
                                  : msg.senderId;

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => MessageScreen(
                                    chatId: chatId,
                                    receiverId: receiverId,
                                  ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Routemaster.of(context).push('/chat/select_user');
        },
        child: const Icon(Icons.chat),
      ),
    );
  }
}
