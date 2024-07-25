import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:intl/intl.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/inputs/inputs.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class SecondStudentDataState {
  final Input birthDate;
  final Input placeOfBirth;
  final int age;
  final Input religion;
  final Input activity;
  final Input tutor;
  final bool isValid;
  final bool isFormPosted;
  final bool isPosting;
  final bool isCompleted;

  SecondStudentDataState(
      {this.birthDate = const Input.pure(),
      this.placeOfBirth = const Input.pure(),
      this.age = 0,
      this.religion = const Input.dirty('Ninguna'),
      this.activity = const Input.dirty('Ninguna'),
      this.tutor = const Input.pure(),
      this.isValid = false,
      this.isFormPosted = false,
      this.isPosting = false,
      this.isCompleted = false});

  SecondStudentDataState copyWith({
    Input? birthDate,
    Input? placeOfBirth,
    int? age,
    Input? religion,
    Input? activity,
    Input? tutor,
    bool? isValid,
    bool? isFormPosted,
    bool? isPosting,
    bool? isCompleted,
  }) =>
      SecondStudentDataState(
        birthDate: birthDate ?? this.birthDate,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        age: age ?? this.age,
        religion: religion ?? this.religion,
        activity: activity ?? this.activity,
        tutor: tutor ?? this.tutor,
        isValid: isValid ?? this.isValid,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isPosting: isPosting ?? this.isPosting,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

class SecondStudentDataNotifier extends StateNotifier<SecondStudentDataState> {
  late TextEditingController birthDateController;
  late TextEditingController ageController;
  final FistSectionStudentDataState firstSection;
  final FormStudent formStudent;

  SecondStudentDataNotifier({
    required this.firstSection,
    required this.formStudent,
  }) : super(SecondStudentDataState()) {
    birthDateController = TextEditingController();
    ageController = TextEditingController();
  }

  onBirthDateChanged(DateTime value) {
    final date = DateFormat('yyyy-MM-dd').format(value);
    final newValue = Input.dirty(date);
    state = state.copyWith(birthDate: newValue);
    birthDateController.text = date;
    final age = calculateAge(value);
    state = state.copyWith(age: age);
    ageController.text = age.toString();
  }

  onAgeChanged(String value) {
    int age = int.tryParse(value) ?? 0;
    state = state.copyWith(age: age);
    ageController.text = value;
  }

  calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate.year;

    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }

    return age;
  }

  onPlaceOfBirthChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(placeOfBirth: newValue);
  }

  onReligionChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(religion: newValue);
  }

  onActivityChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(activity: newValue);
  }

  onTutorChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(tutor: newValue);
  }

  onFormSubmit() {
    _touchEveryField();

    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    sendData();
    state = state.copyWith(isPosting: false);
  }

  sendData() async {
    try {
      await formStudent.studentData(
          firstSection.name.value,
          firstSection.lastName.value,
          firstSection.studentEnrollment.value,
          firstSection.career.value,
          firstSection.gender.value,
          state.tutor.value,
          state.birthDate.value,
          state.age,
          state.placeOfBirth.value,
          state.religion.value,
          state.activity.value);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }

  _touchEveryField() {
    final birthDate = Input.dirty(state.birthDate.value);
    final placeOfBirth = Input.dirty(state.placeOfBirth.value);
    final tutor = Input.dirty(state.tutor.value);

    state = state.copyWith(
      isFormPosted: true,
      birthDate: birthDate,
      placeOfBirth: placeOfBirth,
      tutor: tutor,
      isValid: Formz.validate([birthDate, placeOfBirth, tutor]),
    );
  }
}

final secondStudentDataProvider =
    StateNotifierProvider<SecondStudentDataNotifier, SecondStudentDataState>(
        (ref) {
  final firstSection = ref.watch(firstStudentDataProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);

  return SecondStudentDataNotifier(
    firstSection: firstSection,
    formStudent: formStudent,
  );
});
