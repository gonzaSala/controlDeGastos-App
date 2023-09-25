import 'package:control_gastos/models/expenses_item.dart';
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

  List<Expense> expenses = [];

// Función para guardar un nuevo gasto
  void save() {
    final name = newExpenseControlName.text;
    final cantidad = double.tryParse(newExpenseControlCantidad.text) ?? 0.0;

    if (name.isNotEmpty && cantidad > 0) {
      expenses.add(Expense(name: name, cantidad: cantidad));
      Navigator.of(context).pop(); // Cierra el cuadro de diálogo
    }
    setState(() {});
  }

// Función para mostrar la lista de gastos
  void viewExpenses() {
    print(
        'Mostrar lista de gastos'); // Verifica si esta función se llama correctamente
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Lista de Gastos'),
        ),
        body: ListView.builder(
          itemCount: expenses.length,
          itemBuilder: (context, index) {
            final expense = expenses[index];
            return ListTile(
              title: Text(expense.name),
              subtitle: Text('\$${expense.cantidad.toStringAsFixed(2)}'),
            );
          },
        ),
      ),
    ));
  }

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
      appBar: AppBar(
        title: Text('Control de Gastos'),
      ),
      body: Center(
        child: Text('Página principal'), // Esto es solo un marcador de posición
      ),
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
