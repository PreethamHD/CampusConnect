import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';

class MyAppbar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppbar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return AppBar(
      title: const Text('CampusConnect'),
      leading: Builder(
        builder: (context) {
          return IconButton(
            onPressed: () => displayDrawer(context),
            icon: CircleAvatar(backgroundImage: NetworkImage(user.ProfilePic)),
          );
        },
      ),
    );
  }
}
