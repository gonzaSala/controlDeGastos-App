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
  _AddPageState() {
    category = "initial_value";
  }

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
          'Shopping': Icons.shopping_cart,
          'Alcohol': FontAwesomeIcons.beerMugEmpty,
          'Comida': FontAwesomeIcons.burger,
          'Varios': Icons.wallet,
        },
        onValueChanged: (newCategory) => category = newCategory,
      ),
    );
  }

  Widget _currentValue() {
    var realValue = value / 100.00;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 35.0),
      child: Text(
        '\$${realValue.toStringAsFixed(2)}',
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
    return Builder(builder: (BuildContext context) {
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
              onPressed: () {
                var user = Provider.of<LoginState>(context).currentUser();
                if (value > 0 && category != '' && category.isNotEmpty) {
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(user?.uid)
                      .collection('expenses')
                      .add({
                    'category': category,
                    'value': value,
                    'month': DateTime.now().month,
                    'day': DateTime.now().day,
                  });
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Selecciona un valor y una categoría')));
                }
              }),
        ),
      );
    });
  }
}
