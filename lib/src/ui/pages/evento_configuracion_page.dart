import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:open_file/open_file.dart'; // <-- Agregado
import 'package:flutter_application_1/src/ui/pages/RuletaPage.dart';

Future<void> descargarCSV(BuildContext context, String eventoId) async {
  final url = Uri.parse(
    'https://prueba.metodica.pe/sis-asis/eventos.php?exportar_asistentes=1&evento_id=$eventoId',
  );

  // Verifica permisos para Android < 13
  if (Platform.isAndroid) {
    final deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;

    if (androidInfo.version.sdkInt < 33) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso denegado para guardar archivos')),
        );
        return;
      }
    }
  }

  // Descargar CSV
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final bytes = response.bodyBytes;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Guardar en documentos internos
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/asistentes_evento_${eventoId}_$now.csv';
    final file = File(path);

    await file.writeAsBytes(bytes);

    // Mostrar mensaje
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Archivo guardado en: $path')));

    // Abrir el archivo automáticamente
    final result = await OpenFile.open(path);

    if (result.type != ResultType.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No se pudo abrir el archivo automáticamente')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error al descargar CSV: ${response.statusCode}')),
    );
  }
}

class EventoConfiguracionPage extends StatelessWidget {
  final Map<String, dynamic> evento;

  const EventoConfiguracionPage({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configuración del Evento')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.casino),
              label: Text('Sorteo'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => RuletaPage(
                          eventoId: int.parse(evento['id'].toString()),
                        ),
                  ),
                );
              },
            ),
            SizedBox(height: 20), // Espacio entre botones
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('Exportar'),
              onPressed: () {
                final eventoId = evento['id'].toString();
                descargarCSV(context, eventoId);
              },
            ),
          ],
        ),
      ),
    );
  }
}
