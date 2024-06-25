import 'package:flutter/material.dart';

const _defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(5)),
  borderSide: BorderSide.none,
);

ThemeData lightTheme(BuildContext context) {
  return ThemeData(
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      errorStyle: TextStyle(
        color: Color(0xffEB5757),
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      fillColor: Color(0xFFEAEFF3),
      hintStyle: TextStyle(
        color: Color(0xFF8E98A3),
        fontSize: 14,
      ),
      labelStyle: TextStyle(
        color: Color(0xFF8E98A3),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      border: _defaultInputBorder,
      focusedBorder: _defaultInputBorder,
      enabledBorder: _defaultInputBorder,
      errorBorder: _defaultInputBorder,
    ),
    colorScheme: const ColorScheme.light(
      // primary: Color(0xFF17192D),
      // secondary: Color(0xFF2188FF),
      error: Color(0xffEB5757),
    ),
    appBarTheme: const AppBarTheme(
      color: Color(0xFF17192D),
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
          fontWeight: FontWeight.w400, color: Colors.white, fontSize: 18),
    ),
  );
}
