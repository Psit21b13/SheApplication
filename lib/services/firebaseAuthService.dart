import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static SharedPreferences prefs;

  Future<AuthResult> loginWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      AuthenticationService.prefs.setString('email', user.user.email);
      return user;
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.message}", backgroundColor: Colors.grey);
      return e.message;
    }
  }

  Future<FirebaseUser> signUpWithEmail({
    @required String email,
    @required String password,
  }) async {
    try {
      var authResult = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authResult.user;
    } catch (e) {
      Fluttertoast.showToast(msg: "${e.message}", backgroundColor: Colors.grey);
      return e.message;
    }
  }
}
