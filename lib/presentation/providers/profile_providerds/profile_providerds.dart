import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class ProfileFormState {
  final String id;
  final Student? student;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final String name;
  final String lastName;
  final String email;
  final String cellPhoneNumber;
  final String homePhoneNumber;
  final String tutorsEmail;
  final String currentAddress;
  final String homeAddress;
  final String message;
  final bool isLoading;

  ProfileFormState(
      {this.id = '',
      this.student,
      this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.name = '',
      this.lastName = '',
      this.email = '',
      this.cellPhoneNumber = '',
      this.homePhoneNumber = '',
      this.tutorsEmail = '',
      this.currentAddress = '',
      this.homeAddress = '',
      this.message = '',
      this.isLoading = true});

  ProfileFormState copyWith({
    String? id,
    Student? student,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    String? name,
    String? lastName,
    String? email,
    String? cellPhoneNumber,
    String? homePhoneNumber,
    String? tutorsEmail,
    String? currentAddress,
    String? homeAddress,
    String? message,
    bool? isLoading,
  }) =>
      ProfileFormState(
        id: id ?? this.id,
        student: student ?? this.student,
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        email: email ?? this.email,
        cellPhoneNumber: cellPhoneNumber ?? this.cellPhoneNumber,
        homePhoneNumber: homePhoneNumber ?? this.homePhoneNumber,
        tutorsEmail: tutorsEmail ?? this.tutorsEmail,
        currentAddress: currentAddress ?? this.currentAddress,
        homeAddress: homeAddress ?? this.homeAddress,
        message: message ?? this.message,
        isLoading: isLoading ?? this.isLoading,
      );
}

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  final AuthState userData;
  final FormStudent formStudent;
  final String id;
  ProfileFormNotifier(
      {required this.userData, required this.formStudent, required this.id})
      : super(ProfileFormState(id: id)) {
    getStudent();
  }

  void onNameChanged(String value) {
    state = state.copyWith(
      name: value,
    );
  }

  void onLastNameChanged(String value) {
    state = state.copyWith(
      lastName: value,
    );
  }

  void onEmailChanged(String value) {
    state = state.copyWith(
      email: value,
    );
  }

  void onCellPhoneNumberChanged(String value) {
    state = state.copyWith(
      cellPhoneNumber: value,
    );
  }

  void onHomePhoneNumberChanged(String value) {
    state = state.copyWith(
      homePhoneNumber: value,
    );
  }

  void onTutorsEmailChanged(String value) {
    state = state.copyWith(
      tutorsEmail: value,
    );
  }

  void onCurrentAddressChanged(String value) {
    state = state.copyWith(
      currentAddress: value,
    );
  }

  void onHomeAddressChanged(String value) {
    state = state.copyWith(
      homeAddress: value,
    );
  }

  Future<void> getStudent() async {
    print('se ejecuto');
    try {
      final student = await formStudent.getStudent(id);
      state = state.copyWith(
        student: student,
        name: student.name,
        lastName: student.lastName,
        email: student.email,
        cellPhoneNumber: student.cellPhoneNumber,
        homePhoneNumber: student.homePhoneNumber,
        tutorsEmail: student.tutorsEmail,
        currentAddress: student.currentAddress,
        homeAddress: student.homeAddress,
        isLoading: false,
      );
      print(student);
    } catch (error) {
      state = state.copyWith(isLoading: false);
      throw Exception();
    }
  }

  onPrifileUpdate() async {
    try {
      state = state.copyWith(isPosting: true);
      final dataUpdated = await formStudent.updateProfileInfo(
          userData.user!.id, state.name, state.lastName, state.email);
    } catch (e) {}
  }

  onContactDataSubmit() async {
    try {
      state = state.copyWith(isPosting: true);
      final dataUpdated = await formStudent.updateContactData(
          userData.user!.id,
          state.currentAddress,
          state.homeAddress,
          state.cellPhoneNumber,
          state.homePhoneNumber,
          state.tutorsEmail);
      state = state.copyWith(
          isPosting: false,
          message: 'Datos actualizados',
          currentAddress: dataUpdated['domicilio_actual'],
          homeAddress: dataUpdated['domicilio_familiar'],
          cellPhoneNumber: dataUpdated['celular'],
          homePhoneNumber: dataUpdated['tel_casa'],
          tutorsEmail: dataUpdated['correo_tutor']);
    } catch (e) {}
    Future.delayed(const Duration(seconds: 3), () {
      state = state.copyWith(message: '');
    });
  }
}

final profileFormProvider =
    StateNotifierProvider.family<ProfileFormNotifier, ProfileFormState, String>(
        (ref, studentId) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);

  return ProfileFormNotifier(
      userData: userData, formStudent: formStudent, id: studentId);
});
