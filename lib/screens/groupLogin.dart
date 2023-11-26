import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
                      Navigator.of(context).pushNamed('/groupLogin');
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
                    onPressed: () async {
                      // Llama al método para crear el grupo y pasar los controladores
                      await _createGroup(groupNameController.text,
                          groupPasswordController.text);
                    },
                    child: Text('Crear Grupo'),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Llama al método para iniciar sesión con el grupo
                      await _loginWithGroup(groupNameController.text,
                          groupPasswordController.text);
                    },
                    child: Text('Iniciar sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createGroup(String groupName, String groupPassword) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: '$groupName@myapp.com',
        password: groupPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Grupo creado con éxito.'),
        duration: Duration(seconds: 3),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al crear el grupo: $error'),
        duration: Duration(seconds: 3),
      ));
    }
  }

  Future<void> _loginWithGroup(String groupName, String groupPassword) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: '$groupName',
        password: groupPassword,
      );

      // Muestra un mensaje de éxito
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Iniciado sesión con éxito en el grupo.'),
        duration: Duration(seconds: 3),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión en el grupo: $error'),
        duration: Duration(seconds: 3),
      ));
    }
  }
}
