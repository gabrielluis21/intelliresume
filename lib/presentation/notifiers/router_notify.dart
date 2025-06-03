import 'package:flutter/foundation.dart';
import 'package:intelliresume/data/datasources/remote/auth_resume_ds.dart';

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(this._authMethods) {
    _authMethods.authStateChanges.listen((event) {
      notifyListeners();
    });
  }

  final AuthService _authMethods;
}
