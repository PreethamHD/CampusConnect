import 'package:flutter/material.dart';
import 'package:campusconnect/components/my_button.dart';
import 'package:campusconnect/components/text_field.dart';
import 'package:campusconnect/theme/pallete.dart';

class SignUppg extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passWController = TextEditingController();
  final TextEditingController _rePassWController = TextEditingController();

  void Function()? onTap;

  void login() {}
  SignUppg({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
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
              'Find Your F*ckMate ^_^',
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
              controller: _emailController,
            ),
            const SizedBox(height: 2),
            MyTextField(
              hintText: "Enter Password",
              obsText: true,
              controller: _passWController,
            ),
            const SizedBox(height: 2),
            MyTextField(
              hintText: "Re-Enter Password",
              obsText: true,
              controller: _rePassWController,
            ),
            const SizedBox(height: 20),
            MyButton(text: 'Login', onTap: login),
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
