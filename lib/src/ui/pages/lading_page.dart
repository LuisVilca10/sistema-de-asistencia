import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
// import 'package:flutter_application_1/src/core/services/preferences_service.dart';
import 'package:flutter_application_1/src/ui/pages/home_page.dart';
import 'package:flutter_application_1/src/ui/widgets/buttons/simple_buttons.dart';
import 'package:flutter_application_1/src/ui/widgets/loading_widget/loading_widget.dart';
import 'package:flutter_application_1/src/ui/widgets/loading_widget/loading_widget_controller.dart';

GlobalKey<ScaffoldState> landingPageKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> landingPageMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});
  static final LANDING_PAGE_ROUTE = "landing_page";
  // ignore: unused_field
  // final PreferencesService _preferencesService = PreferencesService.instance;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  Widget _image() {
    return Container(
      height: 100.0,
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 90,
        bottom: 30
      ), // Ajusta la altura según lo que necesites
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/logougel.png"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = ThemeController.instance;
    return ScaffoldMessenger(
      key: landingPageMessengerKey,
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: ThemeController.instance.background(),
            body: SingleChildScrollView(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _image(),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 30),
                      child: Text(
                        "Ingrese sus Credenciales",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color:
                              ThemeController.instance.brightnessValue
                                  ? Colors.blueGrey
                                  : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 25),
                    Container(
                      margin: EdgeInsets.only(left: 1),
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nombre Y Apellido Completo',
                          hintText: 'Juan Perez Perez',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1),
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Correo Electronico',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                          hintText: 'ejemplo@ejemplo.com',
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1),
                      padding: EdgeInsets.all(8.0),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: '8 digitos',
                          labelText: 'DNI',
                          hintStyle: TextStyle(color: Colors.grey),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: MediumButton(
                        title: "Ingresar",

                        onTap: () async {
                          LoadingWidgetController.instance.loading();
                          // await initMethods();
                          LoadingWidgetController.instance.close();
                          Navigator.pushNamed(
                            context,
                            HomePage.HOME_PAGE_ROUTE,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: LoadingWidgetController.instance.loadingNotifier,
            builder: (context, bool value, Widget? child) {
              return value ? LoadingWidget() : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
