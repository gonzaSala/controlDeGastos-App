import 'package:control_gastos/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

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

  List<Expense> expenses = [];

  void save() {
    final name = newExpenseControlName.text;
    final cantidad = double.tryParse(newExpenseControlCantidad.text) ?? 0.0;
    final date = DateTime.now();

    if (name.isNotEmpty && cantidad > 0) {
      expenses.add(Expense(name: name, cantidad: cantidad, date: date));
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  void viewExpenses() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text('Lista de Gastos'),
          ),
          body: ListView.builder(
            itemCount: expenses.length,
            itemBuilder: (context, index) {
              final expense = expenses.reversed.toList()[index];
              return Dismissible(
                key: Key(expense.name), // Debe ser una clave única
                onDismissed: (direction) {
                  // Eliminar el elemento seleccionado
                  setState(() {
                    expenses.removeAt(index);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Se eliminó el gasto: ${expense.name}'),
                    ),
                  );
                },
                background: Container(
                  color: Color.fromARGB(255, 255, 86, 86),
                  child: Icon(FontAwesomeIcons.trash,
                      color: Color.fromRGBO(198, 199, 199, 0.961)),
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20.0),
                ),
                child: ListTile(
                  title: Text(expense.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('\$${expense.cantidad.toStringAsFixed(2)}'),
                      Text(
                          'Fecha: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date)}'),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void cancel() {
    Navigator.of(context).pop(); // Cierra el cuadro de diálogo
  }

  Widget bottomAction(IconData icon, Function() onTapCallback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(icon),
      ),
      onTap: onTapCallback,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control de Gastos'),
      ),
      body: Center(
        child: Text('Página principal'),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 163, 191, 240),
        notchMargin: 4.0,
        shape: const CircularNotchedRectangle(),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            bottomAction(FontAwesomeIcons.history, viewExpenses),
            bottomAction(FontAwesomeIcons.chartPie, () {}),
            const SizedBox(width: 42.0),
            bottomAction(FontAwesomeIcons.wallet, () {}),
            bottomAction(Icons.settings, () {}),
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
              decoration: InputDecoration(labelText: 'Nombre del Gasto'),
            ),
            TextField(
              controller: newExpenseControlCantidad,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Cantidad'),
            ),
          ],
        ),
        actions: [
          MaterialButton(
            onPressed: save,
            child: Text('Guardar'),
          ),
          MaterialButton(
            onPressed: cancel,
            child: Text('Cancelar'),
          ),
        ],
      ),
    );
  }
}
