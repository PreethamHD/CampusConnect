import 'package:campusconnect/models/discussion_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiscussionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<DiscussionModel>> getDiscussionsStream() {
    return _firestore
        .collection('discussions')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => DiscussionModel.fromMap(doc.data()))
                  .toList(),
        );
  }

  Future<void> sendDiscussionMessage(DiscussionModel discussion) async {
    await _firestore
        .collection('discussions')
        .doc(discussion.id)
        .set(discussion.toMap());
  }
}
