import 'package:campusconnect/screens/add_post_screen.dart';
import 'package:campusconnect/screens/chat_screen.dart';
import 'package:campusconnect/screens/discussion_screen.dart';
import 'package:campusconnect/screens/feed_screen.dart';
import 'package:campusconnect/screens/home.dart';
import 'package:campusconnect/screens/loginSignpg.dart';
import 'package:campusconnect/screens/notes_screen.dart';
import 'package:campusconnect/screens/profile_screen/edit_profile_screen.dart';
import 'package:campusconnect/screens/profile_screen/my_profileScreen.dart';
import 'package:campusconnect/screens/select_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(
  routes: {'/': (_) => const MaterialPage(child: Loginsignpg())},
);

final loggedInRoute = RouteMap(
  routes: {
    '/': (_) => const MaterialPage(child: HomeScreen()),
    '/home': (_) => const MaterialPage(child: FeedScreen()),
    '/add-post': (_) => const MaterialPage(child: AddPostScreen()),
    '/discussion': (_) => const MaterialPage(child: DiscussionScreen()),
    '/chat': (_) => const MaterialPage(child: ChatListScreen()),
    '/chat/select_user':
        (_) => MaterialPage(child: const UserSelectionScreen()),
    '/notes': (_) => const MaterialPage(child: SemesterScreen()),
    '/profile': (_) => const MaterialPage(child: MyProfilescreen()),
    '/profile/editProfile':
        (_) => const MaterialPage(child: EditProfileScreen()),
  },
);
