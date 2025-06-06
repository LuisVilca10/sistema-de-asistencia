import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventoAsistenciaPage extends StatefulWidget {
  final Map<String, dynamic> evento;

  const EventoAsistenciaPage({super.key, required this.evento});

  @override
  State<EventoAsistenciaPage> createState() => _EventoAsistenciaPageState();
}

class _EventoAsistenciaPageState extends State<EventoAsistenciaPage> {
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  bool usuarioNoExiste = false;

  List<Map<String, dynamic>> ultimasAsistencias = [];
  Map<String, dynamic>? ultimaAsistencia;

  Future<void> marcarAsistencia(String dni) async {
    final idEvento = int.tryParse(widget.evento['id'].toString()) ?? 0;

    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);

    final urlCheck = Uri.parse(
      'https://prueba.metodica.pe/sis-asis/verificar_usuario.php?dni=$dni',
    );
    final checkRes = await http.get(urlCheck);

    if (checkRes.statusCode == 200) {
      final data = jsonDecode(checkRes.body);
      final exists = data['existe'] == true;

      if (exists) {
        final nombre = data['nombres'] ?? 'Desconocido';

        // ✅ Verificar si ya marcó asistencia hoy
        final checkAsistenciaUrl = Uri.parse(
          'https://prueba.metodica.pe/sis-asis/verificar_asistencia.php?dni=$dni&evento_id=$idEvento&fecha=$fecha',
        );
        final checkAsistenciaRes = await http.get(checkAsistenciaUrl);
        final yaAsistio =
            jsonDecode(checkAsistenciaRes.body)['ya_asistio'] == true;

        if (yaAsistio) {
          showDialog(
            context: context,
            builder:
                (_) => AlertDialog(
                  title: const Text("⚠️ Ya registrado"),
                  content: Text("El usuario $nombre ya marcó asistencia hoy."),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Aceptar"),
                    ),
                  ],
                ),
          );
          return;
        }

        // 👉 Registrar asistencia si no ha asistido antes
        await registrarAsistencia(idEvento, dni, fecha, hora);

        setState(() {
          ultimaAsistencia = {
            'dni': dni,
            'nombre': nombre,
            'fecha': fecha,
            'hora': hora,
          };
          _dniController.clear();
          _nombreController.clear();
          usuarioNoExiste = false;
        });

        // 🟢 Mostrar diálogo de confirmación
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Registrado"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Usuario: $nombre"),
                    Text("Agregado correctamente a las $hora"),
                    Text("Del $fecha"),
                  ],
                ),
              ),
        );

        Future.delayed(const Duration(seconds: 2), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
          obtenerAsistenciasDelEvento();
        });
      } else {
        setState(() {
          usuarioNoExiste = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("⚠️ Usuario no encontrado")),
        );
      }
    }
  }

  Future<void> registrarAsistencia(
    int eventoId,
    String dni,
    String fecha,
    String hora,
  ) async {
    final url = Uri.parse(
      'https://prueba.metodica.pe/sis-asis/registrar_asistencia.php',
    );
    await http.post(
      url,
      body: {
        'evento_id': eventoId.toString(),
        'fecha': fecha,
        'hora': hora,
        'dni': dni,
        'porx': dni,
      },
    );
  }

  Future<void> registrarUsuarioYAsistencia() async {
    final dni = _dniController.text.trim();
    final nombre = _nombreController.text.trim();

    if (dni.isEmpty || nombre.isEmpty) return;

    final url = Uri.parse(
      'https://prueba.metodica.pe/sis-asis/registrar_usuario.php',
    );
    final res = await http.post(
      url,
      body: {'dni': dni, 'le': dni, 'nombres': nombre},
    );

    if (res.statusCode == 200) {
      setState(() => usuarioNoExiste = false);
      await marcarAsistencia(dni);
    }
  }

  Future<void> scanBarcode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _dniController.text = result;
      });
    }
  }

  Future<void> obtenerUltimasAsistencias(String dni) async {
    final url = Uri.parse(
      'https://prueba.metodica.pe/sis-asis/ultimas_asistencias.php?dni=$dni',
    );
    final res = await http.get(url);

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      setState(() {
        ultimasAsistencias = List<Map<String, dynamic>>.from(
          data['asistencias'] ?? [],
        );
      });
    }
  }

  List<Map<String, dynamic>> asistenciasEvento = [];

  Future<void> obtenerAsistenciasDelEvento() async {
    final idEvento = int.tryParse(widget.evento['id'].toString()) ?? 0;

    final url = Uri.parse(
      'https://prueba.metodica.pe/sis-asis/asistencias_por_evento.php?evento_id=$idEvento',
    );
    final res = await http.get(url);
    print("🟢 Respuesta del backend: ${res.body}");

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      if (data['success'] == true) {
        setState(() {
          asistenciasEvento = List<Map<String, dynamic>>.from(
            data['asistentes'] ?? [],
          );
        });
      } else {
        print("⚠️ Error en la respuesta: ${data['message']}");
      }
    } else {
      print("❌ Error HTTP: ${res.statusCode}");
    }
  }

  @override
  void initState() {
    super.initState();
    obtenerAsistenciasDelEvento();
  }

  @override
  Widget build(BuildContext context) {
    final nombreEvento = widget.evento['nombre'] ?? 'Evento';

    return Scaffold(
      appBar: AppBar(title: Text(nombreEvento)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          // Asegura que todo sea visible
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              TextField(
                controller: _dniController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'DNI',
                  hintText: 'Ingrese DNI',
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    final dni = _dniController.text;
                    if (dni.isNotEmpty) {
                      marcarAsistencia(dni);
                    }
                  },
                  child: const Text('Asistencia'),
                ),
              ),
              const SizedBox(height: 20),
              // ✅ Registro nuevo usuario
              if (usuarioNoExiste) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre completo',
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: registrarUsuarioYAsistencia,
                  child: const Text('Registrar nuevo usuario'),
                ),
              ],
              const SizedBox(height: 20),
              const Text(
                '📋 Lista de Asistencias:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: asistenciasEvento.length,
                itemBuilder: (context, index) {
                  final a = asistenciasEvento[index];
                  return Card(
                    child: ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(a['nombres']),
                      subtitle: Text(
                        "DNI: ${a['dni']} — ${a['fecha']} ${a['hora']}",
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanBarcode,
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
      ),
    );
  }
}

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  bool _permissionGranted = false;
  bool _isScanned = false; // 👈 Bandera para evitar múltiples lecturas

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() => _permissionGranted = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permiso de cámara denegado")),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear DNI')),
      body:
          _permissionGranted
              ? MobileScanner(
                onDetect: (BarcodeCapture capture) {
                  final barcode = capture.barcodes.first;
                  final code = barcode.rawValue ?? '';
                  if (code.isNotEmpty && !_isScanned) {
                    _isScanned = true; // 👈 Bloquea más lecturas
                    Navigator.pop(context, code);
                  }
                },
              )
              : const Center(child: CircularProgressIndicator()),
    );
  }
}
