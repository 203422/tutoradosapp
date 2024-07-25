import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/presentation/providers/auth_providers/auth_provider.dart';

class AcademicDataState {
  final String highSchool;
  final double average;
  final double scoreCeneval;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;
  final String messageAverage;
  final String messageScore;
  final String messageHighSchool;
  final bool isCompleted;

  AcademicDataState(
      {this.highSchool = '',
      this.average = 0.0,
      this.scoreCeneval = 0.0,
      this.isValid = false,
      this.isFormPosted = false,
      this.isPosting = false,
      this.messageAverage = '',
      this.messageScore = '',
      this.messageHighSchool = '',
      this.isCompleted = false});

  AcademicDataState copyWith({
    String? highSchool,
    double? average,
    double? scoreCeneval,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
    String? messageAverage,
    String? messageScore,
    String? messageHighSchool,
    bool? isCompleted,
  }) =>
      AcademicDataState(
          highSchool: highSchool ?? this.highSchool,
          average: average ?? this.average,
          scoreCeneval: scoreCeneval ?? this.scoreCeneval,
          isValid: isValid ?? this.isValid,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isPosting: isPosting ?? this.isPosting,
          messageAverage: messageAverage ?? this.messageAverage,
          messageScore: messageScore ?? this.messageScore,
          messageHighSchool: messageHighSchool ?? this.messageHighSchool,
          isCompleted: isCompleted ?? this.isCompleted);
}

class AcademicDataNotifier extends StateNotifier<AcademicDataState> {
  final AuthState userData;
  final FormStudent formStudent;
  AcademicDataNotifier({required this.userData, required this.formStudent})
      : super(AcademicDataState());

  onHighSchoolChanged(String value) {
    state = state.copyWith(highSchool: value, messageHighSchool: '');
  }

  onAverageChanged(String value) {
    try {
      final newValue = double.parse(value);
      state = state.copyWith(average: newValue, messageAverage: '');
    } catch (e) {
      state = state.copyWith(messageAverage: 'Solo se aceptan números');
    }
  }

  onScoreCeneval(String value) {
    try {
      final newValue = double.parse(value);
      state = state.copyWith(scoreCeneval: newValue, messageScore: '');
    } catch (e) {
      state = state.copyWith(messageScore: 'Solo se aceptan números');
    }
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    sendData();
    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final highShool = state.highSchool;
    final average = state.average;
    final scoreCeneval = state.scoreCeneval;

    if (highShool.isEmpty) {
      state = state.copyWith(messageHighSchool: 'El campo es requerido');
    }

    if (average == 0.0) {
      state = state.copyWith(messageAverage: 'El campo es requerido');
    }

    if (scoreCeneval == 0.0) {
      state = state.copyWith(messageScore: 'El campo es requerido');
    }

    if (average != 0.0 && scoreCeneval != 0.0 && highShool.isNotEmpty) {
      state = state.copyWith(
          isFormPosted: true,
          highSchool: highShool,
          average: average,
          scoreCeneval: scoreCeneval,
          isValid: true);
    }
  }

  sendData() async {
    try {
      await formStudent.saveAcademicData(userData.user!.id, state.highSchool,
          state.average, state.scoreCeneval);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }
}

final academicDataProvider =
    StateNotifierProvider<AcademicDataNotifier, AcademicDataState>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);
  return AcademicDataNotifier(userData: userData, formStudent: formStudent);
});
