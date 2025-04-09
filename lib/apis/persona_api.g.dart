part of 'persona_api.dart';

class _PersonaApi implements PersonaApi {
  _PersonaApi(this._dio, {this.baseUrl}) {
    baseUrl ??= UrlApi.urlApix;
  }

  final Dio? _dio;
  String? baseUrl;

  @override
  Future<TokenModelo> login(user) async {
    final _data = <String, dynamic>{}..addAll(user.toJson());
    final response = await _dio!.request<Map<String, dynamic>>(
      'http://localhost/sis-asis/api.php',
      data: _data,
      options: Options(
        method: 'POST',
        headers: <String, dynamic>{},
        extra: const <String, dynamic>{},
      ),
    );
    return TokenModelo.fromJson(response.data!);
  }

  @override
  Future<ResponseModelo> createPersona(String token, persona) async {
    final _data = <String, dynamic>{}..addAll(persona.toJson());
    final response = await _dio!.request<Map<String, dynamic>>(
      '/api/persona',
      data: _data,
      options: Options(
        method: 'POST',
        headers: {"Authorization": token},
        extra: const <String, dynamic>{},
      ),
    );
    return ResponseModelo.fromJson(response.data!);
  }

  @override
  Future<ResponseModelo> deletePersona(String token, int id) async {
    final response = await _dio!.request<Map<String, dynamic>>(
      '/api/persona/$id',
      options: Options(
        method: 'DELETE',
        headers: {"Authorization": token},
        extra: const <String, dynamic>{},
      ),
    );
    return ResponseModelo.fromJson(response.data!);
  }

  @override
  Future<ResponseModelo> getPersona(String token) async {
    final response = await _dio!.request<Map<String, dynamic>>(
      '/api/persona/',
      options: Options(
        method: 'GET',
        headers: {"Authorization": token},
        extra: const <String, dynamic>{},
      ),
    );
    return ResponseModelo.fromJson(response.data!);
  }

  @override
  Future<ResponseModelo> updatePersona(String token, int id, persona) async {
    final _data = <String, dynamic>{}..addAll(persona.toJson());
    final response = await _dio!.request<Map<String, dynamic>>(
      '/api/persona/$id',
      data: _data,
      options: Options(
        method: 'PATCH',
        headers: {"Authorization": token},
        extra: const <String, dynamic>{},
      ),
    );
    return ResponseModelo.fromJson(response.data!);
  }
}
