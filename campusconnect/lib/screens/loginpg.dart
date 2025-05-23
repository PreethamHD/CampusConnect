import 'package:campusconnect/components/my_button.dart';
import 'package:campusconnect/components/text_field.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider = StateProvider((ref) => TextEditingController());
final passwordControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);

// ignore: must_be_immutable
class Loginpg extends ConsumerWidget {
  void Function()? onTap;

  void login(BuildContext context, WidgetRef ref) {
    final emailController = ref.read(emailControllerProvider);
    final passWController = ref.read(passwordControllerProvider);
    ref
        .read(authControllerProvider.notifier)
        .signInWithEmailAndPassword(
          context,
          emailController.text.trim(),
          passWController.text.trim(),
        );
  }

  Loginpg({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailControllerProvider);
    final passWController = ref.watch(passwordControllerProvider);
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(
                'assets/images/campusconnectLogo.png',
                height: 100,
              ),
            ),

            const Text(
              'Find Your Campus Mates ^_^',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w300,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'Login',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            MyTextField(
              hintText: "Email",
              obsText: false,
              controller: emailController,
            ),
            const SizedBox(height: 2),
            MyTextField(
              hintText: "Password",
              obsText: true,
              controller: passWController,
            ),
            const SizedBox(height: 20),
            MyButton(text: 'Login', onTap: () => login(context, ref)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Dont have an account?"),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Signup',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Pallete.blueColor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
