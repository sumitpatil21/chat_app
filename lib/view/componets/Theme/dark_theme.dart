import 'package:flutter/material.dart';

class GlobalTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xffFFFFFF),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFFFFFF),
      titleTextStyle: TextStyle(
        color: Color(0xff00AD58),
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: Colors.black),
    //   bodyMedium: TextStyle(color: Colors.black87),
    // ),
    listTileTheme: const ListTileThemeData(
      titleTextStyle: TextStyle(color: Colors.black,fontSize: 20),
      subtitleTextStyle: TextStyle(
        fontSize: 17,
        color: Color(0xff7c8a8c),
      ),
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      textStyle: const TextStyle(),
      elevation: 2,
      labelTextStyle: WidgetStateProperty.all(const TextStyle(
        color: Colors.black,
      )),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF00AE59),
      onPrimary: Colors.white,
      secondary: Color(0xffefefef),
      onSecondary: Color(0xff8A9598),
      surface: Color(0xffD8FDD1),
      onSurface: Colors.black,
      tertiary: Color(0xffFFFFFF),
      onTertiary: Colors.black,
      error: Color(0xffa9ffa1),
      onError: Colors.white,
      // inversePrimary: Colors.black,
      // inverseSurface: Color(0xff8D9598),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0xFF0F1C24),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1B2C34),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20.0,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    // Dark background color
    // textTheme: const TextTheme(
    //   bodyLarge: TextStyle(color: Colors.white),
    //   bodyMedium: TextStyle(color: Colors.white70),
    // ),
    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xff121B22),
      labelTextStyle: WidgetStateProperty.all(TextStyle(
        color: Colors.white,
      )),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(color: Colors.white,fontSize: 20),
        subtitleTextStyle: TextStyle(color: Color(0xff8D9598),fontSize: 17)),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF1BD33A),
      onPrimary: Colors.black,
      secondary: Color(0xFF1B2C34),
      onSecondary: Color(0xff8C959A),
      surface: Color(0xff185d40),
      onSurface: Colors.white,
      tertiary: Color(0xff1F2C34),
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      // inversePrimary: Colors.white,
      // inverseSurface: Color(0xff8D9598)
    ),
  );
}
