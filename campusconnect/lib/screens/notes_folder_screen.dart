import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotesFolderScreen extends ConsumerStatefulWidget {
  final String subject;
  const NotesFolderScreen({super.key, required this.subject});

  @override
  ConsumerState<NotesFolderScreen> createState() => _NotesFolderScreenState();
}

class _NotesFolderScreenState extends ConsumerState<NotesFolderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),
      body: const Center(child: Text("No files found!")),
    );
  }
}
