import 'package:geolocator/geolocator.dart';

Future<Position?> obtenerUbicacionActual() async {
  bool servicioActivo = await Geolocator.isLocationServiceEnabled();
  if (!servicioActivo) {
    return null;
  }

  LocationPermission permiso = await Geolocator.checkPermission();
  if (permiso == LocationPermission.denied) {
    permiso = await Geolocator.requestPermission();
    if (permiso == LocationPermission.denied) {
      return null;
    }
  }

  if (permiso == LocationPermission.deniedForever) {
    return null;
  }

  return await Geolocator.getCurrentPosition(
    desiredAccuracy: LocationAccuracy.high,
  );
}