import 'package:flutter/material.dart';
import 'package:flutter_application_1/src/core/controllers/theme_controller.dart';

class AcercaDePage extends StatelessWidget {
  const AcercaDePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeController.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Acerca de'),
        backgroundColor: Colors.blue,
      ),
      backgroundColor: theme.background(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: const [
            _InfoCard(
              title: 'Aplicación de Gestión de Eventos',
              content:
                  'Esta aplicación permite organizar y administrar eventos, controlar asistencia con QR, visualizar ubicaciones con GPS, y personalizar tu evento de manera eficiente y segura.',
            ),
            SizedBox(height: 16),
            _InfoCard(
              title: 'Políticas de Privacidad',
              content:
                  'Respetamos tu privacidad. Los datos personales ingresados en la aplicación no serán compartidos con terceros sin tu consentimiento. Toda la información se almacena de forma segura.',
            ),
            SizedBox(height: 16),
            _InfoCard(
              title: 'Términos y Condiciones',
              content:
                  'El uso de esta aplicación implica la aceptación de nuestras políticas y condiciones. Nos reservamos el derecho de modificar funcionalidades en cualquier momento para mejorar el servicio.',
            ),
            SizedBox(height: 16),
            _InfoCard(
              title: 'Contacto',
              content:
                  'Para consultas, sugerencias o soporte técnico, puedes escribirnos a:\n\nsoporte@miapp.com\nTeléfono: +51 906771606',
            ),
            SizedBox(height: 16),
            _InfoCard(
              title: 'Versión de la Aplicación',
              content: 'Versión actual: 1.0.0\nÚltima actualización: Mayo 2025',
            ),
            SizedBox(height: 16),
            _InfoCard(
              title: 'Derechos Reservados',
              content: '© 2025 Manis`Dev. Todos los derechos reservados.',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String content;

  const _InfoCard({
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
