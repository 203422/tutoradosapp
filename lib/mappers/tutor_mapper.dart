import 'package:tutorados_app/entities/entities.dart';

class TutorMapper {
  static Tutor userJsonToEntity(Map<String, dynamic> json) => Tutor(
        id: json['usuario_id'],
        name: json['nombre'],
        lastName: json['apellido'],
        email: json['correo'],
        role: json['rol'],
      );
}
