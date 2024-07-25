import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tutorados_app/entities/entities.dart';
import 'package:tutorados_app/presentation/providers/providers.dart';

final goRouterNotifierProvider = Provider((ref) {
  final authNotifier = ref.read(authProvider.notifier);
  return GoRouterNotifier(authNotifier);
});

class GoRouterNotifier extends ChangeNotifier {
  final AuthNotifier _authNotifier;

  AuthStatus _authStatus = AuthStatus.checking;
  User? _user;

  GoRouterNotifier(this._authNotifier) {
    _authNotifier.addListener((state) {
      authStatus = state.authStatus;
      user = state.user;
    });
  }

  AuthStatus get authStatus => _authStatus;
  User? get user => _user;

  set authStatus(AuthStatus value) {
    _authStatus = value;
    notifyListeners();
  }

  set user(User? value) {
    _user = value;
    notifyListeners();
  }  

}
