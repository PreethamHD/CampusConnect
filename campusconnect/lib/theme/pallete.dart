import 'package:flutter/material.dart';

class Pallete {
  static const darkColor = Color.fromRGBO(33, 30, 30, 1);
  static const darkColor2 = Color.fromRGBO(56, 51, 51, 1);
  static const blueColor = Color.fromRGBO(5, 110, 158, 1);
  static const brownColor = Color.fromRGBO(49, 46, 27, 1);
  static const whiteColor = Colors.white;

  static var darkMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: darkColor,
    cardColor: brownColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkColor,
      iconTheme: IconThemeData(color: whiteColor),
    ),
    drawerTheme: const DrawerThemeData(backgroundColor: darkColor),
    primaryColor: darkColor,
  );
}
