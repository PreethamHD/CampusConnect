import 'package:campusconnect/theme/pallete.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final bool obsText;
  final TextEditingController controller;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.obsText,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Pallete.brownColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Pallete.brownColor),
          ),
          fillColor: Pallete.darkColor2,
          filled: true,
          hintText: hintText,
        ),
        obscureText: obsText,
        controller: controller,
      ),
    );
  }
}
