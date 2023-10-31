import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/login_state.dart';
import 'package:control_gastos/widgets/category_selector_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  late String category;
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          'Category',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.close_outlined,
                color: Colors.grey,
              ))
        ],
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: [
        _categorySelector(),
        _currentValue(),
        _numpad(),
        _submit(),
      ],
    );
  }

  Widget _categorySelector() {
    return Container(
      height: 80,
      child: CategorySelectorWidget(
        categories: {
          'Varios': Icons.wallet,
          'Shopping': Icons.shopping_cart,
          'Comida': FontAwesomeIcons.burger,
          'Transporte': Icons.directions_bus_sharp,
          'Alcohol': FontAwesomeIcons.beerMugEmpty,
          'Salud': Icons.local_hospital_outlined,
          'Deudas': Icons.business_center_rounded,
          'Mascotas': Icons.pets_sharp,
          'Educación': Icons.school_rounded,
          'Ropa': FontAwesomeIcons.personDress,
          'Hogar': Icons.home
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = (value / 100.00).toStringAsFixed(2);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Text(
        '\$${realValue}',
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 50,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _num(String text, double height) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          if (text == ',') {
            value = value * 100;
          } else {
            value = value * 100 + int.parse(text);
          }
        });
      },
      child: Container(
        height: height,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 40.0,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpad() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      var height = constraints.biggest.height / 4;
      return Table(
          border: TableBorder.all(
            color: Colors.grey,
            width: 1,
          ),
          children: [
            TableRow(children: [
              _num('1', height),
              _num('2', height),
              _num('3', height),
            ]),
            TableRow(children: [
              _num('4', height),
              _num('5', height),
              _num('6', height),
            ]),
            TableRow(children: [
              _num('7', height),
              _num('8', height),
              _num('9', height),
            ]),
            TableRow(children: [
              _num(',', height),
              _num('0', height),
              GestureDetector(
                onTap: () {
                  setState(() {
                    value = value ~/ 10;
                  });
                },
                child: Container(
                  height: height,
                  child: Center(
                    child: Icon(
                      Icons.backspace_rounded,
                      color: Colors.grey,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ]),
          ]);
    }));
  }

  Widget _submit() {
    return Consumer<LoginState>(
      builder: (context, loginState, child) {
        var user = loginState.currentUser();

        return Hero(
          tag: 'add_button',
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
            ),
            child: MaterialButton(
              child: Text(
                'Sumar gasto',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                if (value > 0 && category != '') {
                  print('Adding expense');
                  await FirebaseFirestore.instance
                      .collection('user')
                      .doc(user?.uid)
                      .collection('expenses')
                      .add({
                    'category': category,
                    'value': value,
                    'month': DateTime.now().month,
                    'day': DateTime.now().day,
                  });

                  // No es necesario actualizar la consulta aquí

                  Navigator.of(context).pop(); // Indicar que se agregó un gasto
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Selecciona un valor y una categoría'),
                  ));
                }
              },
            ),
          ),
        );
      },
    );
  }
}
