import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/form/form_error.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/inputs/inputs.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

enum CodeStatus { checking, valid, notValid }

class CodeState {
  final Input code;
  final CodeStatus codeStatus;
  final bool isCodeEntered;
  final bool isCodePosted;
  final String message;
  final bool isCodePosting;
  final Tutor? tutor;

  CodeState(
      {this.code = const Input.pure(),
      this.codeStatus = CodeStatus.checking,
      this.isCodeEntered = false,
      this.isCodePosted = false,
      this.message = '',
      this.isCodePosting = false,
      this.tutor});

  CodeState copyWith({
    Input? code,
    bool? isCodeEntered,
    CodeStatus? codeStatus,
    bool? isCodePosted,
    String? message,
    bool? isCodePosting,
    Tutor? tutor,
  }) =>
      CodeState(
        code: code ?? this.code,
        isCodeEntered: isCodeEntered ?? this.isCodeEntered,
        codeStatus: codeStatus ?? this.codeStatus,
        isCodePosted: isCodePosted ?? this.isCodePosted,
        message: message ?? this.message,
        isCodePosting: isCodePosting ?? this.isCodePosting,
        tutor: tutor ?? this.tutor,
      );
}

class CodeNotifier extends StateNotifier<CodeState> {
  final FormStudent formStudent;

  CodeNotifier({required this.formStudent}) : super(CodeState());

  onCodeChanged(String value) {
    final newCode = Input.dirty(value);
    state =
        state.copyWith(code: newCode, isCodeEntered: Formz.validate([newCode]));
  }

  onCodeSubmit() async {
    _touchCode();
    if (!state.isCodeEntered) return;
    state = state.copyWith(isCodePosting: true);
    await verifyTutor(state.code.value);
    state = state.copyWith(isCodePosting: false);
  }

  _touchCode() {
    final code = Input.dirty(state.code.value);
    state = state.copyWith(
        isCodePosted: true, code: code, isCodeEntered: Formz.validate([code]));
  }

  Future<void> verifyTutor(String code) async {
    try {
      final tutor = await formStudent.verifyTutor(code);
      _setTutor(tutor);
    } on FormError catch (error) {
      tutorNotValid(error.message);
    }
    state = state.copyWith(message: '');
  }

  _setTutor(Tutor tutor) async {
    state = state.copyWith(
      tutor: tutor,
      codeStatus: CodeStatus.valid,
    );
  }

  tutorNotValid([String? message]) {
    state = state.copyWith(
      codeStatus: CodeStatus.notValid,
      isCodeEntered: false,
      isCodePosted: false,
      isCodePosting: false,
      code: const Input.dirty(''),
      message: message,
      tutor: null,
    );
  }
}

final codeProvider = StateNotifierProvider<CodeNotifier, CodeState>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);
  return CodeNotifier(formStudent: formStudent);
});
