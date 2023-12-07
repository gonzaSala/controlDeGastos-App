import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/states/login_state.dart';
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
  String category = '';
  int value = 0;
  String details = '';

  String dateStr = 'hoy';
  DateTime date = DateTime.now();

  bool TxtFieldVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(0, 78, 51, 51),
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
            side: BorderSide(
                width: 0.2,
                color:
                    const Color.fromARGB(255, 255, 255, 255).withOpacity(0.5)),
            padding: EdgeInsets.only(left: 30.0, right: 30.0),
            backgroundColor: Color.fromARGB(30, 255, 255, 255),
          ),
          child: Text(
            'Fecha ($dateStr)',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 218, 218),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
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
        _details(),
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
          border: Border.all(color: Color.fromARGB(37, 255, 255, 255)),
          color: Color.fromARGB(31, 126, 126, 126)),
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
              fontSize: 42.0,
              fontWeight: FontWeight.w600,
              color: Color.fromARGB(255, 195, 191, 254),
            ),
          ),
        ),
      ),
    );
  }

  Widget _details() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 5,
              ),
              Text(
                'Opcional',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          TextFormField(
            onChanged: (value) {
              setState(() {
                details = value;
              });
            },
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              fillColor: Color.fromARGB(41, 194, 194, 194),
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              hintText: 'Ingrese detalles...',
              hintStyle: TextStyle(color: Colors.white60),
            ),
          ),
        ],
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
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Color.fromARGB(60, 98, 87, 250),
                  borderRadius: BorderRadius.all(Radius.circular(22)),
                  border:
                      Border.all(color: Color.fromARGB(255, 195, 191, 254))),
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
                      'details': details,
                      'timestamp': DateTime.now()
                    });
                    Navigator.of(context).pop();
                  }
                  if (value == 0 || category == '') {
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
          ),
        );
      },
    );
  }
}
