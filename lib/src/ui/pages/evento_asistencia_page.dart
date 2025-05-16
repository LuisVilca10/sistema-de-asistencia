import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> marcarAsistencia(String dni) async {
    final idEvento = int.tryParse(widget.evento['id'].toString()) ?? 0;

    final now = DateTime.now();
    final fecha = DateFormat('yyyy-MM-dd').format(now);
    final hora = DateFormat('HH:mm:ss').format(now);

    final urlCheck = Uri.parse('http://192.168.71.189/sis-asis/verificar_usuario.php?dni=$dni');
    final checkRes = await http.get(urlCheck);

    if (checkRes.statusCode == 200) {
      final exists = jsonDecode(checkRes.body)['existe'] == true; 
      if (exists) {
          await registrarAsistencia(idEvento, dni, fecha, hora);
          setState(() {
            _dniController.clear();
            _nombreController.clear();
            usuarioNoExiste = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ Asistencia registrada"))
          );
        } else {
        setState(() {
          usuarioNoExiste = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("⚠️ Usuario no encontrado")));
      }
    }
  }

  Future<void> registrarAsistencia(int eventoId, String dni, String fecha, String hora) async {
    final url = Uri.parse('http://192.168.71.189/sis-asis/registrar_asistencia.php');
    await http.post(url, body: {
      'evento_id': eventoId.toString(),
      'fecha': fecha,
      'hora': hora,
      'dni': dni,
      'porx': dni,
    });
  }

  Future<void> registrarUsuarioYAsistencia() async {
    final dni = _dniController.text.trim();
    final nombre = _nombreController.text.trim();

    if (dni.isEmpty || nombre.isEmpty) return;

    final url = Uri.parse('http://192.168.71.189/sis-asis/registrar_usuario.php');
    final res = await http.post(url, body: {
      'dni': dni,
      'le': dni,
      'nombres': nombre,
    });

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

  @override
  Widget build(BuildContext context) {
    final nombreEvento = widget.evento['nombre'] ?? 'Evento';

    return Scaffold(
      appBar: AppBar(title: Text(nombreEvento)),
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            ]
          ],
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

class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear DNI')),
      body: MobileScanner(
        onDetect: (barcode, args) {
          final code = barcode.rawValue ?? '';
          if (code.isNotEmpty) {
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}
