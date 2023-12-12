import 'dart:io';

import 'package:control_gastos/expenses_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:control_gastos/firebase_Api.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  File? _selectedImage;
  @override
  Widget build(BuildContext context) {
    var expensesRepo = Provider.of<expensesRepository>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          'Opciones',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          _uploadProfilePicture(context, expensesRepo),
          _notifications(context),
          _deleteData(context, expensesRepo),
        ],
      ),
    );
  }

  Widget _uploadProfilePicture(BuildContext context, expensesRepository repo) {
    return Container(
      width: double.infinity,
      alignment: Alignment.topLeft,
      color: Color.fromARGB(23, 163, 163, 163),
      padding: EdgeInsets.all(8),
      child: Container(
        width: 120,
        height: 120,
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            _loadProfileImage(context, repo),
            Positioned(
              bottom: 0,
              right: 0,
              child: FloatingActionButton(
                onPressed: () async {
                  await _pickImage(context, repo);
                },
                backgroundColor: Color.fromARGB(135, 162, 162, 162),
                mini: true,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _loadProfileImage(BuildContext context, expensesRepository repo) {
    if (_selectedImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }

  Future<void> _pickImage(BuildContext context, expensesRepository repo) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      _selectedImage = File(image.path);

      final success = await repo.uploadImg(_selectedImage!);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Imagen cargada con éxito',
                style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _loadProfileImage(context, repo);
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar la imagen',
                style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Widget _deleteData(BuildContext context, expensesRepository repo) {
    return Container(
      alignment: Alignment.topLeft,
      color: Color.fromARGB(23, 163, 163, 163),
      padding: EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          _selectDelete(context, repo);
        },
        child: Text(
          'Eliminar gastos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _selectDelete(BuildContext context, expensesRepository repo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 239, 224, 255),
          title: Center(child: Text('Seleccione una opción')),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  elevation: 10,
                  backgroundColor: Color.fromARGB(67, 249, 18, 157),
                  foregroundColor: Color.fromARGB(215, 207, 207, 207),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showConfirmationDialog(context, repo,
                      deleteCurrentMonth: true);
                },
                child: Text('MES ACTUAL'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(15),
                  elevation: 10,
                  backgroundColor: Color.fromARGB(67, 249, 18, 157),
                  foregroundColor: Color.fromARGB(215, 207, 207, 207),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 10,
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  _showConfirmationDialog(context, repo,
                      deleteCurrentMonth: false);
                },
                child: Text('TODOS'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(BuildContext context, expensesRepository repo,
      {required bool deleteCurrentMonth}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Confirmación')),
          content: Text(
            deleteCurrentMonth
                ? '¿Está seguro de que desea eliminar todos los gastos del mes actual?'
                : '¿Está seguro de que desea eliminar todos los gastos?',
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                elevation: 10,
                backgroundColor: Color.fromARGB(67, 249, 18, 157),
                foregroundColor: Color.fromARGB(215, 207, 207, 207),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (deleteCurrentMonth) {
                  await repo.deleteMonthCurrent();
                  print('se elimino lo del mes actual');
                } else {
                  await repo.resetApp();
                  print('se elimino TODO');
                }
                Navigator.of(context).pop();
              },
              child: Text(
                'Confirmar',
                style: TextStyle(color: Color.fromARGB(255, 255, 100, 100)),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(10),
                elevation: 10,
                backgroundColor: Color.fromARGB(67, 249, 18, 157),
                foregroundColor: Color.fromARGB(215, 207, 207, 207),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                textStyle: TextStyle(
                  fontSize: 18,
                  letterSpacing: 0.8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _notifications(BuildContext context) {
    var firebaseApi = Provider.of<FirebaseApi>(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Notificaciones',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Switch(
            activeColor: Color.fromARGB(170, 205, 154, 255),
            activeTrackColor: Color.fromARGB(205, 181, 178, 178),
            inactiveThumbColor: Color.fromARGB(170, 56, 4, 107),
            inactiveTrackColor:
                const Color.fromARGB(123, 158, 158, 158).withOpacity(0.5),
            splashRadius: 80.0,
            value: firebaseApi.isNotificationsEnabled,
            onChanged: (bool value) {
              _toggleNotifications(context, value);
              print('$_toggleNotifications');
            },
          ),
        ],
      ),
    );
  }

  void _toggleNotifications(BuildContext context, bool enabled) {
    var firebaseApi = Provider.of<FirebaseApi>(context, listen: false);
    if (enabled) {
      firebaseApi.initNotifications();
    } else {
      firebaseApi.cancelNotifications();
    }
  }
}
