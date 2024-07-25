import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:tutorados_app/inputs/inputs.dart';
import 'package:tutorados_app/presentation/providers/auth_providers/auth_provider.dart';

class RegisterFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Name name;
  final LastName lastName;
  final Input studentEnrollment;
  final Email email;
  final Password password;
  final bool userRegistred;

  RegisterFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.name = const Name.pure(),
    this.lastName = const LastName.pure(),
    this.studentEnrollment = const Input.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.userRegistred = false,
  });

  RegisterFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Name? name,
    LastName? lastName,
    Input? studentEnrollment,
    Email? email,
    Password? password,
    bool? userRegistred,
  }) =>
      RegisterFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        name: name ?? this.name,
        lastName: lastName ?? this.lastName,
        studentEnrollment: studentEnrollment ?? this.studentEnrollment,
        email: email ?? this.email,
        password: password ?? this.password,
        userRegistred: userRegistred ?? this.userRegistred,
      );
}

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String, String, String, String) registerCallback;

  RegisterFormNotifier({required this.registerCallback})
      : super(RegisterFormState());

  onNameChange(String value) {
    final newName = Name.dirty(value);
    state = state.copyWith(
        name: newName,
        isValid: Formz.validate([
          newName,
          state.lastName,
          state.studentEnrollment,
          state.email,
          state.password
        ]));
  }

  onLastNameChange(String value) {
    final newLastName = LastName.dirty(value);
    state = state.copyWith(
        lastName: newLastName,
        isValid: Formz.validate([
          newLastName,
          state.name,
          state.studentEnrollment,
          state.email,
          state.password
        ]));
  }

  onStudentEnrollmentChanged(String value) {
    final newValue = Input.dirty(value);
    state = state.copyWith(
        studentEnrollment: newValue,
        isValid: Formz.validate([
          newValue,
          state.name,
          state.lastName,
          state.email,
          state.password
        ]));
  }

  onEmailChange(String value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
        email: newEmail, isValid: Formz.validate([newEmail, state.password]));
  }

  onPasswordChange(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
        password: newPassword,
        isValid: Formz.validate([newPassword, state.email]));
  }

  onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await registerCallback(state.name.value, state.lastName.value,
        state.studentEnrollment.value, state.email.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final name = Name.dirty(state.name.value);
    final studentEnrollment = Input.dirty(state.studentEnrollment.value);
    final lastName = LastName.dirty(state.lastName.value);
    state = state.copyWith(
        isFormPosted: true,
        email: email,
        password: password,
        studentEnrollment: studentEnrollment,
        name: name,
        lastName: lastName,
        isValid: Formz.validate([email, password, name, lastName]));
  }
}

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final registerCallback = ref.watch(authProvider.notifier).registerUser;

  return RegisterFormNotifier(registerCallback: registerCallback);
});
