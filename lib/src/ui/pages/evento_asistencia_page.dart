import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EventoAsistenciaPage extends StatefulWidget {
  final Map<String, dynamic> evento;

  const EventoAsistenciaPage({super.key, required this.evento});

  @override
  State<EventoAsistenciaPage> createState() => _EventoAsistenciaPageState();
}

class _EventoAsistenciaPageState extends State<EventoAsistenciaPage> {
  final TextEditingController _dniController = TextEditingController();

  // Función para abrir la página de escáner y recibir el resultado
  Future<void> scanBarcode() async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => const BarcodeScannerPage()),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        _dniController.text = result;
      });
      print('Resultado escaneado: $result');
    } else {
      print('Escaneo cancelado o sin resultado');
    }
  }

  @override
  void dispose() {
    _dniController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nombreEvento = widget.evento['nombre'] ?? 'Detalle del Evento';

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
                hintText: 'Ingrese su DNI',
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final dni = _dniController.text;
                  print('Buscar DNI: $dni');
                },
                child: const Text('Buscar'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: scanBarcode,
        backgroundColor: Colors.cyan,
        child: const Icon(Icons.qr_code_scanner, color: Colors.white),
        elevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Nueva página para el escáner con mobile_scanner
class BarcodeScannerPage extends StatelessWidget {
  const BarcodeScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Escanear código')),
      body: MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) {
          final String code = barcode.rawValue ?? '';
          if (code.isNotEmpty) {
            Navigator.pop(context, code);
          }
        },
      ),
    );
  }
}
