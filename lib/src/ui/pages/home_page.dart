import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';

GlobalKey<ScaffoldState> homePageKey = GlobalKey<ScaffoldState>();
GlobalKey<ScaffoldMessengerState> homePageMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

Color fontColor() {
  return ThemeController.instance.brightnessValue ? Colors.black : Colors.white;
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const HOME_PAGE_ROUTE = "home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    return ScaffoldMessenger(
      key: homePageMessengerKey,
      child: Stack(
        children: [
          Scaffold(
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primary(),
              onPressed: () => _dialogBuilder(context),
              child: Icon(Icons.add, size: 25, color: Colors.white),
            ),
            backgroundColor: theme.background(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.menu, color: fontColor()),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.info_circle, color: fontColor()),
                ),
                /*IconButton(
                  onPressed: () {
                    _controller.open();
                  },
                  icon: Icon(
                    Icons.lock,
                    color: fontColor(),
                  ),
                )*/
              ],
            ),
            body: _Body(),
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ThemeController.instance.background(),
        title: const Text('Crear Nuevo'),
        content: const TextField(
          cursorColor: Colors.black54,
          decoration: InputDecoration(
            labelText: "Crear Evento o Reunión",
            labelStyle: TextStyle(
              color: Colors.black54, // Cambia el color de la etiqueta
            ),
            border: OutlineInputBorder(),
            hintStyle: TextStyle(color: Colors.grey),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('Crear'),
            onPressed: () {},
          ),
        ],
      );
    },
  );
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  const _Body({super.key});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<dynamic> notes = [];

  Widget _image() {
    return Container(
      height: 100.0,
      width: double.infinity,
      margin: EdgeInsets.only(left: 30, right: 30, top: 90),
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/logougel.png")),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: ThemeController.instance.background(),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _image(),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: Text(
                    "Presione el boton (+) para registrar un evento o reunión",
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
