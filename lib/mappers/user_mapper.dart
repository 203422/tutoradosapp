import 'package:tutorados_app/entities/entities.dart';

class UserMapper {
  static User userJsonToEntity(Map<String, dynamic> json ) => 
  
  User(
    id: json['usuario_id'], 
    name: json['nombre'], 
    lastName: json['apellido'], 
    email: json['correo'], 
    role: json['rol'], 
    token: json['token']
    );
}