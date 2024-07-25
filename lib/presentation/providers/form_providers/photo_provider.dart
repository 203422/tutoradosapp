import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class PhotoState {
  final String image;
  final bool isCompleted;
  final bool isPosting;

  PhotoState(
      {this.image = '', this.isCompleted = false, this.isPosting = false});

  PhotoState copyWith({
    String? image,
    bool? isCompleted,
    bool? isPosting,
  }) =>
      PhotoState(
          image: image ?? this.image,
          isCompleted: isCompleted ?? this.isCompleted,
          isPosting: isPosting ?? this.isPosting);
}

class PhotoNotifier extends StateNotifier<PhotoState> {
  final AuthState userData;
  final CodeState codeState;
  final FormStudent formStudent;
  PhotoNotifier(
      {required this.formStudent,
      required this.userData,
      required this.codeState})
      : super(PhotoState());

  onImageChanged(String path) {
    state = state.copyWith(image: path);
  }

  onFormSubmit() async {
    state = state.copyWith(isPosting: true);
    await sendPhoto();
    await assignTutor();
    state = state.copyWith(isPosting: false);
  }

  sendPhoto() async {
    try {
      await formStudent.saveImage(state.image, userData.user!.id);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }

  assignTutor() async {
    try {
      await formStudent.assignTutor(userData.user!.id, codeState.tutor!.id);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }
}

final photoProvider = StateNotifierProvider<PhotoNotifier, PhotoState>((ref) {
  final userData = ref.watch(authProvider);
  final codeState = ref.watch(codeProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final FormStudent formStudent = FormStudent(accessToken: accessToken);
  return PhotoNotifier(
      formStudent: formStudent, userData: userData, codeState: codeState);
});
