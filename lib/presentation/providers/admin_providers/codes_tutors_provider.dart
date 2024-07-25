import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/admin/admin_data.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

class CodesState {
  final bool isLoading;
  final String message;
  final List codes;

  CodesState(
      {this.isLoading = false, this.message = '', this.codes = const []});

  CodesState copyWith({
    bool? isLoading,
    String? message,
    List? codes,
  }) =>
      CodesState(
        isLoading: isLoading ?? this.isLoading,
        message: message ?? this.message,
        codes: codes ?? this.codes,
      );
}

class CodesNotifier extends StateNotifier<CodesState> {
  final AuthState userData;
  final AdminData adminData;
  CodesNotifier({required this.userData, required this.adminData})
      : super(CodesState()) {
    loadCodes();
  }

  Future loadCodes() async {
    try {
      final codes = await adminData.getCodes();
      if (codes.isEmpty) {
        state = state.copyWith(
            message: 'No hay códigos generados', isLoading: false);
        return;
      }
      state = state.copyWith(codes: codes);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
      );
    }
  }
}

final codesProvider =
    StateNotifierProvider.autoDispose<CodesNotifier, CodesState>((ref) {
  final userData = ref.watch(authProvider);
  final accessToken = ref.watch(authProvider).user?.token ?? '';
  final adminData = AdminData(accessToken: accessToken);
  return CodesNotifier(userData: userData, adminData: adminData);
});
