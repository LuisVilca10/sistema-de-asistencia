import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class OSMMapaSelectorPage extends StatefulWidget {
  final double latitud;
  final double longitud;

  const OSMMapaSelectorPage({
    super.key,
    required this.latitud,
    required this.longitud,
  });

  @override
  State<OSMMapaSelectorPage> createState() => _OSMMapaSelectorPageState();
}

class _OSMMapaSelectorPageState extends State<OSMMapaSelectorPage> {
  LatLng? selectedPoint;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona una ubicación')),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(widget.latitud, widget.longitud),
          initialZoom: 16.0,
          onTap: (tapPosition, point) {
            setState(() {
              selectedPoint = point;
            });
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
            userAgentPackageName: 'com.example.app',
          ),
          // ✅ Círculo de radio visual (por ejemplo, 100 metros)
          if (selectedPoint != null)
            CircleLayer(
              circles: [
                CircleMarker(
                  point: selectedPoint!,
                  radius: 100, // en metros
                  useRadiusInMeter: true,
                  color: Colors.blue.withOpacity(0.2),
                  borderStrokeWidth: 2,
                  borderColor: Colors.blueAccent,
                ),
              ],
            ),

          // ✅ Marcador visual
          if (selectedPoint != null)
            MarkerLayer(
              markers: [
                Marker(
                  width: 80,
                  height: 80,
                  point: selectedPoint!,
                  child: const Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
        ],
      ),
      floatingActionButton:
          selectedPoint != null
              ? FloatingActionButton.extended(
                onPressed: () {
                  const double radio = 100; // metros
                  Navigator.pop(context, {
                    'latitud': selectedPoint!.latitude,
                    'longitud': selectedPoint!.longitude,
                    'radio': radio,
                  });
                },
                label: const Text("Confirmar"),
                icon: const Icon(Icons.check),
              )
              : null,
    );
  }
}
