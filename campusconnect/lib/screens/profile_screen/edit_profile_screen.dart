import 'dart:io';

import 'package:campusconnect/components/loader.dart';
import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/profile/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? pPic;
  late TextEditingController nameController;
  late TextEditingController semController;
  late TextEditingController aboutController;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userProvider)!;
    nameController = TextEditingController(text: user.Name);
    semController = TextEditingController(text: user.sem);
    aboutController = TextEditingController(text: user.about);
  }

  @override
  void dispose() {
    nameController.dispose();
    semController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  void selectBg() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        pPic = File(res.files.first.path!);
      });
    }
  }

  void savee() {
    ref
        .read(UserProfileControllerProvideer.notifier)
        .editProfile(
          profilePic: pPic,
          context: context,
          name: nameController.text.trim(),
          sem: semController.text.trim(),
          about: aboutController.text.trim(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isLoading = ref.watch(UserProfileControllerProvideer);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [TextButton(onPressed: savee, child: const Text('Save'))],
      ),
      body:
          isLoading
              ? const Loader()
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: selectBg,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundImage:
                                  pPic != null
                                      ? FileImage(pPic!)
                                      : NetworkImage(user.ProfilePic)
                                          as ImageProvider,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: nameController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Basic Info Card (editable)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Basic Info",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: semController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.school),
                                labelText: "Semester",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: aboutController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.info_outline),
                                labelText: "About",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
