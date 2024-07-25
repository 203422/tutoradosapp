import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/tutor/tutor_data.dart';

class TutoredState {
  final List students;
  final bool isLoading;
  final int limit;
  final int offset;
  final bool isLastPage;
  final String message;

  TutoredState(
      {this.students = const [],
      this.isLoading = false,
      this.offset = 0,
      this.limit = 10,
      this.isLastPage = false,
      this.message = ''});

  TutoredState copyWith({
    List? students,
    bool? isLoading,
    int? limit,
    int? offset,
    bool? isLastPage,
    String? message,
  }) =>
      TutoredState(
          students: students ?? this.students,
          isLoading: isLoading ?? this.isLoading,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset,
          isLastPage: isLastPage ?? this.isLastPage,
          message: message ?? this.message);
}

class TutoredNotifier extends StateNotifier<TutoredState> {
  final AuthState userData;
  final TutorData tutorData;
  TutoredNotifier({required this.userData, required this.tutorData})
      : super(TutoredState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    try {
      final students = await tutorData.getAllStudents(
          userData.user!.id, state.limit, state.offset);

      if (students.isEmpty) {
        state = state.copyWith(
            isLoading: false,
            isLastPage: true,
            message: 'No hay alumnos registrados');
        return;
      }
      state = state.copyWith(
          isLastPage: false,
          isLoading: false,
          offset: state.offset + 10,
          students: [...state.students, ...students]);
          
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
    }
  }
}

final tutoredProvider =
    StateNotifierProvider.autoDispose<TutoredNotifier, TutoredState>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final tutorData = TutorData(accessToken: accessToken);
  return TutoredNotifier(userData: userData, tutorData: tutorData);
});
