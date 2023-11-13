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

  String dateStr = 'hoy';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(0, 181, 35, 35),
        elevation: 0.0,
        title: TextButton(
          onPressed: () {
            showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate:
                        DateTime.now().subtract(Duration(hours: 24 * 30)),
                    lastDate: DateTime.now())
                .then((newDate) {
              if (newDate != null) {
                setState(() {
                  date = newDate;
                  dateStr =
                      '${date.day.toString()}-${date.month.toString()}-${date.year.toString()}';
                });
              }
            });
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(12.0),
            backgroundColor: Color.fromARGB(255, 98, 87, 250),
          ),
          child: Text(
            'Categoria ($dateStr)',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 218, 218),
            ),
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
    Map<String, IconData> categories = {
      'Otros': Icons.wallet,
      'Shopping': Icons.shopping_cart,
      'Comida': FontAwesomeIcons.burger,
      'Transporte': Icons.directions_bus_sharp,
      'Alcohol': FontAwesomeIcons.beerMugEmpty,
      'Salud': Icons.local_hospital_outlined,
      'Deudas': Icons.business_center_rounded,
      'Mascotas': Icons.pets_sharp,
      'Educación': Icons.school_rounded,
      'Ropa': FontAwesomeIcons.personDress,
      'Hogar': Icons.home,
    };

    return Container(
      height: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          border: Border.all(color: Color.fromARGB(255, 22, 17, 97)),
          color: Color.fromARGB(255, 8, 6, 38)),
      child: CategorySelectorWidget(
        categories: categories,
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 1.0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Text(
        "\$${realValue}",
        style: TextStyle(
            color: Color.fromARGB(255, 195, 191, 254),
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
            value = value * 10;
          } else {
            value = value * 10 + int.parse(text);
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
              color: Color.fromARGB(255, 195, 191, 254),
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
            color: Color.fromARGB(255, 245, 206, 206),
            width: 1,
            borderRadius: BorderRadius.circular(15.0),
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
                      color: Color.fromARGB(255, 249, 144, 128),
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
                color: Color.fromARGB(255, 98, 87, 250),
                borderRadius: BorderRadius.all(Radius.circular(12)),
                border: Border.all(color: Color.fromARGB(255, 195, 191, 254))),
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
                    'month': date.month,
                    'day': date.day,
                    'year': date.year,
                  });
                  Navigator.of(context).pop();
                } else {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text('Selecciona un valor y una categoría'),
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
                }
              },
            ),
          ),
        );
      },
    );
  }
}
