import 'package:flutter_application_1/modelo/EventoModelo.dart';
import 'package:flutter_application_1/modelo/GenericModelo.dart';
import 'package:flutter_application_1/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'evento_api.g.dart';

@RestApi(baseUrl: UrlApi.urlApix)
abstract class EventoApi {
  factory EventoApi(Dio dio, {String baseUrl}) = _EventoApi;

  static EventoApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return EventoApi(dio);
  }

  @GET("/envento/list")
  Future<List<EventoModelo>> getEvento(@Header("Authorization") String token);

  @POST("/finca/crear")
  Future<EventoModelo> crearEvento(
    @Header("Authorization") String token,
    @Body() EventoModelo finca,
  );

  @GET("/finca/buscar/{id}")
  Future<EventoModelo> findEvento(
    @Header("Authorization") String token,
    @Path("id") int id,
  );

  @DELETE("/finca/eliminar/{id}")
  Future<GenericModelo> deleteEvento(
    @Header("Authorization") String token,
    @Path("id") int id,
  );

  @PUT("/finca/editar/{id}")
  Future<EventoModelo> updateEvento(
    @Header("Authorization") String token,
    @Path("id") int id,
    @Body() EventoModelo finca,
  );
}
