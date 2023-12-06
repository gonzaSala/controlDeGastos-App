import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class NotificationState with ChangeNotifier {
  bool _notificationsEnabled = true;

  bool get notificationsEnabled => _notificationsEnabled;

  void toggleNotifications() {
    _notificationsEnabled = !_notificationsEnabled;
    notifyListeners();
  }
}

class NotificationServices {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }

  static Future showSimpleNotification(BuildContext context) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('1', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    var notificationState =
        Provider.of<NotificationState>(context, listen: false);

    if (notificationState.notificationsEnabled) {
      await flutterLocalNotificationsPlugin.periodicallyShow(
        1,
        'hola titulo',
        'hola body',
        RepeatInterval.everyMinute,
        notificationDetails,
        payload: 'hola payload',
      );
    }
  }

  static Future cancel(int id) async {
    await flutterLocalNotificationsPlugin.cancel(1);
  }
}
