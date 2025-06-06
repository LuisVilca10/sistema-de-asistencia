import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:flutter_application_1/src/ui/widgets/loading_widget/loading_widget_controller.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white24,
      child: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: Container(
            height: 250,
            width: 250,
            decoration: BoxDecoration(
              color: ThemeController.instance.accent(),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Cargando",
                  style: Theme.of(
                    context,
                  ).textTheme.headlineMedium?.copyWith(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
                Text(
                  LoadingWidgetController.instance.contentValue(),
                  style: TextStyle(fontSize: 16, color: Colors.white54),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
