import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:campusconnect/screens/message_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserSelectionScreen extends ConsumerWidget {
  const UserSelectionScreen({super.key});

  String generateChatId(String uid1, String uid2) {
    final sorted = [uid1, uid2]..sort();
    return '${sorted[0]}_${sorted[1]}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.read(userProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Select User')),
      body: FutureBuilder(
        future: ref.read(authControllerProvider.notifier).getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final result = snapshot.data;

          if (result == null) {
            return const Center(child: Text('No users found'));
          }

          return result.match(
            (failure) => Center(child: Text('Error: ${failure.message}')),
            (userList) {
              return ListView.builder(
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final user = userList[index];
                  return ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(user.Name),
                    onTap: () {
                      if (currentUser == null) return;

                      final chatId = generateChatId(currentUser.uid, user.uid);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => MessageScreen(
                                chatId: chatId,
                                receiverId: user.uid, // corrected here
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
    );
  }
}
