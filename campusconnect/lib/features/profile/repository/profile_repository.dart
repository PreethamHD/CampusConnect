import 'package:campusconnect/Providers/firebase_Providers.dart';
import 'package:campusconnect/core/constants/firebase_constants.dart';
import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/typedef.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final userProfileProvider = Provider((ref) {
  return ProfileRepository(firestore: ref.watch(fireStoreProvider));
});

class ProfileRepository {
  final FirebaseFirestore _firestore;
  ProfileRepository({required FirebaseFirestore firestore})
    : _firestore = firestore;
  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureVoid editProfile(UserModel user) async {
    try {
      return right(_users.doc(user.uid).update(user.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
