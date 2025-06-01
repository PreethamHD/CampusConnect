import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campusconnect/features/posts/controller/posts_controller.dart';

class PostCard extends ConsumerWidget {
  final PostModel post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final authorAsync = ref.watch(getUserDataProvider(post.authorId));

    return authorAsync.when(
      data: (author) {
        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(author.ProfilePic),
                      radius: 15,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        author.Name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  child: Text(
                    post.content,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),

                const SizedBox(height: 12),
                if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                  Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.8,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          post.imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.error),
                        ),
                      ),
                    ),
                  ),

                const SizedBox(height: 12),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        ref
                            .read(PostsControllerProvider.notifier)
                            .likePosts(post, context);
                      },
                      icon: Icon(
                        post.likes.contains(user.uid)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color:
                            post.likes.contains(user.uid)
                                ? Colors.red
                                : Colors.grey,
                      ),
                    ),
                    Text('${post.likes.length}'),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.comment_outlined),
                    ),
                    const Text("Comment"),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Text('Error loading author: $err'),
    );
  }
}
