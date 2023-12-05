import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool loggedIn = false;
  bool loading = false;
  User? user;

  bool isLoggedIn() => loggedIn;

  bool isLoading() => loading;

  User? currentUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user;
  }

  void loginWithGoogle() async {
    print('Iniciando sesión con Google...');
    loading = true;
    notifyListeners();

    user = await handleSignIn();

    loading = false;
    if (user != null) {
      loggedIn = true;
      await FirebaseAuth.instance.currentUser?.reload();
      notifyListeners();
      print('Inicio de sesión con Google exitoso.');
    } else {
      loggedIn = false;
      notifyListeners();
      print('Inicio de sesión con Google fallido.');
    }
  }

  Future loginWithEmailPassword(String email, String password) async {
    print('Iniciando sesión con email y contraseña...');
    loading = true;
    notifyListeners();

    try {
      final UserCredential authResult = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      loading = false;
      if (user != null) {
        loggedIn = true;
        await FirebaseAuth.instance.currentUser?.reload();
        notifyListeners();
        print('Inicio de sesión con email y contraseña exitoso.');
      }
    } catch (error) {
      loading = false;
      loggedIn = false;
      notifyListeners();
      print('Error al iniciar sesión con email y contraseña: $error');
    }
  }

  void registerWithEmailPassword(String email, String password) async {
    print('Registrando con email y contraseña...');
    loading = true;
    notifyListeners();

    try {
      final UserCredential authResult =
          await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = authResult.user;

      loading = false;
      if (user != null) {
        loggedIn = true;
        await FirebaseAuth.instance.currentUser?.reload();
        notifyListeners();
        print('Registro con email y contraseña exitoso.');
      }
    } catch (error) {
      loading = false;
      loggedIn = false;
      notifyListeners();
      print('Error al registrar con email y contraseña: $error');
    }
  }

  void logout() {
    googleSignIn.signOut();
    auth.signOut();
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
          await auth.signInWithCredential(credential);

      final User? user = authResult.user;

      print('Inicio de sesión con Google exitoso: ${user?.displayName}');
      return user;
    } catch (error) {
      print('Error al iniciar sesión con Google: $error');
      return null;
    }
  }
}
