import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/homePage.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Volver al login')),
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
                      Navigator.of(context).pop();
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
                  controller: groupNameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 30),
              Text('Ingrese contraseña del grupo',
                  style: TextStyle(color: Colors.white)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: groupPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade400)),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Crear Grupo'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text('Unirse al Grupo'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
