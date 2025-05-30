import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class EventoModelo {
  EventoModelo({
    required this.id,
    required this.nombreEvento,
  });

  EventoModelo.unlaunched();

  late int id = 0;
  late final String nombreEvento;

  EventoModelo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nombreEvento = json['nombreEvento'];
  }

  factory EventoModelo.fromJsonModelo(Map<String, dynamic> json) {
    return EventoModelo(
      id: json['id'],
      nombreEvento: json['nombreEvento'],
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['nombreEvento'] = nombreEvento;
    return _data;
  }
}
