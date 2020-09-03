import 'package:flutter/material.dart';

class AppTheme extends ChangeNotifier {
  bool isDark;
  ThemeData themeData;

  AppTheme(bool isDark) {
    this.isDark = isDark;
    themeData = isDark ? darkTheme : lightTheme;
  }

  changeTheme(bool value) {
    themeData = value ? darkTheme : lightTheme;
    this.isDark = value;
    notifyListeners();
  }

  ThemeData lightTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      accentColor: Colors.black,
      appBarTheme: AppBarTheme(
        color: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      cardTheme: CardTheme(
        color: Colors.white12,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      textTheme: TextTheme(
          title: TextStyle(
            color: Colors.black,
            fontSize: 20.0,
          ),
          subtitle: TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
          ),
          body1: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
          ),
          body2: TextStyle(
            color: Colors.black,
            fontSize: 14.0,
          )),
      toggleableActiveColor: Colors.green);

  ThemeData darkTheme = ThemeData(
      scaffoldBackgroundColor: Colors.black87,
      backgroundColor: Colors.black87,
      accentColor: Colors.white,
      appBarTheme: AppBarTheme(
        color: Colors.black87,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.black26,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      textTheme: TextTheme(
          title: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
          ),
          subtitle: TextStyle(
            color: Colors.white70,
            fontSize: 18.0,
          ),
          body1: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
          body2: TextStyle(
            color: Colors.white,
            fontSize: 14.0,
          )),
      toggleableActiveColor: Colors.green);
}
