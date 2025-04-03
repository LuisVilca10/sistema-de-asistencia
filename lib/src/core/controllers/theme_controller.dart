import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/services/preferences_service.dart';
import 'package:flutter_application_1/src/ui/configure.dart';

class ThemeController {
  ThemeController._(); //privado

  static final instance = ThemeController._();

  //actua como seitch
  ValueNotifier<bool> brightness = ValueNotifier<bool>(true);
  bool get brightnessValue => brightness.value;

  Color primary() =>
      brightnessValue ? Configure.PRIMARY : Configure.PRIMARY_DARK;
  Color secondary() => Configure.SECONDARY;
  Color auxiliar() => Configure.AUXILIAR;
  Color accent() => Configure.ACCENT;

  Color primaryButton() =>
      brightnessValue
          ? Configure.PRIMARY_BUTTON_LIGHT
          : Configure.PRIMARY_BUTTON_DARK;
  Color secondaryButton() => Configure.SECONDARY_BUTTON_LIGHT;

  Color background() =>
      brightnessValue ? Configure.BACKGROUND_DARK : Configure.BACKGROUND_LIGHT;

  void changeTheme() async {
    brightness.value = !brightness.value;
    await PreferencesService.instance.setBool("tema", brightness.value);
  }

  Future<void> initTheme() async {
    brightness.value = await PreferencesService.instance.getBool("tema");
  }
}
