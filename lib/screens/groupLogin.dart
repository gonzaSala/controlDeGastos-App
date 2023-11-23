import 'package:control_gastos/login_state.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class groupLogin extends StatefulWidget {
  @override
  State<groupLogin> createState() => _groupLoginState();
}

class _groupLoginState extends State<groupLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volver al login')),
      body: SafeArea(
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                mainAxisSize: MainAxisSize.max,
                children: [
                  IconButton(
                    iconSize: 80,
                    icon: Image.asset('assets/groupIcon.png'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/groupLogin');
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Ingrese nombre del grupo',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                'Ingrese contraseña del grupo',
                style: TextStyle(color: Colors.white),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade400)),
                      fillColor: Colors.grey.shade200,
                      filled: true),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
