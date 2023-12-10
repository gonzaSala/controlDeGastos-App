import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:control_gastos/firebase_Api.dart';

class Settings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var firebaseApi = Provider.of<FirebaseApi>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Opciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notificaciones',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
            Switch(
              activeColor: Color.fromARGB(255, 216, 255, 203),
              activeTrackColor: const Color.fromARGB(255, 255, 255, 255),
              inactiveThumbColor: Colors.grey.withOpacity(0.7),
              inactiveTrackColor: Colors.grey.withOpacity(0.5),
              splashRadius: 80.0,
              value: firebaseApi.isNotificationsEnabled,
              onChanged: (bool value) {
                _toggleNotifications(context, value);
                print('$_toggleNotifications');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _toggleNotifications(BuildContext context, bool enabled) {
    var firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
    if (enabled) {
      firebaseApi.initNotifications();
    } else {
      firebaseApi.cancelNotifications();
    }
  }
}
