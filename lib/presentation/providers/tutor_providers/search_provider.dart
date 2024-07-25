import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';
import 'package:tutorados_app/tutor/tutor_data.dart';

class Search {}

class SearchNotifier extends StateNotifier<Search> {
  final TutorData tutorData;
  final AuthState userData;
  SearchNotifier({required this.tutorData, required this.userData})
      : super(Search());

  Future<List> searchStudents(String query) async {
    if (query.isEmpty) return [];
    final students = await tutorData.searchStudent(query, userData.user!.id);
    return students;
  }
}

final searchStudentProvider =
    StateNotifierProvider<SearchNotifier, Search>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final TutorData tutorData = TutorData(accessToken: accessToken);
  return SearchNotifier(tutorData: tutorData, userData: userData);
});
