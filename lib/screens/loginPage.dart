import 'package:control_gastos/login_state.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TapGestureRecognizer _recognizer1;
  late TapGestureRecognizer _recognizer2;

  @override
  void initState() {
    super.initState();
    _recognizer1 = TapGestureRecognizer();
    _recognizer2 = TapGestureRecognizer();
  }

  @override
  void dispose() {
    _recognizer1.dispose();
    _recognizer2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(),
            ),
            Text(
              'Cuenta Clara',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Image.asset('assets/backgroundLogin.png'),
            ),
            Text(
              'Tu app de finanzas personales',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Expanded(flex: 1, child: Container()),
            Consumer<LoginState>(
              builder: (BuildContext context, LoginState value, Widget? child) {
                if (value.isLoading()) {
                  return CircularProgressIndicator();
                } else {
                  return child!;
                }
              },
              child: ElevatedButton(
                child: Text('Ingresar'),
                onPressed: () {
                  Provider.of<LoginState>(context, listen: false).login();
                },
              ),
            ),
            Expanded(flex: 1, child: Container()),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium,
                    text: 'To use this app you need to agree to our',
                    children: [
                      TextSpan(
                        text: 'Terms of Service',
                        recognizer: _recognizer1,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Privacy Policy',
                        recognizer: _recognizer2,
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      )
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }
}
