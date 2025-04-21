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
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaHoraInicioController = TextEditingController();
  TextEditingController fechaHoraFinController = TextEditingController();

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: ThemeController.instance.background(),
        title: const Text('Crear Nuevo'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Nombre del evento
            TextField(
              controller: nombreController,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: "Nombre del evento",
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
            SizedBox(height: 10),

            // Fecha y hora de inicio
            TextField(
              controller: fechaHoraInicioController,
              readOnly: true,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: "Fecha y Hora de Inicio",
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    final dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    fechaHoraInicioController.text = dateTime
                        .toString()
                        .substring(0, 16); // yyyy-MM-dd HH:mm
                  }
                }
              },
            ),
            SizedBox(height: 10),

            // Fecha y hora de fin
            TextField(
              controller: fechaHoraFinController,
              readOnly: true,
              cursorColor: Colors.black54,
              decoration: InputDecoration(
                labelText: "Fecha y Hora de Fin",
                labelStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(),
                hintStyle: TextStyle(color: Colors.grey),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null) {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (selectedTime != null) {
                    final dateTime = DateTime(
                      selectedDate.year,
                      selectedDate.month,
                      selectedDate.day,
                      selectedTime.hour,
                      selectedTime.minute,
                    );
                    fechaHoraFinController.text = dateTime.toString().substring(
                      0,
                      16,
                    ); // yyyy-MM-dd HH:mm
                  }
                }
              },
            ),
          ],
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
            onPressed: () {
              String nombre = nombreController.text;
              String fechaHoraInicio = fechaHoraInicioController.text;
              String fechaHoraFin = fechaHoraFinController.text;

              if (nombre.isEmpty ||
                  fechaHoraInicio.isEmpty ||
                  fechaHoraFin.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Todos los campos son obligatorios')),
                );
              } else {
                print("Evento: $nombre");
                print("Inicio: $fechaHoraInicio");
                print("Fin: $fechaHoraFin");

                Navigator.of(context).pop();
              }
            },
          ),
        ],
      );
    },
  );
}

// ignore: must_be_immutable
class _Body extends StatefulWidget {
  // const _Body({super.key});
  const _Body();
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
