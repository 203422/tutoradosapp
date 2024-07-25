import 'package:dio/dio.dart';
import 'package:tutorados_app/auth/auth_error.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/mappers/mappers.dart';

import '../entities/entities.dart';

class AuthUser {
  final dio = Dio(BaseOptions(
    baseUrl: Environment.apiUrl,
  ));

  Future<String> register(String name, String lastName,
      String studentEnrollment, String email, String password) async {
    try {
      final response = await dio.post('/user/register', data: {
        'name': name,
        'lastName': lastName,
        'code': studentEnrollment,
        'email': email,
        'password': password,
      });

      final userRegistred = response.data['message'];
      return userRegistred;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw AuthError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 401) {
        throw AuthError(
            error.response?.data['message'] ?? 'El usuario ya está registrado');
      }

      if (error.response?.statusCode == 500) {
        throw AuthError(
            error.response?.data['message'] ?? 'Error al crear el usuario');
      }

      if (error.type == DioExceptionType.connectionError) {
        throw AuthError('Revisa tu conexión a internet');
      }
      throw AuthError('Algo malo pasó');
    } catch (error) {
      throw AuthError('Algo malo pasó');
    }
  }

  Future<User> login(String identifier, String password) async {
    try {
      final response = await dio.post('/user/login', data: {
        'identifier': identifier,
        'password': password,
      });

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw AuthError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 401) {
        throw AuthError(
            error.response?.data['message'] ?? 'Credenciales incorrectas');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw AuthError('Revisa tu conexión a internet');
      }
      throw AuthError('Algo malo pasó');
    } catch (e) {
      throw AuthError('Algo malo pasó');
    }
  }

  Future<User> checkAuthStatus(String token) async {
    try {
      final response = await dio.get('/user/',
          options: Options(headers: {'Authorization': 'Bearer $token'}));

      final user = UserMapper.userJsonToEntity(response.data);
      return user;
    } on DioException catch (error) {
      if (error.response?.statusCode == 401) {
        throw AuthError(error.response?.data['message'] ?? 'No valido');
      }
      throw Exception();
    } catch (error) {
      throw Exception();
    }
  }
}
