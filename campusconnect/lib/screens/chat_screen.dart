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
    final currentUser = ref.watch(userProvider)!;
    final usersMapAsync = ref.watch(usersMapProvider);
    final messagesAsync = ref.watch(lastMessagesProvider(currentUser.uid));

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: usersMapAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text("Error: $err")),
        data: (usersMap) {
          return messagesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text("Error loading chats: $err")),
            data: (messages) {
              if (messages.isEmpty) {
                return const Center(child: Text("No chats yet"));
              }

              return ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final msg = messages[index];
                  final isSender = msg.senderId == currentUser.uid;
                  final otherUserId = isSender ? msg.receiverId : msg.senderId;
                  final otherUser = usersMap[otherUserId];
                  final name = otherUser?.Name ?? 'Unknown';

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          otherUser?.ProfilePic != null
                              ? NetworkImage(otherUser!.ProfilePic)
                              : null,
                      child:
                          otherUser?.ProfilePic == null
                              ? const Icon(Icons.person)
                              : null,
                    ),

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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MessageScreen(
                                chatId: chatId,
                                receiverId: otherUserId,
                              ),
                        ),
                      );
                    },
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
