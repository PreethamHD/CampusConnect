import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/repository/auth_repository.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref,
  ),
);

final authStateChangeProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChange;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

class AuthController extends StateNotifier<bool> {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref,
      super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    state = true;
    final user = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
    state = false;
    user.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  void createAccountwithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    final user = await _authRepository.createAccountWithEmail(email, password);
    user.fold(
      (l) => showSnackBar(context, l.message),
      (r) => _ref.read(userProvider.notifier).update((state) => r),
    );
  }

  Stream<UserModel> getUserData(String uid) {
    return _authRepository.getUser(uid);
  }

  void logout() async {
    _authRepository.logout();
  }
}
