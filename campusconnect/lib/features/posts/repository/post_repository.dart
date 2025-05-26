import 'package:campusconnect/Providers/firebase_Providers.dart';
import 'package:campusconnect/core/constants/firebase_constants.dart';
import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/typedef.dart';
import 'package:campusconnect/models/post_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final PostRepositoryProvider = Provider((ref) {
  return PostRepository(firestore: ref.watch(fireStoreProvider));
});

class PostRepository {
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _posts =>
      _firestore.collection(FirebaseConstants.postsCollecction);

  FutureVoid createPost(PostModel posts) async {
    try {
      return right(_posts.doc(posts.id).set(posts.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<PostModel>> getPosts() {
    return _posts.orderBy('timestamp', descending: true).snapshots().map((
      snapshot,
    ) {
      return snapshot.docs.map((doc) {
        return PostModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  FutureVoid likePost(String id, String uid) async {
    try {
      return right(
        _posts.doc(id).update({
          'likes': FieldValue.arrayUnion([uid]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid unlikePost(String id, String uid) async {
    try {
      return right(
        _posts.doc(id).update({
          'likes': FieldValue.arrayRemove([uid]),
        }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
