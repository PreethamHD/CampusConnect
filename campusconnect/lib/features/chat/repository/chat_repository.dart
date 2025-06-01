import 'package:campusconnect/Providers/firebase_Providers.dart';
import 'package:campusconnect/core/constants/firebase_constants.dart';
import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/typedef.dart';
import 'package:campusconnect/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final ChatRepositoryProvider = Provider((ref) {
  return ChatRepository(firestore: ref.watch(fireStoreProvider));
});

class ChatRepository {
  final FirebaseFirestore _firestore;
  ChatRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;

  CollectionReference get _chat =>
      _firestore.collection(FirebaseConstants.chatsCollection);

  Stream<List<Message>> getMessages(String chatId) {
    return _chat
        .doc(chatId)
        .collection(FirebaseConstants.messageCollections)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Message.fromMap(doc.data());
          }).toList();
        });
  }

  FutureVoid sendMessage(String chatId, Message msg) async {
    try {
      final messageId = _firestore.collection('unique_ids').doc().id;
      final messageWithId = msg.copyWith(id: messageId);

      await _chat.doc(chatId).set({
        'participants': [msg.senderId, msg.receiverId],
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      return right(
        await _chat
            .doc(chatId)
            .collection(FirebaseConstants.messageCollections)
            .doc(messageId)
            .set(messageWithId.toMap()),
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message!));
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid markAsRead(String chatId, String messageId) async {
    try {
      return right(
        _chat
            .doc(chatId)
            .collection(FirebaseConstants.messageCollections)
            .doc(messageId)
            .update({'isRead': true}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  FutureVoid editMessage(
    String chatId,
    String messageId,
    String newText,
  ) async {
    try {
      return right(
        _chat
            .doc(chatId)
            .collection(FirebaseConstants.messageCollections)
            .doc(messageId)
            .update({'text': newText}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Message>> getLastMessagesForUser(String userId) {
    return _chat
        .where('participants', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .asyncMap((chatSnapshot) async {
          List<Message> result = [];

          for (var chatDoc in chatSnapshot.docs) {
            final messageSnap =
                await chatDoc.reference
                    .collection(FirebaseConstants.messageCollections)
                    .orderBy('timestamp', descending: true)
                    .limit(1)
                    .get();

            if (messageSnap.docs.isNotEmpty) {
              final messageData = messageSnap.docs.first.data();
              result.add(Message.fromMap(messageData));
            }
          }

          return result;
        });
  }

  FutureVoid deleteMessage(String chatId, String messageId) async {
    try {
      return right(
        _chat
            .doc(chatId)
            .collection(FirebaseConstants.messageCollections)
            .doc(messageId)
            .delete(),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<List<Map<String, dynamic>>> getUserChats(String userId) {
    return _chat
        .where('participants', arrayContains: userId)
        .orderBy('lastUpdated', descending: true)
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList(),
        );
  }

  FutureVoid reactToMessage(
    String chatId,
    String messageId,
    String reaction,
  ) async {
    try {
      return right(
        _chat
            .doc(chatId)
            .collection(FirebaseConstants.messageCollections)
            .doc(messageId)
            .update({'reaction': reaction}),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  Stream<bool> getTyping(String chatId, String userId) => _firestore
      .collection('chats')
      .doc(chatId)
      .snapshots()
      .map((doc) => doc.data()?['typing_$userId'] ?? false);

  Future<void> setTyping(String chatId, String userId, bool isTyping) async {
    await _firestore.collection('chats').doc(chatId).set({
      'typing_$userId': isTyping,
    }, SetOptions(merge: true));
  }
}
