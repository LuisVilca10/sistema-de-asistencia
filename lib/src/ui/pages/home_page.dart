import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/evento_api.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/util/UbicacionUtil.dart';

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

Future<void> _dialogBuilder(BuildContext context) async {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaHoraInicioController = TextEditingController();
  TextEditingController fechaHoraFinController = TextEditingController();

  // Variables para la ubicación
  double? latitud;
  double? longitud;

  // Obtención de ubicación al iniciar el diálogo
  Position? position = await obtenerUbicacionActual();
  if (position != null) {
    latitud = position.latitude;
    longitud = position.longitude;
  } else {
    // Mostrar un mensaje de error si no se puede obtener la ubicación
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('No se pudo obtener la ubicación')));
  }

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
            onPressed: () async {
              String nombre = nombreController.text;
              String fechaHoraInicio = fechaHoraInicioController.text;
              String fechaHoraFin = fechaHoraFinController.text;

              // Verificar si la latitud y longitud están disponibles
              if (nombre.isEmpty ||
                  fechaHoraInicio.isEmpty ||
                  fechaHoraFin.isEmpty ||
                  latitud == null ||
                  longitud == null) {
                // Mostrar error con SweetAlert, SnackBar o similar
                return;
              } else {
                // Aquí ya puedes hacer el POST a la API con todos los datos
                print("Evento: $nombre");
                print("Inicio: $fechaHoraInicio");
                print("Fin: $fechaHoraFin");
                print("Latitud: $latitud, Longitud: $longitud");

                final respuesta = await EventoApi().crearEvento(
                  nombre: nombre,
                  fechaInicio: fechaHoraInicio,
                  fechaFin: fechaHoraFin,
                  latitud: latitud,
                  longitud: longitud,
                );
                if (respuesta["status"] == 1) {
                  print("Evento creado");
                } else {
                  print("Evento: $respuesta");
                }
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
  const _Body();

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  List<dynamic> notes = [];

  @override
  void initState() {
    super.initState();
    cargarEventos();
  }

  Future<void> cargarEventos() async {
    // Aquí deberías llamar a tu API para obtener los eventos
    // Este es un ejemplo simulado. Reemplázalo con tu API real
    final eventos = await EventoApi().listarEventos(); // <-- tu función real
    setState(() {
      notes = eventos['eventos'] ?? [];
    });
  }

  Widget _image() {
    return Container(
      height: 100.0,
      width: double.infinity,
      margin: const EdgeInsets.only(left: 30, right: 30, top: 90),
      decoration: const BoxDecoration(
        image: DecorationImage(image: AssetImage("assets/logougel.png")),
      ),
    );
  }

  Widget _eventoCard(Map<String, dynamic> evento) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5, top: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Imagen de fondo
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      (evento["imagen"] != null &&
                              evento["imagen"].toString().isNotEmpty)
                          ? NetworkImage(evento["imagen"])
                          : const AssetImage("assets/evento.jpg")
                              as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // Capa de difuminado con info
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Info evento
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            evento["nombre"] ?? "Sin nombre",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "📅 ${evento["fecha_inicio"]} → ${evento["fecha_fin"]}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      // Botón de acción
                      IconButton(
                        onPressed: () {
                          // Acción de ver detalle
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Ícono flotante
            Positioned(
              top: 12,
              right: 12,
              child: InkWell(
                onTap: () {
                  // Marcar como favorito, por ejemplo
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeController.instance.background(),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child:
            notes.isEmpty
                ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _image(),
                    const SizedBox(height: 20),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Text(
                        "Presione el botón (+) para registrar un evento o reunión",
                      ),
                    ),
                  ],
                )
                : ListView.builder(
                  padding: const EdgeInsets.only(top: 1),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return _eventoCard(notes[index]);
                  },
                ),
      ),
    );
  }
}
