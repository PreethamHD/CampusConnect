import 'package:campusconnect/Providers/firebase_Providers.dart';
import 'package:campusconnect/core/constants/constants.dart';
import 'package:campusconnect/core/constants/firebase_constants.dart';
import 'package:campusconnect/core/constants/role_constant.dart';
import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/typedef.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

final authRepositoryProvider = Provider(
  (ref) => AuthRepository(
    firestore: ref.read(fireStoreProvider),
    auth: ref.read(authProvider),
  ),
);

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  }) : _auth = auth,
       _firestore = firestore;

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);

  FutureEither<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      UserModel userModel;
      /*  userModel = UserModel(
        uid: userCredential.user!.uid,
        Name: email.split('.cs')[0],
        ProfilePic: Constants.userProfile,
        about: "Student at BMSCE",
        sem: '4',
        role: RoleConstant.user,
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());*/
      userModel = await getUser(userCredential.user!.uid).first;
      return right(userModel);
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> createAccountWithEmail(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      UserModel userModel = UserModel(
        uid: userCredential.user!.uid,
        Name: email.split('.cs')[0],
        ProfilePic: Constants.userProfile,
        about: "Student at BMSCE",
        sem: '4',
        role: RoleConstant.user,
      );
      await _users.doc(userCredential.user!.uid).set(userModel.toMap());

      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<User?> get authStateChange => _auth.authStateChanges();

  Stream<UserModel> getUser(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (event) => UserModel.fromMap(event.data() as Map<String, dynamic>),
        );
  }

  void logout() async {
    await _auth.signOut();
  }

  FutureEither<List<UserModel>> getAllUsers() async {
    try {
      QuerySnapshot snapshot = await _users.get();
      return right(
        snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
            .toList(),
      );
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
