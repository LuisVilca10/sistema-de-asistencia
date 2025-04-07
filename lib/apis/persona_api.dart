import 'package:flutter_application_1/modelo/PersonaModelo.dart';
import 'package:flutter_application_1/modelo/UsuarioModelo.dart';
import 'package:flutter_application_1/util/UrlApi.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart' hide Headers;


part 'persona_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class PersonaApi {
  factory PersonaApi(Dio dio, {String baseUrl}) = _PersonaApi;
  static PersonaApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return PersonaApi(dio);
  }
  @POST("/api/auth/login") 
  Future<TokenModelo> login(@Body() UsuarioModelo usuario);

  @GET("/api/persona")
  Future<ResponseModelo> getPersona(@Header("Authorization") String token);
  @POST("/api/persona")
  Future<ResponseModelo> createPersona(@Header("Authorization") String
  token,@Body() PersonaModelo persona);
  @DELETE("/api/persona/{id}")
  Future<ResponseModelo> deletePersona(@Header("Authorization") String token,
      @Path("id") int id);
  @PATCH("/api/persona/{id}")
  Future<ResponseModelo> updatePersona(@Header("Authorization") String
  token,@Path("id") int id, @Body() PersonaModelo persona);
}