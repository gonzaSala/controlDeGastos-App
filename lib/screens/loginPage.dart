import 'package:control_gastos/login_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<LoginState>(
          builder: (BuildContext context, LoginState value, Widget? child) {
            if (value.isLoading()) {
              return CircularProgressIndicator();
            } else {
              return child!;
            }
          },
          child: ElevatedButton(
            child: Text('Sign In'),
            onPressed: () {
              Provider.of<LoginState>(context, listen: false).login();
            },
          ),
        ),
      ),
    );
  }
}
