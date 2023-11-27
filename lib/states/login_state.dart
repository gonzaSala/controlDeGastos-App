import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late SharedPreferences prefs;
  String _userId = ''; // Inicializar _userId para evitar problemas de null

  String get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }

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
      setUserId(user!.uid);
      notifyListeners();
    } else {
      loggedIn = false;
      loading = false;
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
      setUserId(user!.uid);
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithGroup(String groupName, String groupPassword) async {
    try {
      // Inicia sesión con el grupo utilizando el nombre del grupo como correo electrónico
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '$groupName@myapp.com',
        password: groupPassword,
      );

      String groupId = userCredential.user!.uid;

      setUserId(groupId);
    } catch (error) {
      var navigatorKey;
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión en el grupo: $error'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
