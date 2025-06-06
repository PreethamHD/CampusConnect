import 'package:campusconnect/core/utils/utils.dart';
import 'package:campusconnect/features/auth/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:campusconnect/components/my_button.dart';
import 'package:campusconnect/components/text_field.dart';
import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final emailControllerProvider = StateProvider((ref) => TextEditingController());
final passwordControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);
final rePasswordControllerProvider = StateProvider(
  (ref) => TextEditingController(),
);

// ignore: must_be_immutable
class SignUppg extends ConsumerWidget {
  void Function()? onTap;

  void signup(BuildContext context, WidgetRef ref) {
    final emailController = ref.read(emailControllerProvider);
    final passWController = ref.read(passwordControllerProvider);
    final rePassWController = ref.read(rePasswordControllerProvider);
    var bool =
        passWController.text.trim() == rePassWController.text.trim() &&
        emailController.text.contains("@bmsce.ac.in") &&
        passWController.text.length >= 6;
    if (bool) {
      ref
          .read(authControllerProvider.notifier)
          .createAccountwithEmail(
            context,
            emailController.text,
            passWController.text,
          );
    } else if (!emailController.text.contains("@bmsce.ac.in")) {
      showSnackBar(context, "Only college email-id is allowed");
    } else if (passWController.text.trim() != rePassWController.text.trim()) {
      showSnackBar(context, "Password and Confrim password doesnt match");
    } else {
      showSnackBar(context, "Password should Contain min 6 charecters");
    }
  }

  SignUppg({super.key, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = ref.watch(emailControllerProvider);
    final passWController = ref.watch(passwordControllerProvider);
    final rePassWController = ref.watch(rePasswordControllerProvider);
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
              'Register/Signup',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            MyTextField(
              hintText: "Enter Email",
              obsText: false,
              controller: emailController,
            ),
            const SizedBox(height: 2),
            MyTextField(
              hintText: "Enter Password",
              obsText: true,
              controller: passWController,
            ),
            const SizedBox(height: 2),
            MyTextField(
              hintText: "Re-Enter Password",
              obsText: true,
              controller: rePassWController,
            ),
            const SizedBox(height: 20),
            MyButton(text: 'SignUp', onTap: () => signup(context, ref)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account ?"),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    'Login',
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
