import 'package:control_gastos/category_selector_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
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
      ),
    );
  }

  Widget _currentValue() => Placeholder(
        fallbackHeight: 120,
      );
  Widget _numpad() => Placeholder(
        child: Placeholder(),
      );
  Widget _submit() => Placeholder(
        fallbackHeight: 50,
      );
}
