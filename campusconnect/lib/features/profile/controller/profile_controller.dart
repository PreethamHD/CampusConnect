import 'dart:io';

import 'package:campusconnect/Providers/storage_repository_Provider.dart';
import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/features/profile/repository/profile_repository.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

final UserProfileControllerProvideer =
    StateNotifierProvider<ProfileController, bool>((ref) {
      final ProfileRepository = ref.watch(userProfileProvider);
      final StorageRepository = ref.watch(FirebaseStorageProvider);
      return ProfileController(
        profileRepository: ProfileRepository,
        ref: ref,
        storageRepository: StorageRepository,
      );
    });

class ProfileController extends StateNotifier<bool> {
  final ProfileRepository _profileRepository;
  final Ref _ref;
  final StorageRepository _storageRepository;
  ProfileController({
    required ProfileRepository profileRepository,
    required Ref ref,
    required StorageRepository storageRepository,
  }) : _profileRepository = profileRepository,
       _ref = ref,
       _storageRepository = storageRepository,
       super(false);
  void editProfile({
    required File? profilePic,
    required BuildContext context,
    required String name,
    required String sem,
    required String about,
  }) async {
    state = true;
    UserModel user = _ref.read(userProvider)!;
    if (profilePic != null) {
      final res = await _storageRepository.storeFiles(
        path: 'users/profile',
        id: user.uid,
        file: profilePic,
      );
      res.fold(
        (l) => showSnackBar(context, l.message),
        (r) => user = user.copyWith(ProfilePic: r),
      );
    }
    user = user.copyWith(Name: name, about: about, sem: sem);
    final res = await _profileRepository.editProfile(user);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      _ref.read(userProvider.notifier).update((state) => user);
      Routemaster.of(context).pop();
    });
  }
}
