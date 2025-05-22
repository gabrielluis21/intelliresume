import 'package:flutter/foundation.dart';
import 'package:intelliresume/services/auth_service.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._authMethods) {
    _authMethods.authStateChanges.listen((event) {
      notifyListeners();
    });
  }

  final AuthService _authMethods;
}
