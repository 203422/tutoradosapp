import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/auth/auth_error.dart';
import 'package:tutorados_app/auth/auth_user.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/services/key_value_storage.dart';

enum AuthStatus { checking, authenticated, notAuthenticated, newUserRegistred }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String message;

  AuthState(
      {this.authStatus = AuthStatus.checking, this.user, this.message = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? message,
  }) =>
      AuthState(
        authStatus: authStatus ?? this.authStatus,
        user: user ?? this.user,
        message: message ?? this.message,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUser authUser;
  final KeyValueStorage keyValueStorage;

  AuthNotifier({required this.authUser, required this.keyValueStorage})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginUser(String identifier, String password) async {
    try {
      final user = await authUser.login(identifier, password);
      _setLoggedUser(user);
    } on AuthError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Algó malo pasó');
    }
  }

  void registerUser(String name, String lastName, String studentEnrollment,
      String email, String password) async {
    try {
      final userRegistred =
          await authUser.register(name, lastName, studentEnrollment,  email, password);
      state = state.copyWith(
          message: userRegistred, authStatus: AuthStatus.newUserRegistred);
    } on AuthError catch (error) {
      logout(error.message);
    } catch (error) {
      logout('Algo malo pasó');
    }
    state = state.copyWith(authStatus: AuthStatus.checking);
  }

  void checkAuthStatus() async {
    final token = await keyValueStorage.getValue<String>('token');

    if (token == null) return logout();

    try {
      final user = await authUser.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (error) {
      logout();
    }
  }

  _setLoggedUser(User user) async {
    await keyValueStorage.setValueKey('token', user.token);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      message: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorage.removeKey('token');

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        message: errorMessage);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authUser = AuthUser();
  final keyValueStorage = KeyValueStorage();

  return AuthNotifier(authUser: authUser, keyValueStorage: keyValueStorage);
});
