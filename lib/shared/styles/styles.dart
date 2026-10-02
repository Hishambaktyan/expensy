import 'package:flutter/material.dart';
import 'colors.dart';

ThemeData lightTheme = ThemeData(
  fontFamily: 'Tajawal',
  scaffoldBackgroundColor: bgColor,
  colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
  appBarTheme: const AppBarTheme(
    backgroundColor:  bgColor,
    scrolledUnderElevation: 0,
    titleSpacing: 10,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.black,
      )
  ),
  iconTheme: const IconThemeData(
      color: Colors.black
  ),
);

ThemeData darkTheme = ThemeData(
  fontFamily: 'Tajawal',
  scaffoldBackgroundColor: darkBgColor,
  colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
  appBarTheme: const AppBarTheme(
    backgroundColor:  darkBgColor,
    scrolledUnderElevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
      )
  ),
  iconTheme: const IconThemeData(
      color: Colors.white
  ),
);