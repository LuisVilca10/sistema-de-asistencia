import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/persona_api.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:flutter_application_1/src/ui/pages/home_page.dart';
import 'package:flutter_application_1/src/ui/pages/lading_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ThemeController.instance.initTheme(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return MultiProvider(
          providers: [
            Provider<PersonaApi>(
              create: (_) => PersonaApi.create(),
            ),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Sistema de asistencia UGEL-San Roman',
            theme: ThemeData(
              fontFamily: GoogleFonts.poppins().fontFamily,
            ),
            initialRoute: LandingPage.LANDING_PAGE_ROUTE,
            routes: {
              LandingPage.LANDING_PAGE_ROUTE: (context) => const LandingPage(),
              HomePage.HOME_PAGE_ROUTE: (context) => const HomePage(),
            },
          ),
        );
      },
    );
  }
}
