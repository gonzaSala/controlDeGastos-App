import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/homePage.dart';
import 'package:control_gastos/screens/loginPage.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class groupLogin extends StatefulWidget {
  @override
  State<groupLogin> createState() => _groupLoginState();
}

class _groupLoginState extends State<groupLogin> {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController groupPasswordController = TextEditingController();

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool isPasswordValid = true;

  String _passwordRequirementsMessage() {
    return 'La contraseña debe tener al menos 8 caracteres.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Volver al login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromARGB(0, 255, 255, 255),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    iconSize: 80,
                    icon: Image.asset('assets/groupIcon.png'),
                    onPressed: () {
                      Navigator.of(context).popAndPushNamed('/loginPage');
                    },
                  ),
                ],
              ),
              SizedBox(height: 50),
              Text('Ingrese nombre del grupo',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  cursorWidth: 0.8,
                  style: TextStyle(
                    fontSize: 20,
                    color: Color.fromARGB(198, 255, 255, 255),
                    fontWeight: FontWeight.w100,
                  ),
                  controller: groupNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    fillColor: Color.fromARGB(46, 238, 238, 238),
                    filled: true,
                  ),
                  cursorColor: Color.fromARGB(39, 255, 255, 255),
                ),
              ),
              SizedBox(height: 30),
              Text('Ingrese contraseña del grupo',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    TextField(
                      controller: groupPasswordController,
                      obscureText: true,
                      onChanged: (password) {
                        setState(() {
                          isPasswordValid = _isPasswordValid(password);
                        });
                      },
                      cursorWidth: 0.8,
                      cursorColor: Color.fromARGB(39, 255, 255, 255),
                      style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(198, 255, 255, 255),
                        fontWeight: FontWeight.w100,
                      ),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey.shade400)),
                        fillColor: Color.fromARGB(46, 238, 238, 238),
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      !isPasswordValid ? _passwordRequirementsMessage() : '',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Consumer<LoginState>(
                builder:
                    (BuildContext context, LoginState value, Widget? child) {
                  if (value.isLoading()) {
                    return CircularProgressIndicator();
                  } else {
                    return child!;
                  }
                },
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        String email =
                            groupNameController.text + '@onlygastos.com';
                        String password = groupPasswordController.text;
                        if (password.length < 8) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'La contraseña debe tener al menos 8 caracteres.'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else {
                          Provider.of<LoginState>(context, listen: false)
                              .registerWithEmailPassword(email, password);
                        }
                      },
                      child: Text('Crear Grupo'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        String email =
                            groupNameController.text + '@onlygastos.com';
                        String password = groupPasswordController.text;

                        await Provider.of<LoginState>(context, listen: false)
                            .loginWithEmailPassword(email, password);

                        Navigator.pushReplacementNamed(context, '/');
                      },
                      child: Text('Unirse al Grupo'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
