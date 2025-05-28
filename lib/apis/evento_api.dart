import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EventoApi {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> crearEvento({
    required String nombre,
    String? imagen,
    required String fechaInicio,
    required String fechaFin,
    required double latitud,
    required double longitud,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      if (token == null) {
        return {
          "status": 0,
          "message": "Token no encontrado. Por favor, inicie sesión.",
        };
      }

      final response = await _dio.post(
        "http://localhost/sis-asis/eventos.php",
        data: {
          "nombre": nombre,
          "imagen": imagen,
          "fecha_inicio": fechaInicio,
          "fecha_fin": fechaFin,
          "latitud": latitud,
          "longitud": longitud,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
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
      return {"eventos": []};
    }
  }

  Future<Map<String, dynamic>> eliminarEvento(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.delete(
        "http://localhost/sis-asis/eventos.php?id=$id", // ← aquí el id en la URL
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );
      return response.data;
    } catch (e) {
      return {"status": 0, "message": "Error al eliminar evento: $e"};
    }
  }

  Future<Map<String, dynamic>> actualizarNombreEvento(
    int id,
    String nuevoNombre,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.put(
        "http://localhost/sis-asis/eventos.php",
        data: {
          "id": id,
          "nombre": nuevoNombre, // <- CAMBIO AQUÍ
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {"success": false, "error": "Error de conexión o servidor: $e"};
    }
  }

  Future<Map<String, dynamic>> actualizarFondoEvento(
    int id,
    String base64Image,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.put(
        "http://localhost/sis-asis/eventos.php",
        data: {"id": id, "imagen": base64Image},
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Content-Type": "application/json",
          },
        ),
      );

      return response.data;
    } catch (e) {
      return {"success": false, "error": "Error de conexión o servidor: $e"};
    }
  }

  Future<List<Map<String, dynamic>>> listarAsistentesPorEvento(
    int eventoId,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    try {
      final response = await _dio.get(
        "http://localhost/sis-asis/asistentes.php?evento_id=$eventoId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data["success"] == true) {
        return List<Map<String, dynamic>>.from(response.data["asistentes"]);
      } else {
        return [];
      }
    } catch (e) {
      print("Error al listar asistentes: $e");
      return [];
    }
  }
}
