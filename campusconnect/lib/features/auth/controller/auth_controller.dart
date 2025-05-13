import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/repository/auth_repository.dart';
import 'package:campusconnect/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = Provider(
  (ref) => AuthController(
    authRepository: ref.read(authRepositoryProvider),
    ref: ref,
  ),
);

class AuthController {
  final AuthRepository _authRepository;
  final Ref _ref;
  AuthController({required AuthRepository authRepository, required Ref ref})
    : _authRepository = authRepository,
      _ref = ref;

  void signInWithEmailAndPassword(
    BuildContext context,
    String email,
    String password,
  ) async {
    final user = await _authRepository.signInWithEmailAndPassword(
      email,
      password,
    );
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
}
