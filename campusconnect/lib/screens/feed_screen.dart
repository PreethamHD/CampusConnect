import 'package:campusconnect/components/error_text.dart';
import 'package:campusconnect/components/loader.dart';
import 'package:campusconnect/components/post_card.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/posts/controller/posts_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

void navigateTo(BuildContext context, String path) {
  Routemaster.of(context).push(path);
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      body: ref
          .watch(PostsProvider)
          .when(
            data: (posts) {
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (BuildContext context, int idx) {
                  final post = posts[idx];
                  return PostCard(post: post);
                },
              );
            },
            error: (error, StackTrace) => ErrorText(error: error.toString()),
            loading: () => const Loader(),
          ),
      floatingActionButton:
          user.role == 'admin'
              ? FloatingActionButton(
                onPressed: () => navigateTo(context, '/add-post'),
                tooltip: 'Create Post',
                child: const Icon(Icons.add),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
