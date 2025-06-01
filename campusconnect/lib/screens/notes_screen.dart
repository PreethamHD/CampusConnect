import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/notes/controller/notes_controller.dart';
import 'package:campusconnect/models/notes_model.dart';
import 'package:campusconnect/screens/subjectsScreen.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SemesterScreen extends ConsumerWidget {
  const SemesterScreen({super.key});

  void _showAddSemesterDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController semController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Semester'),
            content: TextField(
              controller: semController,
              decoration: const InputDecoration(
                hintText: 'Enter semester name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final sem = SemesterModel(
                    sem: semController.text.trim(),
                    subjects: [],
                  );
                  ref
                      .read(notesControllerProvider.notifier)
                      .createSemester(sem);
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
    final semAsync = ref.watch(getSemesterProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Semesters')),
      body: semAsync.when(
        data:
            (sems) => GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.2,
              ),
              itemCount: sems.length,
              itemBuilder: (context, index) {
                final sem = sems[index];
                return GestureDetector(
                  onTap:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SubjectScreen(semester: sem),
                        ),
                      ),
                  child: Card(
                    color: Pallete.brownColor,
                    child: Center(child: Text(sem.sem)),
                  ),
                );
              },
            ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text(err.toString())),
      ),
      floatingActionButton:
          user?.role == 'admin'
              ? FloatingActionButton(
                onPressed: () => _showAddSemesterDialog(context, ref),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
