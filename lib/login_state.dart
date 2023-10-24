import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool loggedIn = false;
  bool isLoggedIn() => loggedIn;

  void login() async {
    var user = handleSignIn();
    loggedIn = true;
    notifyListeners();
  }

  void logout() {
    loggedIn = false;
    notifyListeners();
  }

  Future<User?> handleSignIn() async {
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      final UserCredential authResult =
          await firebaseAuth.signInWithCredential(credential);

      final User? user = authResult.user;

      print('Inicio de sesión exitoso: ${user?.displayName}');
      return user;
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return null;
    }
  }
}
