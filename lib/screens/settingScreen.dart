import 'package:control_gastos/notification_services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var notificationState = Provider.of<NotificationState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Opciones'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            'Notificaciones',
            style: TextStyle(color: Colors.white),
          ),
          Switch(
            activeColor: Color.fromARGB(255, 216, 255, 203),
            activeTrackColor: const Color.fromARGB(255, 255, 255, 255),
            inactiveThumbColor: Colors.grey.withOpacity(0.7),
            inactiveTrackColor: Colors.grey.withOpacity(0.5),
            splashRadius: 80.0,
            value: notificationState.notificationsEnabled,
            onChanged: (bool value) {
              notificationState.toggleNotifications();
              if (value) {
                // Habilitar notificaciones
                NotificationServices.showSimpleNotification(context);
              } else {
                // Deshabilitar notificaciones
                NotificationServices.cancel(1);
              }
            },
          ),
        ],
      ),
    );
  }
}
