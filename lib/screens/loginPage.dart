import 'package:control_gastos/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: ElevatedButton(
        child: Text('Sing In'),
        onPressed: () {
          Provider.of<LoginState>(context, listen: false).login();
        },
      )),
    );
  }
}
