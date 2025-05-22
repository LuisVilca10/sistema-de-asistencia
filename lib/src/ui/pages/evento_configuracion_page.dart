import 'package:flutter/material.dart';

class EventoConfiguracionPage extends StatelessWidget {
  final Map<String, dynamic> evento;

  const EventoConfiguracionPage({super.key, required this.evento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración del Evento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.shuffle),
              label: Text('Sorteo'),
              onPressed: () {
                // TODO: Acción de sorteo
              },
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('Exportar'),
              onPressed: () {
                // TODO: Acción de exportar
              },
            ),
          ],
        ),
      ),
    );
  }
}
