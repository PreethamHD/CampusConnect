import 'dart:io';

import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/posts/controller/posts_controller.dart';
import 'package:campusconnect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerStatefulWidget {
  const AddPostScreen({super.key});

  @override
  ConsumerState<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends ConsumerState<AddPostScreen> {
  final TextEditingController postController = TextEditingController();
  File? selectedImage;

  void selectBg() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        selectedImage = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    postController.dispose();
    super.dispose();
  }

  void addPost(PostModel posts) {
    ref.read(PostsControllerProvider.notifier).createPosts(posts, context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider)!;
    final isLoading = ref.watch(PostsControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Post"),
        leading: IconButton(
          onPressed: () => Routemaster.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final postModel = PostModel(
                authorId: user.uid,
                timestamp: DateTime.now(),
                likes: [],
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                content: postController.text.trim(),
              );
              addPost(postModel);
            },
            child: const Text('Create'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(user.ProfilePic),
                    radius: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    user.Name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: postController,
                      maxLines: null,
                      decoration: const InputDecoration(
                        hintText: "What's Happening?",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  IconButton(
                    onPressed: selectBg,
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              if (selectedImage != null)
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
