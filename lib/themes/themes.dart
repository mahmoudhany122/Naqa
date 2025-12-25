import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.brown,
  scaffoldBackgroundColor: Colors.brown.shade900,
  backgroundColor: Colors.brown.shade900,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.brown,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.brown,
      statusBarIconBrightness: Brightness.light,
    ),
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 22,
      fontWeight: FontWeight.bold,
    ),
  ),

  iconTheme: const IconThemeData(color: Colors.white),

  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white),
    headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
    headline5: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
    headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white70),
    bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
    bodyText2: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.white70),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),

  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.brown,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    selectedIconTheme: IconThemeData(color: Colors.white, size: 28),
    unselectedIconTheme: IconThemeData(color: Colors.grey, size: 26),
    showUnselectedLabels: true,
    showSelectedLabels: true,
    elevation: 5,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.orangeAccent,
  ),
);



ThemeData lightTheme = ThemeData(
  primarySwatch: Colors.cyan,
  scaffoldBackgroundColor: Colors.white,
  backgroundColor: Colors.grey.shade100,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 0.0,
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
  ),

  iconTheme: const IconThemeData(color: Colors.black),

  textTheme: const TextTheme(
    headline1: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.brown),
    headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.brown),
    headline5: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black87),
    headline6: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.black54),
    bodyText1: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black),
    bodyText2: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black87),
    button: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: Colors.cyan,
    unselectedItemColor: Colors.grey.shade600,
    selectedIconTheme: const IconThemeData(color: Colors.cyan, size: 28),
    unselectedIconTheme: IconThemeData(color: Colors.grey.shade600, size: 26),
    showUnselectedLabels: true,
    showSelectedLabels: true,
    elevation: 5,
  ),

  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.cyan,
  ),
);
