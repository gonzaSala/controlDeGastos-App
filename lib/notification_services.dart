import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('ic_launcher_adaptive_fore');

  final DarwinInitializationSettings darwinInitializationSettings =
      DarwinInitializationSettings();

  void initNotifications() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
      iOS: darwinInitializationSettings,
    );

    await flutterLocalNotificationsPlugin
        .initialize(initializationSettings)
        .then((init) => showNotification());
  }

  void showNotification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channelId', 'channelName');

    DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Las cuentas claras!',
        'No te olvides de agregar tus gastos!!!',
        RepeatInterval.everyMinute,
        notificationDetails);
  }
}
