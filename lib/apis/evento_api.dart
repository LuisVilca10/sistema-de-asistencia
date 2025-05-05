import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventoApi {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> crearEvento({
    required String nombre,
    required String fechaInicio,
    required String fechaFin,
    required double latitud,
    required double longitud,
  }) async {
    try {
      // Obtener el token guardado
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {
          "status": 0,
          "message": "Token no encontrado. Por favor, inicie sesión.",
        };
      }

      final response = await _dio.post(
        "http://localhost/sis-asis/eventos.php", // Cambia según tu backend
        data: {
          "nombre": nombre,
          "fecha_inicio": fechaInicio,
          "fecha_fin": fechaFin,
          "latitud": latitud,
          "longitud": longitud,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token", // Aquí va el token
            "Content-Type": "application/json",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {"status": 0, "message": "Error en conexión o servidor: $e"};
    }
  }

  Future<Map<String, dynamic>> listarEventos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.get(
        "http://localhost/sis-asis/eventos.php",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return response.data;
    } catch (e) {
      return {"eventos": []}; // Retorna lista vacía en caso de error
    }
  }
}
