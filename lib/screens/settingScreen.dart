import 'dart:convert';
import 'dart:io';

import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/screens/categoryData.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/material.dart';
import 'package:control_gastos/widgets/category_selector_widget.dart';
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
  String newCategoryName = '';
  IconData newCategoryIcon = Icons.category;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    _loadProfileImageFromStorage();
    CategoryData.loadCategoriesFromSharedPreferences();
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
          _createCategoryButton(context),
          eliminarCategoria(context)
        ],
      ),
    );
  }

  Widget eliminarCategoria(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          _mostrarDialogoEliminarCategoria(context, CategoryData.categories);
        },
        child: Text(
          'Eliminar Categoría',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _createCategoryButton(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(8),
      child: TextButton(
        onPressed: () {
          _createCategory(context, CategoryData.categories);
        },
        child: Text(
          'Crear Categoría',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _eliminarCategoria(BuildContext context,
      Map<String, IconData> categories, String categoryName) async {
    categories.remove(categoryName);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedCategories = prefs.getString('categories') ?? '{}';
    Map<String, dynamic> savedCategories =
        Map<String, dynamic>.from(json.decode(storedCategories));

    if (savedCategories.containsKey(categoryName)) {
      savedCategories.remove(categoryName);
      prefs.setString('categories', json.encode(savedCategories));
    }
  }

  void _mostrarDialogoEliminarCategoria(
      BuildContext context, Map<String, IconData> categories) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.white70,
          elevation: 5,
          backgroundColor: Color.fromARGB(211, 19, 17, 21),
          title: Text(
            'Eliminar Categoría',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: categories.keys.map((String categoryName) {
                return ListTile(
                  title: Text(categoryName,
                      style: TextStyle(
                          color: Colors.white70, fontWeight: FontWeight.bold)),
                  onTap: () {
                    _eliminarCategoria(context, categories, categoryName);
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _createCategory(
      BuildContext context, Map<String, IconData> categories) async {
    final TextEditingController newCategoryNameController =
        TextEditingController();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? storedCategories = prefs.getString('categories');
    Map<String, dynamic> savedCategories =
        Map<String, dynamic>.from(json.decode(storedCategories!));

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shadowColor: Colors.white70,
          elevation: 5,
          backgroundColor: Color.fromARGB(211, 19, 17, 21),
          title: Text(
            'Crear Nueva Categoría',
            style:
                TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.black,
                    onSurface: Colors.black,
                    textStyle: TextStyle(color: Colors.black),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    IconData? iconValue =
                        await FlutterIconPicker.showIconPicker(
                      context,
                      backgroundColor: const Color.fromARGB(227, 255, 255, 255),
                      iconSize: 40.0,
                      closeChild: Text(
                        "Cerrar",
                        style: TextStyle(
                            color: const Color.fromARGB(179, 21, 20, 20),
                            fontWeight: FontWeight.bold),
                      ),
                      searchIcon: Icon(Icons.search_rounded,
                          color: const Color.fromARGB(179, 21, 20, 20)),
                      iconPickerShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      iconColor: Color.fromARGB(175, 59, 21, 72),
                      iconPackModes: [IconPack.material],
                      title: Text(
                        'Seleccione un Icono',
                        style: TextStyle(
                            color: const Color.fromARGB(179, 21, 20, 20)),
                      ),
                    );

                    if (iconValue != null) {
                      setState(() {
                        newCategoryIcon = iconValue;
                      });
                    }
                    if (newCategoryIcon != null) {
                      Navigator.of(context).pop();
                      _createCategory(context, categories);
                    }
                  },
                  child: Text('Seleccione el icono'),
                ),
                SizedBox(
                  height: 10,
                ),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 3500),
                  child: Icon(
                    newCategoryIcon ?? Icons.question_mark,
                    size: 100,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: newCategoryNameController,
                  style: TextStyle(color: Colors.white70),
                  decoration: InputDecoration(
                    hintText: 'Ingrese el nombre',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.transparent,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    suffixIcon: Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Container(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    String newCategoryName = newCategoryNameController.text;

                    if (newCategoryName == '') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          content:
                              Text('Selecciona un nombre y/o una categoría'),
                          actions: <Widget>[
                            FloatingActionButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    } else {
                      if (newCategoryIcon != null) {
                        setState(() {
                          print(
                              'Guardando categorías1: $newCategoryName - $newCategoryIcon');

                          categories[newCategoryName] = newCategoryIcon!;
                        });

                        savedCategories[newCategoryName] =
                            iconToString(newCategoryIcon!);
                        prefs.setString(
                            'categories', json.encode(savedCategories));
                        print(
                            'Guardando shared: $newCategoryName - $newCategoryIcon');
                      } else {
                        setState(() {
                          categories.remove(newCategoryName);
                          print(
                              'Eliminando shared: $newCategoryName - $newCategoryIcon');
                        });

                        savedCategories.remove(newCategoryName);
                        prefs.setString(
                            'categories', json.encode(savedCategories));
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    newCategoryIcon != null
                        ? 'Crear Categoría'
                        : 'Guardar Categoría',
                    style: TextStyle(color: Colors.greenAccent.shade400),
                  ),
                ),
              ]),
            ),
          ],
        );
      },
    );
  }

  String iconToString(IconData icon) {
    return icon.codePoint.toString();
  }

  static void deleteCategory(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedCategories = prefs.getString('categories') ?? '{}';
    Map<String, dynamic> savedCategories =
        Map<String, dynamic>.from(json.decode(storedCategories));

    if (CategoryData.categories.containsKey(name)) {
      CategoryData.categories.remove(name);
      savedCategories.remove(name);
      prefs.setString('categories', json.encode(savedCategories));
    }
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
