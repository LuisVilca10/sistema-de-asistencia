import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/apis/evento_api.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';
import 'package:flutter_application_1/src/ui/pages/evento_asistencia_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_application_1/util/UbicacionUtil.dart';
import 'package:flutter_application_1/src/ui/pages/evento_configuracion_page.dart';

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
  final GlobalKey<_BodyState> bodyKey = GlobalKey<_BodyState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Future<bool> verificarYObtenerUbicacion() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        return false;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(height: 5),
          Column(
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Image.asset('assets/logougel.png'),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Eventos'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.qr_code),
            title: const Text('Asistencia'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Acerca de'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;
    return ScaffoldMessenger(
      key: homePageMessengerKey,
      child: Stack(
        children: [
          Scaffold(
            key: homePageKey, // Asegúrate de que esté definido
            drawer: _buildDrawer(context), // <--- Aquí agregas el drawer
            floatingActionButton: FloatingActionButton(
              backgroundColor: theme.primary(),
              onPressed:
                  () => _dialogBuilder(context, () {
                    bodyKey.currentState?.actualizarLista();
                  }),
              child: Icon(Icons.add, size: 25, color: Colors.white),
            ),
            backgroundColor: theme.background(),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.blue,
              elevation: 0,
              leading: IconButton(
                onPressed: () {
                  homePageKey.currentState?.openDrawer(); // <--- Abre el drawer
                },
                icon: Icon(Icons.menu, color: fontColor()),
              ),
              actions: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(CupertinoIcons.info_circle, color: fontColor()),
                ),
              ],
            ),
            body: _Body(key: bodyKey),
          ),
        ],
      ),
    );
  }
}

Future<void> _dialogBuilder(
  BuildContext context,
  VoidCallback onEventoCreado,
) async {
  TextEditingController nombreController = TextEditingController();
  TextEditingController fechaHoraInicioController = TextEditingController();
  TextEditingController fechaHoraFinController = TextEditingController();

  // Variables para la ubicación
  double? latitud;
  double? longitud;

  // Verifica que el GPS esté activado y se tengan permisos
  bool gpsActivo = await Geolocator.isLocationServiceEnabled();
  if (!gpsActivo) {
    await Geolocator.openLocationSettings();
    homePageMessengerKey.currentState?.showSnackBar(
      const SnackBar(content: Text('Por favor, activa el GPS')),
    );
    return;
  }

  LocationPermission permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied) {
    permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied) {
      homePageMessengerKey.currentState?.showSnackBar(
        const SnackBar(content: Text('Permiso de ubicación denegado')),
      );
      return;
    }
  }
  if (permiso == LocationPermission.deniedForever) {
    homePageMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text('Ubicación permanentemente denegada. Ve a ajustes.'),
      ),
    );
    return;
  }

  // Si todo está bien, obtener la ubicación
  Position position = await Geolocator.getCurrentPosition();
  latitud = position.latitude;
  longitud = position.longitude;

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
                if (respuesta["success"] == true || respuesta["status"] == 1) {
                  Navigator.pop(context); // Cierra el primer diálogo

                  // Muestra el segundo diálogo de éxito
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext innerContext) {
                      // Usamos innerContext para referenciar este diálogo
                      // Este contexto es clave para cerrarlo luego
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.pop(innerContext); // Cierra este diálogo
                        onEventoCreado(); // Actualiza la lista
                      });

                      return AlertDialog(
                        title: const Text('✅ Evento creado'),
                        content: const Text(
                          'El evento se ha registrado correctamente.',
                        ),
                      );
                    },
                  );
                } else {
                  // Si la respuesta es null o no contiene el status esperado
                  print(
                    "Error al crear evento: ${respuesta?["message"] ?? "Respuesta inesperada"}",
                  );

                  // Aquí podrías mostrar un mensaje de error con un diálogo o Snackbar
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text(
                          'Hubo un problema al crear el evento. Por favor, inténtalo nuevamente.',
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
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
  const _Body({Key? key}) : super(key: key);

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

  void actualizarLista() {
    print("Actualizando lista...");
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

  Widget _eventoCard(Map<String, dynamic> evento, VoidCallback actualizar) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventoAsistenciaPage(evento: evento),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, -2),
              blurRadius: 6,
            ),
          ],
          borderRadius: BorderRadius.circular(20),
        ),
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
                            ? NetworkImage(
                              "http://192.168.27.201/sis-asis/${evento["imagen"]}?v=${DateTime.now().millisecondsSinceEpoch}",
                            )
                            : const AssetImage("assets/evento.jpg")
                                as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              // Capa de info
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
                              "📅 Inicio: ${evento["fecha_inicio"]}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "📅 Fin: ${evento["fecha_fin"]}",
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (_) => EventoAsistenciaPage(evento: evento),
                              ),
                            );
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
              // Ícono flotante con menú de opciones
              Positioned(
                top: 12,
                right: 12,
                child: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTapDown: (TapDownDetails details) async {
                        final position = details.globalPosition;
                        final selected = await showMenu<String>(
                          context: context,
                          position: RelativeRect.fromLTRB(
                            position.dx,
                            position.dy,
                            position.dx,
                            position.dy,
                          ),
                          items: const [
                            PopupMenuItem<String>(
                              value: 'nombre',
                              child: Text('Cambiar nombre'),
                            ),
                            PopupMenuItem<String>(
                              value: 'fondo',
                              child: Text('Editar fondo'),
                            ),
                            PopupMenuItem<String>(
                              value: 'configuracion',
                              child: Text('Configuración'),
                            ),
                            PopupMenuItem<String>(
                              value: 'eliminar',
                              child: Text('Eliminar'),
                            ),
                          ],
                        );

                        // ...acciones después de seleccionar una opción...
                        if (selected == 'nombre') {
                          _cambiarNombreEvento(context, evento);
                        } else if (selected == 'eliminar') {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Confirmar eliminación'),
                                  content: const Text(
                                    '¿Estás seguro de que deseas eliminar este evento?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      child: const Text('Eliminar'),
                                    ),
                                  ],
                                ),
                          );

                          if (confirm == true) {
                            final api = EventoApi();
                            final response = await api.eliminarEvento(
                              int.parse(evento['id'].toString()),
                            );

                            if (response['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Evento eliminado con éxito'),
                                ),
                              );
                              actualizarLista(); // Asegúrate de que esto refresque correctamente los datos en pantalla
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al eliminar: ${response['message'] ?? 'desconocido'}',
                                  ),
                                ),
                              );
                            }
                          }
                        } else if (selected == 'fondo') {
                          final picker = ImagePicker();
                          final pickedFile = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedFile != null) {
                            final imageBytes = await pickedFile.readAsBytes();
                            final base64Image = base64Encode(imageBytes);

                            final response = await EventoApi()
                                .actualizarFondoEvento(
                                  int.parse(evento['id'].toString()),
                                  base64Image,
                                );

                            if (response['success'] == true) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Fondo actualizado con éxito'),
                                ),
                              );
                              actualizar();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error: ${response['message'] ?? 'Error al subir fondo'}',
                                  ),
                                ),
                              );
                            }
                          }
                        } else if (selected == 'configuracion') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      EventoConfiguracionPage(evento: evento),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.more_vert,
                          color: Color.fromARGB(255, 61, 141, 128),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Función _cambiarNombreEvento movida fuera del widget _eventoCard
  void _cambiarNombreEvento(BuildContext outerContext, Map evento) {
    final TextEditingController controller = TextEditingController(
      text: evento['nombre'],
    );

    showDialog(
      context: outerContext,
      builder: (context) {
        return AlertDialog(
          title: const Text("Cambiar nombre del evento"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(labelText: "Nuevo nombre"),
          ),
          actions: [
            TextButton(
              child: const Text("Cancelar"),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: const Text("Guardar"),
              onPressed: () async {
                final nuevoNombre = controller.text.trim();
                if (nuevoNombre.isNotEmpty) {
                  final api = EventoApi();
                  final respuesta = await api.actualizarNombreEvento(
                    int.parse(evento['id'].toString()),
                    nuevoNombre,
                  );
                  if (respuesta['success'] == true) {
                    Navigator.pop(context);

                    // Usa el contexto externo (que tiene Scaffold)
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      const SnackBar(content: Text("Nombre actualizado")),
                    );

                    await cargarEventos();
                    print("Eventos actualizados: ${notes.length}");
                  } else {
                    ScaffoldMessenger.of(outerContext).showSnackBar(
                      SnackBar(content: Text("Error: ${respuesta['error']}")),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
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
                    return _eventoCard(notes[index], actualizarLista);
                  },
                ),
      ),
    );
  }
}
