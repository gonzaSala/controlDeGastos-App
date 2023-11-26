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
      notifyListeners();
    } else {
      loading = false;
      notifyListeners();
    }
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> shareDataWithUser(String userEmail) async {
    try {
      if (user != null) {
        // Obtener la referencia del documento del usuario actual
        DocumentReference currentUserDoc =
            firestore.collection('users').doc(user!.uid);

        // Obtener la referencia del documento del usuario con el que se compartirán los datos
        DocumentReference otherUserDoc =
            firestore.collection('users').doc(userEmail);

        // Obtener los datos del usuario actual
        DocumentSnapshot currentUserSnapshot = await currentUserDoc.get();
        Map<String, dynamic>? currentUserData =
            currentUserSnapshot.data() as Map<String, dynamic>?;

        if (currentUserData != null) {
          // Compartir los datos del usuario actual con el otro usuario
          await otherUserDoc.set(currentUserData, SetOptions(merge: true));
        }

        print('Datos compartidos con éxito con $userEmail');
      } else {
        print('Usuario no autenticado');
      }
    } catch (error) {
      print('Error al compartir datos: $error');
    }
  }
}
