import 'dart:io';
import 'package:dio/dio.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/mappers/mappers.dart';
import 'package:tutorados_app/tutor/tutor_error.dart';
import 'package:path_provider/path_provider.dart';

class TutorData {
  late final Dio dio;
  final String accessToken;

  TutorData({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future getAllStudents(String tutorId, int limit, int offset) async {
    try {
      final response =
          await dio.get('/tutor/$tutorId/students?limit=$limit&offset=$offset');
      final students = [];
      for (final student in response.data ?? []) {
        students.add(student);
      }
      return students;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw TutorError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw TutorError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw TutorError('Revisa tu conexión a internet');
      }
      throw TutorError('Algo no salió bien');
    } catch (error) {
      throw TutorError('Algo malo pasó');
    }
  }

  Future getStudent(String studentId) async {
    try {
      final response = await dio.get('/tutor/students/$studentId');
      final student = StudentMapper.studentJsonToEntity(response.data);
      return student;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw TutorError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw TutorError('Revisa tu conexión a internet');
      }
      throw TutorError('Algo no salió bien');
    } catch (error) {
      throw TutorError('Algo malo pasó');
    }
  }

  Future searchStudent(String query, String id) async {
    final response =
        await dio.get('/tutor/$id/search/student', queryParameters: {
      'query': query,
    });

    final students = response.data;
    return students;
  }

  Future downloadFile(String studentId, String typeFile) async {
    try {
      final response = await dio.get('/files/student/$studentId/$typeFile',
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));

      final bytes = response.data;
      final directory = await getExternalStorageDirectory();
      final filePath = '${directory!.path}/$studentId.$typeFile';

      File file = File(filePath);
      await file.writeAsBytes(bytes);

      return file;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw TutorError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw TutorError('Revisa tu conexión a internet');
      }
      throw TutorError('Algo no salió bien');
    } catch (error) {
      throw TutorError('Algo malo pasó');
    }
  }

  Future deleteStudent(String studentId) async {
    try {
      final response = await dio.delete('/student/$studentId');
      final studentDeleted = response.data['message'];
      return studentDeleted;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw TutorError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw TutorError('Revisa tu conexión a internet');
      }
      throw TutorError('Algo no salió bien');
    } catch (error) {
      throw TutorError('Algo malo pasó');
    }
  }
}
