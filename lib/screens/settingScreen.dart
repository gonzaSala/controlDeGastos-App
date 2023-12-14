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
  String? _profileImageUrl;
  bool _isLoading = false;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _loadProfileImageFromStorage();
  }

  @override
  void dispose() {
    super.dispose();
  }

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

  Future<String> _uploadImageToStorage() async {
    try {
      var expensesRepo =
          Provider.of<expensesRepository>(context, listen: false);

      String imageUrl =
          await expensesRepo.uploadProfileImage(_selectedImage!) ?? '';
      print('$imageUrl');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('profileImageUrl', imageUrl);
      print('Image URL saved in SharedPreferences: $imageUrl');

      setState(() {
        _profileImageUrl = prefs.getString('profileImageUrl');
      });

      return imageUrl;
    } catch (e) {
      print('Error al subir la imagen al almacenamiento: $e');
      return '';
    }
  }

  Widget _uploadProfilePicture(BuildContext context, expensesRepository repo) {
    return Container(
      width: double.infinity,
      color: Color.fromARGB(23, 163, 163, 163),
      padding: EdgeInsets.all(8),
      child: Stack(
        children: [
          _loadProfileImage(context, repo),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
              bottom: 0,
              right: 250,
              child: IconButton(
                onPressed: () async {
                  await _pickImage();
                },
                icon: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                iconSize: 30.0,
                padding: EdgeInsets.all(15.0),
                splashRadius: 30.0,
                color: Color.fromARGB(135, 162, 162, 162),
              )),
        ],
      ),
    );
  }

  Future<void> _loadProfileImageFromStorage() async {
    try {
      var expensesRepo =
          Provider.of<expensesRepository>(context, listen: false);
      String? imageUrl = await expensesRepo.getProfileImageUrl();
      print('asdasdasdasdasdasdsa');

      if (imageUrl != null) {
        setState(() {
          _profileImageUrl = imageUrl;
        });
      }
    } catch (e) {
      print('Error al cargar la imagen del almacenamiento: $e');
    }
  }

  Widget _loadProfileImage(BuildContext context, expensesRepository repo) {
    if (_selectedImage != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: FileImage(_selectedImage!),
      );
    } else if (_profileImageUrl != null) {
      return CircleAvatar(
        radius: 50,
        backgroundImage: NetworkImage(_profileImageUrl!),
      );
    } else {
      return CircleAvatar(
        radius: 50,
        child: Icon(Icons.person),
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _isLoading = true;
        _selectedImage = File(pickedFile.path);
      });
      String imageUrl = await _uploadImageToStorage();
      print('${imageUrl}');

      setState(() {
        _profileImageUrl = imageUrl;
        _isLoading = false;
      });
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
