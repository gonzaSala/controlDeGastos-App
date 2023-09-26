import 'package:control_gastos/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:control_gastos/models/chart.dart';
import 'package:control_gastos/models/chart_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  void initState() {
    super.initState();
    // Cargar los gastos almacenados cuando se inicie la aplicación
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedExpenses = prefs.getStringList('expenses');

    if (savedExpenses != null) {
      setState(() {
        expenses = savedExpenses
            .map((expenseJson) =>
                Expense.fromJson(expenseJson as Map<String, dynamic>))
            .toList();
      });
    }
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expenseStrings =
        expenses.map((expense) => expense.toJson()).cast<String>().toList();
    await prefs.setStringList('expenses', expenseStrings);
  }

  void save() {
    final name = newExpenseControlName.text;
    final cantidad = double.tryParse(newExpenseControlCantidad.text) ?? 0.0;
    final date = DateTime.now();

    if (name.isNotEmpty && cantidad > 0) {
      expenses.add(Expense(name: name, cantidad: cantidad, date: date));
      saveExpenses();
      newExpenseControlName.clear();
      newExpenseControlCantidad.clear();
      Navigator.of(context).pop();
      setState(() {
        showChart = true;
      });
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
    newExpenseControlName.clear();
    newExpenseControlCantidad.clear();
    Navigator.of(context).pop();
  }

  double calculateTotalExpenses() {
    double total = 0.0;
    for (final expense in expenses) {
      total += expense.cantidad;
    }
    return total;
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
        child: Container(
          height:
              MediaQuery.of(context).size.height, // Establece una altura fija
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment:
                CrossAxisAlignment.center, // Centra verticalmente
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                '\$${calculateTotalExpenses().toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total gastos',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              return 
              if (showChart) buildChart(),
            ],
          ),
        ),
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
            bottomAction(FontAwesomeIcons.chartPie, toggleChart),
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

  List<Expense> getExpensesForCurrentDay() {
    final now = DateTime.now();
    return expenses.where((expense) {
      return expense.date.day == now.day &&
          expense.date.month == now.month &&
          expense.date.year == now.year;
    }).toList();
  }

  Widget buildChart() {
    final expensesForCurrentDay = getExpensesForCurrentDay();

    return PieChart(
      PieChartData(
        sections: getChartSections(expensesForCurrentDay),
        centerSpaceRadius: 40,
      ),
    );
  }

  bool showChart = false;

  void toggleChart() {
    setState(() {
      showChart = !showChart;
    });
    if (showChart) {
      // Navega a la página del gráfico cuando se muestra el gráfico
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChartPage(expenses: expenses),
        ),
      );
    }
    if (!showChart) {
      Navigator.of(context).pop();
    }
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
