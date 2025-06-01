import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/notes/controller/notes_controller.dart';
import 'package:campusconnect/models/notes_model.dart';
import 'package:campusconnect/screens/notes_folder_screen.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SubjectScreen extends ConsumerWidget {
  final SemesterModel semester;
  const SubjectScreen({super.key, required this.semester});

  void _showAddSubjectDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController subController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Subject'),
            content: TextField(
              controller: subController,
              decoration: const InputDecoration(hintText: 'Enter subject name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final sub = SubjectModel(
                    subject: subController.text.trim(),
                    notes: [],
                  );

                  ref
                      .read(notesControllerProvider.notifier)
                      .createSubject(semester.sem, sub);

                  Navigator.pop(ctx);
                },
                child: const Text('Add'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final subAsync = ref.watch(getSubjectsProvider(semester.sem));

    return Scaffold(
      appBar: AppBar(title: Text('${semester.sem} ')),
      body: subAsync.when(
        data: (subs) {
          if (subs.isEmpty) {
            return const Center(child: Text('No subjects found.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
            ),
            itemCount: subs.length,
            itemBuilder: (context, index) {
              final sub = subs[index];
              return GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => NotesScreen(sem: semester.sem, subject: sub),
                      ),
                    ),
                child: Card(
                  elevation: 2,
                  color: Pallete.brownColor,
                  child: Center(
                    child: Text(
                      sub.subject,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
      floatingActionButton:
          user?.role == 'admin'
              ? FloatingActionButton(
                onPressed: () => _showAddSubjectDialog(context, ref),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
