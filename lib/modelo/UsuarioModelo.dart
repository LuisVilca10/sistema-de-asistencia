class UsuarioModelo {
  String? nombre, correo, dni;

  UsuarioModelo({
     this.nombre,
     this.correo,
     this.dni,
  });

  factory UsuarioModelo.fromJson(Map<String, dynamic> map) {
    return UsuarioModelo(
      nombre: map['nombre'],
      correo: map['correo'],
      dni: map['dni'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nombre': nombre, 'correo': correo, 'dni': dni};
  }
}

class TokenModelo {
  bool status;
  String message, access_token, token_type, expires_at;

  TokenModelo({
    required this.status,
    required this.message,
    required this.access_token,
    required this.token_type,
    required this.expires_at,
  });

  factory TokenModelo.fromJson(Map<String, dynamic> map) {
    return TokenModelo(
      status: map['status'] as bool,
      message: map['message'],
      access_token: map['access_token'],
      token_type: map['token_type'],
      expires_at: map['expires_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'access_token': access_token,
      'token_type': token_type,
      'expires_at': expires_at,
    };
  }
}
