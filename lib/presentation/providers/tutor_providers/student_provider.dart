import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/tutor/tutor_data.dart';

class StudentState {
  final String id;
  final Student? student;
  final bool isLoading;
  final String pathFile;
  final bool isFileDownloaded;
  final bool pdfIsDownloading;
  final bool csvIsDownloading;
  final bool isStudentDeleted;
  final String message;

  StudentState(
      {this.id = '',
      this.student,
      this.isLoading = true,
      this.pathFile = '',
      this.isFileDownloaded = false,
      this.pdfIsDownloading = false,
      this.csvIsDownloading = false,
      this.isStudentDeleted = false,
      this.message = ''});

  StudentState copyWith({
    String? id,
    Student? student,
    bool? isLoading,
    String? pathFile,
    bool? isFileDownloaded,
    bool? pdfIsDownloading,
    bool? csvIsDownloading,
    bool? isStudentDeleted,
    String? message,
  }) =>
      StudentState(
          id: id ?? this.id,
          student: student ?? this.student,
          isLoading: isLoading ?? this.isLoading,
          pathFile: pathFile ?? this.pathFile,
          isFileDownloaded: isFileDownloaded ?? this.isFileDownloaded,
          pdfIsDownloading: pdfIsDownloading ?? this.pdfIsDownloading,
          csvIsDownloading: csvIsDownloading ?? this.csvIsDownloading,
          isStudentDeleted: isStudentDeleted ?? this.isStudentDeleted,
          message: message ?? this.message);
}

class StudentNotifier extends StateNotifier<StudentState> {
  final String id;
  final TutorData tutorData;
  StudentNotifier({required this.id, required this.tutorData})
      : super(StudentState(id: id)) {
    getStudent();
  }

  deleteStudent() async {
    try {
      final studentDeleted = await tutorData.deleteStudent(id);
      state = state.copyWith(message: studentDeleted, isStudentDeleted: true);
    } catch (error) {
      throw Exception();
    }
  }

  Future<void> getStudent() async {
    try {
      final student = await tutorData.getStudent(id);
      state = state.copyWith(
        student: student,
        isLoading: false,
      );
    } catch (error) {
      print(error);
      throw Exception();
    }
  }

  openFile() async {
    await OpenFile.open(state.pathFile);
  }

  getFile(String typeFile) async {
    if (typeFile == 'pdf') {
      state = state.copyWith(pdfIsDownloading: true);
    } else if (typeFile == 'csv') {
      state = state.copyWith(csvIsDownloading: true);
    }

    try {
      final file = await tutorData.downloadFile(id, typeFile);
      state = state.copyWith(pathFile: file.path, isFileDownloaded: true);
    } catch (e) {
      state = state.copyWith(
          csvIsDownloading: false,
          pdfIsDownloading: false,
          pathFile: '',
          isFileDownloaded: false);
    }
  }

  closeFileInfo() {
    state = state.copyWith(
        pdfIsDownloading: false,
        csvIsDownloading: false,
        pathFile: '',
        isFileDownloaded: false);
  }
}

final studentProvider = StateNotifierProvider.autoDispose
    .family<StudentNotifier, StudentState, String>((ref, studentId) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final tutorData = TutorData(accessToken: accessToken);
  return StudentNotifier(id: studentId, tutorData: tutorData);
});
