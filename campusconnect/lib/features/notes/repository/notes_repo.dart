import 'package:campusconnect/Providers/firebase_Providers.dart';
import 'package:campusconnect/core/constants/firebase_constants.dart';
import 'package:campusconnect/core/failure.dart';
import 'package:campusconnect/core/typedef.dart';
import 'package:campusconnect/models/notes_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

// ignore: non_constant_identifier_names
final notesRepoProvider = Provider<NotesRepo>((ref) {
  return NotesRepo(firestore: ref.watch(fireStoreProvider));
});

class NotesRepo {
  final FirebaseFirestore _firestore;
  NotesRepo({required FirebaseFirestore firestore}) : _firestore = firestore;
  CollectionReference get _sem =>
      _firestore.collection(FirebaseConstants.semCollection);

  FutureVoid createSem(SemesterModel sem) async {
    try {
      return right(_sem.doc(sem.sem).set(sem.toMap()));
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<SemesterModel>> getSemesters() {
    return _sem.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return SemesterModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  FutureVoid createSub(String sem, SubjectModel sub) async {
    try {
      return right(
        _sem
            .doc(sem)
            .collection(FirebaseConstants.subCollection)
            .doc(sub.subject)
            .set(sub.toMap()),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addNotes(String sem, String sub, NotesModel notes) async {
    try {
      return right(
        _sem
            .doc(sem)
            .collection(FirebaseConstants.subCollection)
            .doc(sub)
            .update({
              'notes': FieldValue.arrayUnion([notes.toMap()]),
            }),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getSubjects(
    String sem,
  ) {
    return _sem
        .doc(sem)
        .collection(FirebaseConstants.subCollection)
        .snapshots()
        .map((snap) => snap.docs);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSubjectDoc(
    String sem,
    String subject,
  ) {
    return _sem
        .doc(sem)
        .collection(FirebaseConstants.subCollection)
        .doc(subject)
        .snapshots();
  }
}
