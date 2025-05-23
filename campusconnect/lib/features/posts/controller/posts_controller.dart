import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/posts/repository/post_repository.dart';
import 'package:campusconnect/models/post_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:routemaster/routemaster.dart';

final PostsProvider = StreamProvider((ref) {
  final PostsController = ref.watch(PostsControllerProvider.notifier);
  return PostsController.getPosts();
});

final PostsControllerProvider = StateNotifierProvider<PostsController, bool>((
  ref,
) {
  final postRepository = ref.watch(PostRepositoryProvider);
  return PostsController(postRepository: postRepository, ref: ref);
});

class PostsController extends StateNotifier<bool> {
  final PostRepository _postRepository;
  final Ref _ref;
  PostsController({required PostRepository postRepository, required Ref ref})
    : _postRepository = postRepository,
      _ref = ref,
      super(false);

  void createPosts(PostModel posts, BuildContext context) async {
    state = true;
    final res = await _postRepository.createPost(posts);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      state = false;
      showSnackBar(context, "Posts Created Successfullly");
      Routemaster.of(context).pop();
    });
  }

  Stream<List<PostModel>> getPosts() {
    return _postRepository.getPosts();
  }

  void likePosts(PostModel posts, BuildContext context) async {
    final user = _ref.read(userProvider)!;
    Either<Failure, void> res;
    if (posts.likes.contains(user.uid)) {
      res = await _postRepository.unlikePost(posts.id, user.uid);
    } else {
      res = await _postRepository.likePost(posts.id, user.uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r) {
      if (posts.likes.contains(user.uid)) {
        showSnackBar(context, "Removed like ");
      } else {
        showSnackBar(context, "Added like ");
      }
    });
  }
}
