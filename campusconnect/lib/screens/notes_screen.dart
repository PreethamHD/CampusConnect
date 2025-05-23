import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final TextEditingController subController = TextEditingController();
  final List<String> subjects = [
    'DBMS',
    'Computer Networks',
    'Java',
    'OOPs',
    'Linear Algebra',
    'OS',
  ];

  void addFolder() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Folder'),
          content: TextField(
            autofocus: true,
            controller: subController,
            decoration: const InputDecoration(labelText: 'Folder Name'),
          ),

          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  subjects.add(subController.text.trim());
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: subjects.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 2.3,
          ),
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return GestureDetector(
              onTap: () {
                Routemaster.of(context).push('/notes/$subject');
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Pallete.brownColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.folder, size: 48, color: Colors.blue),
                    const SizedBox(height: 8),
                    Text(
                      subject,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton:
          user.role == 'admin'
              ? FloatingActionButton(
                onPressed: addFolder,
                tooltip: 'Create folder',
                child: const Icon(Icons.add),
              )
              : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
