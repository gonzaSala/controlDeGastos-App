import 'package:control_gastos/screens/groupLogin.dart';
import 'package:control_gastos/screens/ui/backgroundTheme.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
                flex: 2,
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
                'Tu app de gastos personales y/o grupales',
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
              SizedBox(
                height: 10,
              ),
              Consumer<LoginState>(
                builder:
                    (BuildContext context, LoginState value, Widget? child) {
                  if (value.isLoading()) {
                    return CircularProgressIndicator(
                      color: const Color.fromARGB(135, 255, 255, 255),
                      strokeWidth: 5,
                    );
                  } else {
                    return child!;
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(46, 41, 41, 41),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Color.fromARGB(48, 157, 155, 155),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(113, 97, 97, 97))),
                      child: IconButton(
                        iconSize: 80,
                        icon: Image.asset(
                          'assets/personalcon.png',
                          fit: BoxFit.cover,
                        ),
                        onPressed: () {
                          showMenu(
                            elevation: 8,
                            shape: BeveledRectangleBorder(
                              side: BorderSide(
                                  color:
                                      const Color.fromARGB(125, 255, 255, 255),
                                  width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(8, 5)),
                            ),
                            shadowColor:
                                const Color.fromARGB(255, 255, 255, 255),
                            color: Color.fromARGB(255, 239, 224, 255),
                            context: context,
                            position: RelativeRect.fromLTRB(50, 300, 50, 100),
                            items: [
                              PopupMenuItem(
                                child: ListTile(
                                  leading: Image.asset('assets/googleIcon.png'),
                                  title: Text('Iniciar sesión con Google'),
                                  trailing: IconButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      icon: Icon(Icons.close)),
                                  onTap: () {
                                    Navigator.pop(context);
                                    try {
                                      Provider.of<LoginState>(context,
                                              listen: false)
                                          .loginWithGoogle();
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Error al iniciar sesión: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),

                              // Puedes agregar más opciones de inicio de sesión si lo deseas
                            ],
                          );
                        },
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(46, 41, 41, 41),
                              spreadRadius: 4,
                              blurRadius: 10,
                              offset: Offset(0, 2),
                            ),
                          ],
                          color: Color.fromARGB(48, 157, 155, 155),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              width: 1,
                              color: Color.fromARGB(113, 97, 97, 97))),
                      child: IconButton(
                        iconSize: 80,
                        icon: Image.asset('assets/groupIcon.png'),
                        onPressed: () {
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return BackgroundContainerObscure(
                                  child: groupLogin(),
                                );
                              },
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                const begin = Offset(1.0, 0.0);
                                const end = Offset.zero;
                                const curve = Curves.ease;
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                var fadeTween =
                                    Tween<double>(begin: 0.0, end: 1.0);
                                var fadeAnimation = animation.drive(fadeTween);

                                return FadeTransition(
                                  opacity: fadeAnimation,
                                  child: SlideTransition(
                                    position: offsetAnimation,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                      child: child,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
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
