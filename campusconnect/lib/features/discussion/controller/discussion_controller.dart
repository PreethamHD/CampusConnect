import 'package:campusconnect/models/discussion_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final discussionControllerProvider =
    StateNotifierProvider<DiscussionController, bool>(
      (ref) => DiscussionController(ref),
    );

class DiscussionController extends StateNotifier<bool> {
  final Ref ref;
  DiscussionController(this.ref) : super(false);

  // Stream to get all discussion messages
  Stream<List<DiscussionModel>> get discussions {
    return FirebaseFirestore.instance
        .collection('discussions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => DiscussionModel.fromMap(doc.data()))
              .toList();
        });
  }

  // Send text message
  void sendTextMessage({required String senderId, required String text}) async {
    try {
      final message = DiscussionModel(
        id: '',
        senderId: senderId,
        text: text,
        imageUrl: null,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('discussions')
          .doc()
          .set(message.toMap());
    } catch (e) {
      debugPrint('Error sending text message: $e');
    }
  }

  /* // Send image message
  Future<void> pickAndSendImage({required String senderId}) async {
    try {
      final file = await pickImage();
      if (file == null) return;

      state = true;

      final ref = FirebaseStorage.instance
          .ref()
          .child('discussion_images')
          .child('.jpg');

      await ref.putFile(File(file.path));
      final imageUrl = await ref.getDownloadURL();

      final message = DiscussionModel(
        id: uuid,
        senderId: senderId,
        text: '',
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('discussions')
          .doc(uuid)
          .set(message.toMap());
    } catch (e) {
      debugPrint('Error sending image message: $e');
    } finally {
      state = false;
    }
  }
}*/
}
