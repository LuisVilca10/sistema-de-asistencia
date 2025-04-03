import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/constants/data.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:flutter_application_1/src/core/services/preferences_service.dart';
import 'package:flutter_application_1/src/ui/pages/home_page.dart';
import 'package:flutter_application_1/src/ui/widgets/buttons/simple_buttons.dart';
import 'package:flutter_application_1/src/ui/widgets/loading_widget/loading_widget.dart';
import 'package:flutter_application_1/src/ui/widgets/loading_widget/loading_widget_controller.dart';

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class LandingPage extends StatelessWidget {
  LandingPage({Key? key}) : super(key: key);

  static final LANDING_PAGE_ROUTE = "landing_page";
  // ignore: unused_field
  final PreferencesService _preferencesService = PreferencesService.instance;

  Widget _image() {
    return Container(
      height: 200.0,
      margin: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 30,
      ), // Ajusta la altura según lo que necesites
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/logougel.png")),
      ),
    );
  }

  Future<void> initMethods() async {}

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final theme = ThemeController.instance;
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeController.instance.background(),
          body: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: _image()),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: Text(
                    "Ingrese sus Credenciales",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color:
                          ThemeController.instance.brightnessValue
                              ? Colors.blueGrey
                              : Colors.blueGrey,
                    ),
                  ),
                ),

                SizedBox(height: 16),
                Container(
                  margin: EdgeInsets.only(left:1),
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Mascot Name',
                    ),
                  ),
                ),
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: MediumButton(
                    title: "Ingresar",
                    onTap: () async {
                      LoadingWidgetController.instance.loading();
                      await initMethods();
                      LoadingWidgetController.instance.close();
                      Navigator.pushNamed(context, HomePage.HOME_PAGE_ROUTE);
                    },
                  ),
                ),
              ],
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
    );
  }
}
