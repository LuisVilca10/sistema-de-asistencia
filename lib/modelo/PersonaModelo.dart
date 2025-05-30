import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class PersonaModelo {
  int? id = 0;
  String? dni, nombre, correo;

  PersonaModelo({this.id, this.dni, this.nombre, this.correo});

  factory PersonaModelo.fromJson(Map<String, dynamic> map) {
    return PersonaModelo(
      id: map['id'] as int,
      dni: map['dni'],
      nombre: map['nombre'],
      correo: map['correo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'dni': dni, 'nombre': nombre, 'correo': correo};
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map["id"] = id;
    map["dni"] = dni;
    map["nombre"] = nombre;
    map["correo"] = correo;
    /* if (id != null) {
      map["id"] = id;
    }*/
    return map;
  }

  PersonaModelo.fromObject(dynamic o) {
    this.id = o["id"];
    this.dni = o["dni"];
    this.nombre = o["nombre"];
    this.correo = o["correo"];
  }

  @override
  String toString() {
    return 'PersonaModelo{id: $id,dni: $dni, nombre: $nombre, correo:$correo}';
  }
}

@JsonSerializable()
class ResponseModelo {
  bool? success;
  List<PersonaModelo>? data;
  String? message;

  ResponseModelo({this.success, this.data, this.message});

  factory ResponseModelo.fromJson(Map<String, dynamic> map) {
    return ResponseModelo(
      success: map['success'] as bool,
      data:
          (map['data'] as List<dynamic>)
              .map((e) => PersonaModelo.fromJson(e as Map<String, dynamic>))
              .toList()
              .toList(),
      message: map['message'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'success': success, 'data': data, 'message': message};
  }
}

@JsonSerializable()
class MsgModelo {
  String? mensaje;

  MsgModelo({this.mensaje});

  factory MsgModelo.fromJson(Map<String, dynamic> map) {
    return MsgModelo(mensaje: map['mensaje']);
  }
  Map<String, dynamic> toJson() {
    return {'mensaje': mensaje};
  }
}
