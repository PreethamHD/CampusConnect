import 'package:campusconnect/screens/loginpg.dart';
import 'package:campusconnect/screens/sign_upPg.dart';
import 'package:flutter/material.dart';

class Loginsignpg extends StatefulWidget {
  const Loginsignpg({super.key});

  @override
  State<Loginsignpg> createState() => _LoginsignpgState();
}

class _LoginsignpgState extends State<Loginsignpg> {
  bool isShowingLoginpg = true;
  void togglePg() {
    setState(() {
      isShowingLoginpg = !isShowingLoginpg;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isShowingLoginpg) {
      return Loginpg(onTap: togglePg);
    } else {
      return SignUppg(onTap: togglePg);
    }
  }
}
