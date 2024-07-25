import 'package:dio/dio.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/tutor/admin_error.dart';

class AdminData {
  late final Dio dio;
  final String accessToken;

  AdminData({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future registerTutor(String name, String lastName) async {
    try {
      final response = await dio.post('/admin/tutor/register', data: {
        "name": name,
        "lastName": lastName,
      });

      final tutorInfo = response.data;
      return tutorInfo;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw AdminError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 401) {
        throw AdminError(error.response?.data['message'] ?? 'Tutor existente');
      }
      if (error.response?.statusCode == 500) {
        throw AdminError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw AdminError('Revisa tu conexión a internet');
      }
      throw AdminError('Algo no salió bien');
    } catch (error) {
      throw AdminError('Algo malo pasó');
    }
  }

  Future getAllTutors(int limit, int offset) async {
    try {
      final response =
          await dio.get('/admin/tutors?limit=$limit&offset=$offset');
      final students = [];
      for (final student in response.data ?? []) {
        students.add(student);
      }
      return students;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw AdminError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw AdminError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw AdminError('Revisa tu conexión a internet');
      }
      throw AdminError('Algo no salió bien');
    } catch (error) {
      throw AdminError('Algo malo pasó');
    }
  }

  Future getCodes() async {
    try {
      final response = await dio.get('/admin/codes');
      return response.data;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw AdminError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw AdminError('Revisa tu conexión a internet');
      }
      throw AdminError('Algo no salió bien');
    } catch (error) {
      throw AdminError('Algo malo pasó');
    }
  }
}
