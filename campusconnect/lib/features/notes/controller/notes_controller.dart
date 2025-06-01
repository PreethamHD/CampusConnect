import 'package:campusconnect/features/notes/repository/notes_repo.dart';
import 'package:campusconnect/models/notes_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesControllerProvider = StateNotifierProvider<NotesController, bool>((
  ref,
) {
  final repo = ref.read(notesRepoProvider);
  return NotesController(ref: ref, repo: repo);
});

final getSemesterProvider = StreamProvider<List<SemesterModel>>((ref) {
  final notesRepo = ref.watch(notesRepoProvider);
  return notesRepo.getSemesters();
});

final getSubjectsProvider = StreamProvider.family<List<SubjectModel>, String>((
  ref,
  sem,
) {
  return ref.watch(notesControllerProvider.notifier).getSubjects(sem);
});

class NotesController extends StateNotifier<bool> {
  final NotesRepo _repo;
  final Ref _ref;

  NotesController({required NotesRepo repo, required Ref ref})
    : _repo = repo,
      _ref = ref,
      super(false);

  Future<void> createSemester(SemesterModel sem) async {
    state = true;
    final res = await _repo.createSem(sem);
    res.fold((l) => print('Error: ${l.message}'), (_) {});
    state = false;
  }

  Future<void> createSubject(String sem, SubjectModel sub) async {
    state = true;
    final res = await _repo.createSub(sem, sub);
    res.fold((l) => print('Error: ${l.message}'), (_) {});
    state = false;
  }

  Future<void> addNotes(String sem, String sub, NotesModel notes) async {
    state = true;
    final res = await _repo.addNotes(sem, sub, notes);
    res.fold((l) => print('Error: ${l.message}'), (_) {});
    state = false;
  }

  Stream<List<SubjectModel>> getSubjects(String sem) {
    return _repo
        .getSubjects(sem)
        .map(
          (event) => event.map((e) => SubjectModel.fromMap(e.data())).toList(),
        );
  }

  Stream<List<NotesModel>> getNotes(String sem, String subject) {
    return _repo.getSubjectDoc(sem, subject).map((doc) {
      final map = doc.data();
      final list = map?['notes'] ?? [];
      return List<NotesModel>.from(list.map((x) => NotesModel.fromMap(x)));
    });
  }
}
