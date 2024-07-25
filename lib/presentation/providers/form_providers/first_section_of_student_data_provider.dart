import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:tutorados_app/inputs/inputs.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class FistSectionStudentDataState {
  final Input name;
  final Input lastName;
  final Input studentEnrollment;
  final Input gender;
  final Input career;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;
  final String message;
  final bool isCompleted;

  FistSectionStudentDataState({
    this.name = const Input.pure(),
    this.lastName = const Input.pure(),
    this.studentEnrollment = const Input.pure(),
    this.gender = const Input.dirty('Masculino'),
    this.career = const Input.dirty('Software'),
    this.isValid = false,
    this.isFormPosted = false,
    this.isPosting = false,
    this.message = '',
    this.isCompleted = false,
  });

  FistSectionStudentDataState copyWith({
    Input? name,
    Input? lastName,
    Input? studentEnrollment,
    Input? gender,
    Input? career,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
    String? message,
    bool? isCompleted,
  }) =>
      FistSectionStudentDataState(
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        studentEnrollment: studentEnrollment ?? this.studentEnrollment,
        gender: gender ?? this.gender,
        career: career ?? this.career,
        isValid: isValid ?? this.isValid,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isPosting: isPosting ?? this.isPosting,
        message: message ?? this.message,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class FistSectionStudentDataNotifier
    extends StateNotifier<FistSectionStudentDataState> {
  final AuthState userData;

  FistSectionStudentDataNotifier({required this.userData})
      : super(FistSectionStudentDataState(
          name: Input.dirty(userData.user!.name),
          lastName: Input.dirty(userData.user!.lastName),
          studentEnrollment: Input.dirty(userData.user!.id),
        ));

  onNameChanged(String value) {
    final newName = Input.dirty(value);
    state = state.copyWith(name: newName);
  }

  onLastNameChanged(String value) {
    final newLastName = Input.dirty(value);
    state = state.copyWith(lastName: newLastName);
  }

  onStudentEnrollmentChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(studentEnrollment: newValue);
  }

  onGenderChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(gender: newValue);
  }

  onCareerChanged(String value) {
    final newCareer = Input.dirty(value);
    state = state.copyWith(career: newCareer);
  }

  onFormSubmit() {
    _touchEveryField();
    if (!state.isValid) return;
  }

  _touchEveryField() {
    final name = Input.dirty(state.name.value);
    final lastName = Input.dirty(state.lastName.value);
    final studentEnrollment = Input.dirty(state.studentEnrollment.value);

    state = state.copyWith(
        isFormPosted: true,
        name: name,
        lastName: lastName,
        studentEnrollment: studentEnrollment,
        isValid: Formz.validate([name, lastName, studentEnrollment]));
  }
}

final firstStudentDataProvider = StateNotifierProvider<
    FistSectionStudentDataNotifier, FistSectionStudentDataState>((ref) {
  final userData = ref.watch(authProvider);

  return FistSectionStudentDataNotifier(userData: userData);
});
