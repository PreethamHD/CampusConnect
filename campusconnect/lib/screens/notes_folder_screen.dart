import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/notes/controller/notes_controller.dart';
import 'package:campusconnect/models/notes_model.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class NotesScreen extends ConsumerWidget {
  final String sem;
  final SubjectModel subject;
  const NotesScreen({super.key, required this.sem, required this.subject});

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController linkController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Add Note'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Note title'),
                ),
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(hintText: 'Note link'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final link = linkController.text.trim();
                  if (name.isNotEmpty && link.isNotEmpty) {
                    final note = NotesModel(notesname: name, links: link);
                    ref
                        .read(notesControllerProvider.notifier)
                        .addNotes(sem, subject.subject, note);
                  }
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
    final notes = subject.notes;

    return Scaffold(
      appBar: AppBar(title: Text('${subject.subject} Notes')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text(note.notesname),
              tileColor: Pallete.brownColor,
              onTap: () => launchUrl(Uri.parse(note.links)),
            ),
          );
        },
      ),
      floatingActionButton:
          user?.role == 'admin'
              ? FloatingActionButton(
                onPressed: () => _showAddNoteDialog(context, ref),
                child: const Icon(Icons.add),
              )
              : null,
    );
  }
}
