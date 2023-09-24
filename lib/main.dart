import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final newExpenseControlName = TextEditingController();
  final newExpenseControlCantidad = TextEditingController();

  void addNewExpense() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Agregar nuevo gasto'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: newExpenseControlName,
                  ),
                  TextField(
                    controller: newExpenseControlCantidad,
                  ),
                ],
              ),
              actions: [
                MaterialButton(
                  onPressed: save,
                  child: Text('Guardad'),
                ),
                MaterialButton(
                  onPressed: cancel,
                  child: Text('Cancelar'),
                ),
              ],
            ));
  }

  void save() {}

  void cancel() {}

  Widget bottomAction(IconData icon) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 163, 191, 240),
        notchMargin: 4.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            bottomAction(FontAwesomeIcons.history),
            bottomAction(FontAwesomeIcons.chartPie),
            const SizedBox(width: 42.0),
            bottomAction(FontAwesomeIcons.wallet),
            bottomAction(Icons.settings),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        hoverColor: Color.fromARGB(146, 0, 111, 166),
        child: const Icon(Icons.add),
        onPressed: addNewExpense,
      ),
    );
  }
}
