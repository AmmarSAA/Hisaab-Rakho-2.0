/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: main.dart                                                              |*/
/*| Path: lib/main.dart                                                          |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Main Application File                                               |*/
/*| Output: Implement Main Application File                                      |*/
/*| Description: Serves as a starting point for Hisaab Rakho                     |*/
/*+------------------------------------------------------------------------------+*/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hisaab_rakho/utils/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: 'Hisaab Rakho',
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          fontFamily: GoogleFonts.inter().fontFamily,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7f3dff),
          ).copyWith(surface: Colors.white),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
          ),
        ),
        darkTheme: ThemeData.dark().copyWith(
          textTheme: GoogleFonts.interTextTheme(),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF7f3dff),
          ).copyWith(surface: Colors.black),
          inputDecorationTheme: const InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 2.0),
          ),
        ),
        themeMode: ThemeMode.light,
        initialRoute: '/',
        routes: appRoutes);
  }
}
