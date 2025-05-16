import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/src/ui/pages/home_page.dart';
import 'package:flutter_application_1/src/ui/pages/lading_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Esto es obligatorio para usar async en main
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString("token");

  runApp(MyApp(
    initialRoute: token != null
        ? HomePage.HOME_PAGE_ROUTE
        : LandingPage.LANDING_PAGE_ROUTE,
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ThemeController.instance.initTheme(),
      builder: (context, snapshot) {
  if (snapshot.hasError) {
    print('Error al inicializar el tema: ${snapshot.error}');
    return const MaterialApp(
      home: Scaffold(
        body: Center(child: Text("Error al cargar tema")),
      ),
    );
  }

        return MaterialApp(
          routes: {
            HomePage.HOME_PAGE_ROUTE: (context) => HomePage(),
            LandingPage.LANDING_PAGE_ROUTE: (context) => LandingPage(),
          },
          initialRoute: initialRoute,
          debugShowCheckedModeBanner: false,
          title: 'Sistema de asistencia UGEL-San Roman',
          theme: ThemeData(
            fontFamily: GoogleFonts.poppins().fontFamily,
          ),
        );
      },
    );
  }
}