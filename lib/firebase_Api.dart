import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title ${message.notification?.title}');
  print('Body ${message.notification?.body}');
  print('Payload ${message.data}');
}

class FirebaseApi with ChangeNotifier {
  final _firebaseMessaging = FirebaseMessaging.instance;

  bool _isNotificationsEnabled = true;
  bool get isNotificationsEnabled => _isNotificationsEnabled;

  Future<void> initNotifications() async {
    try {
      await _firebaseMessaging.requestPermission();
      final fCMToken = await _firebaseMessaging.getToken();
      print('Token $fCMToken');
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      FirebaseMessaging.onMessage.listen(handleBackgroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handleBackgroundMessage);
      _isNotificationsEnabled = true;
      notifyListeners();
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  Future<void> cancelNotifications() async {
    await _firebaseMessaging.deleteToken();

    FirebaseMessaging.onMessage.listen(null);
    FirebaseMessaging.onMessageOpenedApp.listen(null);
    _isNotificationsEnabled = false;
    notifyListeners();
  }
}
