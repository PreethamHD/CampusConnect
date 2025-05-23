import 'package:flutter/material.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class MyDrawer extends ConsumerWidget {
  const MyDrawer({super.key});

  void navigateTo(BuildContext context, String path) {
    Routemaster.of(context).push(path);
  }

  void logout(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).logout();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              backgroundImage: NetworkImage(user.ProfilePic),
                            ),
                          ),
                          Text(user.Name),
                        ],
                      ),
                      ListTile(
                        title: Text('View Profile'),
                        onTap: () => navigateTo(context, '/profile'),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  title: Text('Home'),
                  leading: Icon(Icons.home),
                  onTap: () => navigateTo(context, '/home'),
                ),
                ListTile(
                  title: Text('Discussion'),
                  leading: Icon(Icons.group),
                  onTap: () => navigateTo(context, '/discussion'),
                ),
                ListTile(
                  title: Text('Notes'),
                  leading: Icon(Icons.book),
                  onTap: () => navigateTo(context, '/notes'),
                ),
              ],
            ),
            Column(
              children: [
                ListTile(
                  title: Text('Logout'),
                  leading: Icon(Icons.logout),
                  onTap: () => logout(ref),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
