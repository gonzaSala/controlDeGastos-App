import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences prefs;

  bool loggedIn = false;
  bool loading = true;
  User? user;

  bool isLoggedIn() => loggedIn;

  bool isLoading() => loading;

  LoginState() {
    loginState();
  }

  User? currentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  void login() async {
    loading = true;
    notifyListeners();
    user = await handleSignIn();

    if (user != null) {
      prefs.setBool('isLoggedIn', true);
      loggedIn = true;
      loading = false;
      notifyListeners();
    } else {
      loggedIn = false;
      notifyListeners();
    }
  }

  void logout() {
    prefs.clear();
    googleSignIn.signOut();
    loggedIn = false;
    loading = false;
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

  Future<void> loginState() async {
    prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('isLoggedIn')) {
      user = await firebaseAuth.currentUser;
      loggedIn = user != null;
      loading = false;
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
  }
}
