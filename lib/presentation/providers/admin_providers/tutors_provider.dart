import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/admin/admin_data.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class TutorsState {
  final bool isLoading;
  final int limit;
  final int offset;
  final bool isLastPage;
  final String message;
  final List tutors;

  TutorsState(
      {this.isLoading = false,
      this.offset = 0,
      this.limit = 10,
      this.isLastPage = false,
      this.message = '',
      this.tutors = const []});

  TutorsState copyWith({
    bool? isLoading,
    int? limit,
    int? offset,
    bool? isLastPage,
    String? message,
    List? tutors,
  }) =>
      TutorsState(
          isLoading: isLoading ?? this.isLoading,
          limit: limit ?? this.limit,
          offset: offset ?? this.offset,
          isLastPage: isLastPage ?? this.isLastPage,
          message: message ?? this.message,
          tutors: tutors ?? this.tutors);
}

class TutorsNotifier extends StateNotifier<TutorsState> {
  final AuthState userData;
  final AdminData adminData;
  TutorsNotifier({required this.userData, required this.adminData})
      : super(TutorsState()) {
    loadNextPage();
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    try {
      final tutors = await adminData.getAllTutors(state.limit, state.offset);

      if (tutors.isEmpty) {
        state = state.copyWith(
            isLoading: false,
            isLastPage: true,
            message: 'No hay tutores registrados');
        return;
      }
      state = state.copyWith(
          isLastPage: false,
          isLoading: false,
          offset: state.offset + 10,
          tutors: [...state.tutors, ...tutors]);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        isLastPage: true,
      );
    }
  }
}

final tutorsProvider =
    StateNotifierProvider.autoDispose<TutorsNotifier, TutorsState>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final adminData = AdminData(accessToken: accessToken);
  return TutorsNotifier(userData: userData, adminData: adminData);
});
