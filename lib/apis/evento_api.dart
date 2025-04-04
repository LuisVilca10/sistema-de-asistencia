import 'package:flutter_application_1/modelo/EventoModelo.dart';
import 'package:flutter_application_1/modelo/GenericModelo.dart';
import 'package:flutter_application_1/util/UrlApi.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:retrofit/http.dart';

part 'evento_api.g.dart';
@RestApi(baseUrl: UrlApi.urlApix)
abstract class AsistenciaApi {
  factory AsistenciaApi(Dio dio, {String baseUrl}) = _AsistenciaApi;

  static AsistenciaApi create() {
    final dio = Dio();
    dio.interceptors.add(PrettyDioLogger());
    return AsistenciaApi(dio);
  }

  @GET("/envento/list")
  Future<List<AsistenciaModelo>> getAsistencia(@Header("Authorization") String token);

  // @POST("/finca/crear")
  // Future<AsistenciaModelo> crearFinca(@Header("Authorization") String token, @Body() AsistenciaModelo finca);

  // @GET("/finca/buscar/{id}")
  // Future<AsistenciaModelo> findFinca(@Header("Authorization") String token, @Path("id") int id);

  // @DELETE("/finca/eliminar/{id}")
  // Future<GenericModelo> deleteFinca(@Header("Authorization") String token, @Path("id") int id);

  // @PUT("/finca/editar/{id}")
  // Future<AsistenciaModelo> updateFinca(@Header("Authorization") String token, @Path("id") int id , @Body() AsistenciaModelo finca);
}