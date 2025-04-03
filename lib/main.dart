import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/ui/pages/home_page.dart';
import 'package:flutter_application_1/src/ui/pages/lading_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ThemeController.instance.initTheme(),
      builder: (snapshot, context) {
        return MaterialApp(
          routes: {
            HomePage.HOME_PAGE_ROUTE: (context) => HomePage(),
            LandingPage.LANDING_PAGE_ROUTE: (context) => LandingPage(),
          },
          initialRoute: LandingPage.LANDING_PAGE_ROUTE,
          debugShowCheckedModeBanner: false,
          title: 'Sistema de asistencia UGEL-San Roman',
          theme: ThemeData(fontFamily: GoogleFonts.poppins().fontFamily),
        );
      },
    );
  }
}
