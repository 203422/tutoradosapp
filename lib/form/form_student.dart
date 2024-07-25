import 'dart:io';

import 'package:dio/dio.dart';
import 'package:tutorados_app/config/config.dart';
import 'package:tutorados_app/form/form_error.dart';
import 'package:tutorados_app/mappers/mappers.dart';
import 'package:path_provider/path_provider.dart';

class FormStudent {
  late final Dio dio;
  final String accessToken;

  FormStudent({required this.accessToken})
      : dio = Dio(BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {'Authorization': 'Bearer $accessToken'}));

  Future verifyTutor(String id) async {
    try {
      final response = await dio.get('/student/verify/tutor/$id');
      final tutor = TutorMapper.userJsonToEntity(response.data);
      return tutor;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 404) {
        throw FormError(
            error.response?.data['message'] ?? 'No se encontró el tutor');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo malo pasó');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future studentData(
      String name,
      String lastName,
      String studentEnrollment,
      String career,
      String gender,
      String tutorOrParent,
      String birthDate,
      int age,
      String placeOfBirth,
      String religion,
      String activity) async {
    try {
      final response = await dio.post('/student/save-data', data: {
        "userId": studentEnrollment,
        "name": name,
        "lastName": lastName,
        "career": career,
        "gender": gender,
        "tutorOrParent": tutorOrParent,
        "birthdate": birthDate,
        "age": age,
        "placeOfBirth": placeOfBirth,
        "religion": religion,
        "activity": activity
      });
      final dataSaved = response.data;
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future assignTutor(String studentEnrollment, String tutorId) async {
    try {
      final response = await dio.post('/student/assign-tutor',
          data: {"tutorCode": tutorId, "studentEnrollment": studentEnrollment});

      final assignedTutor = response.data;
      return assignedTutor;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future saveContactData(
      String studentEnrollment,
      String currentAddress,
      String homeAddress,
      String cellPhoneNumber,
      String homePhoneNumber,
      String email,
      String tutorsEmail) async {
    try {
      final response = await dio.post('/student/contact-data', data: {
        "userId": studentEnrollment,
        "currentAddress": currentAddress,
        "homeAddress": homeAddress,
        "cellPhoneNumber": cellPhoneNumber,
        "homePhoneNumber": homePhoneNumber,
        "email": email,
        "tutorsEmail": tutorsEmail
      });

      final dataSaved = response.data;
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future saveMedicalData(
      String studentEnrollment,
      String socialSecurityNumber,
      String bloodType,
      String disease,
      String disability,
      String allergy,
      String sustances) async {
    try {
      final response = await dio.post('/student//medical-data', data: {
        "userId": studentEnrollment,
        "socialSecurityNumber": socialSecurityNumber,
        "bloodType": bloodType,
        "disease": disease,
        "disability": disability,
        "allergy": allergy,
        "sustances": sustances,
      });
      final dataSaved = response.data;
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future saveAcademicData(String studentEnrollment, String highSchool,
      double average, double scoreCeneval) async {
    try {
      final response = await dio.post('/student/academic-data', data: {
        "userId": studentEnrollment,
        "highSchool": highSchool,
        "average": average,
        "scoreCeneval": scoreCeneval
      });
      final dataSaved = response.data;
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future savesocioEconomicData(String studentEnrollment, String workplace,
      String economicalSupport, String livesWith) async {
    try {
      final response = await dio.post('/student/socioeconomic-data', data: {
        "userId": studentEnrollment,
        "workplace": workplace,
        "economicalSupport": economicalSupport,
        "livesWith": livesWith,
      });
      final saveData = response.data;
      return saveData;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future checkFormProgress(String studentId) async {
    try {
      final response = await dio.get('/student/form/progress/$studentId');
      final section = response.data['lastSectionCompleted'];
      return section;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future saveImage(String filePath, String studentId) async {
    try {
      final FormData data = FormData.fromMap(
          {'profileImg': MultipartFile.fromFileSync(filePath)});

      final response = await dio.post('/student/image/$studentId', data: data);
      final image = response.data;
      return image;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
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
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future updateContactData(
      String studentEnrollment,
      String currentAddress,
      String homeAddress,
      String cellPhoneNumber,
      String homePhoneNumber,
      String tutorsEmail) async {
    try {
      final response = await dio.put('/student/update-contact-data', data: {
        "userId": studentEnrollment,
        "currentAddress": currentAddress,
        "homeAddress": homeAddress,
        "cellPhoneNumber": cellPhoneNumber,
        "homePhoneNumber": homePhoneNumber,
        "tutorsEmail": tutorsEmail
      });

      final dataSaved = response.data;
      print(dataSaved);
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future updateProfileInfo(
    String studentEnrollment,
    String name,
    String lastName,
    String email,
  ) async {
    try {
      final response = await dio.put('/student/update-user-data', data: {
        "userId": studentEnrollment,
        "name": name,
        "lastName": lastName,
        "email": email,
      });

      final dataSaved = response.data['message'];
      print(dataSaved);
      return dataSaved;
    } on DioException catch (error) {
      if (error.response?.statusCode == 400) {
        throw FormError(error.response?.data['message'] ??
            'Todos los campos son requeridos');
      }
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }

  Future getStudent(String studentId) async {
    try {
      final response = await dio.get('/tutor/students/$studentId');
      final student = StudentMapper.studentJsonToEntity(response.data);
      return student;
    } on DioException catch (error) {
      if (error.response?.statusCode == 500) {
        throw FormError(
            error.response?.data['message'] ?? 'Se ha producido un error');
      }
      if (error.type == DioExceptionType.connectionError) {
        throw FormError('Revisa tu conexión a internet');
      }
      throw FormError('Algo no salió bien');
    } catch (error) {
      throw FormError('Algo malo pasó');
    }
  }
}
