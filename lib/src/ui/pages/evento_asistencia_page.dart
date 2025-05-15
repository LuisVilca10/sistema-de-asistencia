import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';

class EventoAsistenciaPage extends StatefulWidget {
  final Map<String, dynamic> evento;

  const EventoAsistenciaPage({super.key, required this.evento});

  @override
  State<EventoAsistenciaPage> createState() => _EventoAsistenciaPageState();
}

class _EventoAsistenciaPageState extends State<EventoAsistenciaPage> {
  final TextEditingController _dniController = TextEditingController();

  // Aquí colocas la función scanBarcode dentro del State
  Future<void> scanBarcode() async {
    try {
      String scanResult = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancelar',
        true,
        ScanMode.DEFAULT,
      );

      if (scanResult != '-1') {
        print('Resultado escaneado: $scanResult');
        // Puedes mostrar el resultado en el TextField o hacer algo más
        setState(() {
          _dniController.text = scanResult; // Pone el resultado en el campo DNI
        });
      } else {
        print('Escaneo cancelado');
      }
    } catch (e) {
      print('Error al escanear: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final String nombreEvento = widget.evento['nombre'] ?? 'Detalle del Evento';

    return Scaffold(
      appBar: AppBar(title: Text(nombreEvento)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40), // espacio arriba para bajar un poco

            // Campo de texto DNI
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
      floatingActionButton: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: scanBarcode,
          backgroundColor: Colors.cyan,
          child: const Icon(
            Icons.qr_code_scanner,
            color: Colors.white,
          ),
          elevation: 0,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}