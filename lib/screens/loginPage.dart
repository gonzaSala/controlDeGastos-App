import 'package:control_gastos/states/login_state.dart';

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
        child: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Text(
                'Only Gastos',
                style: Theme.of(context)
                    .textTheme
                    .headlineLarge!
                    .copyWith(color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Image.asset('assets/loginPage.png'),
              ),
              Text(
                'Tu app de finanzas personales',
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: Colors.white),
              ),
              Expanded(flex: 2, child: Container()),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Uso personal',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Uso grupal',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
              Consumer<LoginState>(
                builder:
                    (BuildContext context, LoginState value, Widget? child) {
                  if (value.isLoading()) {
                    return CircularProgressIndicator();
                  } else {
                    return child!;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    IconButton(
                      iconSize: 80,
                      icon: Image.asset('assets/googleIcon.png'),
                      onPressed: () {
                        Provider.of<LoginState>(context, listen: false).login();
                      },
                    ),
                    IconButton(
                      iconSize: 80,
                      icon: Image.asset('assets/groupIcon.png'),
                      onPressed: () {
                        Navigator.of(context).pushNamed('/groupLogin');
                      },
                    ),
                  ],
                ),
              ),
              Expanded(flex: 1, child: Container()),
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                      text: 'To use this app you need to agree to our',
                      children: [
                        TextSpan(
                          text: ' Terms of Service',
                          recognizer: _recognizer1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'Privacy Policy',
                          recognizer: _recognizer2,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                        )
                      ]),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
