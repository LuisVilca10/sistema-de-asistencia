import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class GenericModelo {
  GenericModelo({
    required this.deleted,
  });
  late final bool deleted;

  GenericModelo.fromJson(Map<String, dynamic> json){
    deleted = json['deleted'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['deleted'] = deleted;
    return _data;
  }
}