import 'package:dio/dio.dart';

class PersonaApi {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login({
    required String nombre,
    required String correo,
    required String dni,
  }) async {
    try {
      final response = await _dio.post(
        "http://localhost/sis-asis/auth.php", // Cambia esto
        data: {
          "nombre": nombre,
          "correo": correo,
          "dni": dni,
        },
      );

      return response.data;
    } catch (e) {
      return {
        "status": 0,
        "message": "Error en conexión o en el servidor: $e",
      };
    }
  }
}
