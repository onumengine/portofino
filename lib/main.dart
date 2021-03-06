import 'package:flutter/material.dart';
import 'package:port/screens/splash_screen.dart';
import 'package:port/utility/colors.dart';
import 'utility/colors_main.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: colorAppBackground,
        accentColor: colorOrangeAccent,
        scaffoldBackgroundColor: colorAppBackground,
        fontFamily: "Sarabun",
        appBarTheme: AppBarTheme(
          backgroundColor: colorAppBackground,
          elevation: 0,
          titleTextStyle: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: appBarTitleColor,
          ),
        ),
      ),
      home: SplashScreen(),
    );
  }
}
