import 'package:flutter/material.dart';

class GoogleSignInProvider with ChangeNotifier {
  bool _isGoogleSignIn = false;

  get isGoogleSignIn => _isGoogleSignIn;

  void signInWithGoogle(bool isGoogleSignIn) {
    _isGoogleSignIn = isGoogleSignIn;
    notifyListeners();
  }

}