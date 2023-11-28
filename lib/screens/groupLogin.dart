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
                    onPressed: () {
                      _createGroup();
                    },
                    child: Text('Crear Grupo'),
                  ),
                  ElevatedButton(
                    onPressed: () async {},
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

  Future<void> _createGroup() async {
    try {
      String groupName = groupNameController.text;
      String groupPassword = groupPasswordController.text;

      if (groupName.isNotEmpty && groupPassword.isNotEmpty) {
        // Obtener una referencia a la colección de grupos
        CollectionReference groupsCollection =
            FirebaseFirestore.instance.collection('groups');

        // Añadir un nuevo documento a la colección
        DocumentReference newGroupRef = await groupsCollection.add({
          'groupName': groupName,
          'groupPassword': groupPassword,
        });

        // Imprimir el ID del nuevo grupo generado por Firestore
        print('Nuevo grupo creado con ID: ${newGroupRef.id}');

        // Puedes agregar más lógica aquí, como navegar a la pantalla principal del grupo
        // o realizar otras operaciones necesarias después de crear el grupo.
      } else {
        // Manejar el caso en el que los campos estén vacíos
        print('Por favor, complete todos los campos.');
      }
    } catch (e) {
      // Manejar cualquier error que pueda ocurrir al crear el grupo
      print('Error al crear el grupo: $e');
    }
  }
}
