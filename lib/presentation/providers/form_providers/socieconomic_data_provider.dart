import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/form/form_student.dart';
import 'package:tutorados_app/presentation/providers/auth_providers/auth_provider.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class SocioeconomicDataState {
  final bool work;
  final String workplace;
  final bool economicalSupport;
  final String livesWith;
  final bool isFormPosted;
  final bool isPosting;
  final bool isCompleted;

  SocioeconomicDataState(
      {this.work = false,
      this.workplace = 'No',
      this.economicalSupport = false,
      this.livesWith = 'Solo',
      this.isFormPosted = false,
      this.isPosting = false,
      this.isCompleted = false});

  SocioeconomicDataState copyWith({
    bool? work,
    String? workplace,
    bool? economicalSupport,
    String? livesWith,
    bool? isFormPosted,
    bool? isPosting,
    bool? isCompleted,
  }) =>
      SocioeconomicDataState(
          work: work ?? this.work,
          workplace: workplace ?? this.workplace,
          economicalSupport: economicalSupport ?? this.economicalSupport,
          livesWith: livesWith ?? this.livesWith,
          isFormPosted: isFormPosted ?? this.isFormPosted,
          isPosting: isPosting ?? this.isPosting,
          isCompleted: isCompleted ?? this.isCompleted);
}

class SocioeconomicDataNotifier extends StateNotifier<SocioeconomicDataState> {
  final AuthState userData;
  final FormStudent formStudent;
  late TextEditingController anotherOption;
  SocioeconomicDataNotifier({
    required this.userData,
    required this.formStudent,
  }) : super(SocioeconomicDataState()) {
    anotherOption = TextEditingController();
  }

  onOptionWorkChanged(bool value) {
    state = state.copyWith(work: value);
  }

  onWorkplaceChanged(String value) {
    state = state.copyWith(workplace: value);
  }

  onEconomicalSupportOptionChanged(bool value) {
    state = state.copyWith(economicalSupport: value);
  }

  onLiveWithChanged(String value) {
    state = state.copyWith(livesWith: value);
    anotherOption.text = '';
  }

  onAnotherOption(String value) {
    state = state.copyWith(livesWith: value);
    anotherOption.text = value;
    if (anotherOption.text.isEmpty) {
      state = state.copyWith(livesWith: 'Solo');
    }
  }

  onFormSubmit() {
    state = state.copyWith(isPosting: true);
    sendData();
    state = state.copyWith(isPosting: false);
  }

  sendData() async {
    final String workplace = state.work ? state.workplace : 'No';
    final String economicalSupport = state.economicalSupport ? 'Si' : 'No';

    try {
      await formStudent.savesocioEconomicData(
          userData.user!.id, workplace, economicalSupport, state.livesWith);
      state = state.copyWith(isCompleted: true);
    } catch (e) {
      state = state.copyWith(isCompleted: false);
    }
  }
}

final socioeconomicDataProvider =
    StateNotifierProvider<SocioeconomicDataNotifier, SocioeconomicDataState>(
        (ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final formStudent = FormStudent(accessToken: accessToken);
  return SocioeconomicDataNotifier(
      userData: userData, formStudent: formStudent);
});
