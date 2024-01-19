import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gifthamperz/configs/colors_constant.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Poppens',
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(
      color: Colors.black,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    color: Colors.white,
    elevation: 0.0,
  ),
  scaffoldBackgroundColor: Colors.white,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: white,
    selectedItemColor: Colors.orange,
    showUnselectedLabels: true,
    unselectedItemColor: black,
    type: BottomNavigationBarType.fixed,
    elevation: 0.0,
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Poppens',
  appBarTheme: const AppBarTheme(
    titleTextStyle: TextStyle(color: Colors.white),
    iconTheme: IconThemeData(color: Colors.white),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: darkBackgroundColor,
      statusBarIconBrightness: Brightness.light,
    ),
    color: darkBackgroundColor,
    elevation: 0.0,
  ),
  scaffoldBackgroundColor: darkBackgroundColor,
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: darkBackgroundColor,
    selectedLabelStyle: TextStyle(
      color: Colors.white,
    ),
    selectedItemColor: Colors.orange,
    type: BottomNavigationBarType.fixed,
    unselectedItemColor: darkBackgroundColor,
    elevation: 0.0,
  ),
);
