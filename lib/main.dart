import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/pages/chatpage.dart';
import 'package:untitled2/pages/homepage.dart';
import 'package:untitled2/tools/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.submitButton),
        textTheme: GoogleFonts.interTextTheme(
          ThemeData.dark().textTheme.copyWith(
            bodyMedium: const TextStyle(
              fontSize: 15,
              color: Color(0xFFFAF9F6)
            )
          )
        ),

      ),
      home:HomePage()
    );
  }
}
