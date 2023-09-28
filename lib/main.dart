import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:control_gastos/models/chart.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:control_gastos/models/expenses_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Control de Gastos',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void agregarDatosAFirestore() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Crea un documento en una colección llamada "gastos"
    await firestore.collection('gastos').add({
      'nombre': 'Ejemplo de gasto',
      'cantidad': 100.0,
      'fecha': Timestamp.now(),
    });

    print('Datos agregados a Firestore');
  }

  DateTime selectedMonth = DateTime.now();
  DateTime _currentDate = DateTime.now();
  double _dailyTotalExpenses = 0.0;
  bool showChart = false;
  Map<DateTime, List<Expense>> expenseHistory = {};
  TextEditingController newExpenseControlName = TextEditingController();
  TextEditingController newExpenseControlCantidad = TextEditingController();
  List<Expense> expenses = [];

  Future<void> addExpenseToFirestore(Expense expense) async {
    try {
      final collection = FirebaseFirestore.instance.collection('expenses');
      await collection.add({
        'name': expense.name,
        'cantidad': expense.cantidad,
        'date': expense.date,
      });
    } catch (e) {
      print('Error al agregar el gasto a Firestore: $e');
    }
  }

  void _resetDailyTotalExpenses() {
    final now = DateTime.now();
    if (_currentDate.year != now.year ||
        _currentDate.month != now.month ||
        _currentDate.day != now.day) {
      _currentDate = now;
      _dailyTotalExpenses = 0.0;
    }
  }

  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? savedExpenses = prefs.getStringList('expenses');

    if (savedExpenses != null) {
      setState(() {
        expenses = savedExpenses
            .map((expenseJson) =>
                Expense.fromJson(Map<String, dynamic>.from(expenseJson as Map)))
            .toList();
      });
    }
  }

  Future<void> saveExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> expenseStrings =
        expenses.map((expense) => json.encode(expense.toJson())).toList();
    await prefs.setStringList('expenses', expenseStrings);
    print(expenseStrings);
  }

  void save() {
    final name = newExpenseControlName.text;
    final cantidad = double.tryParse(newExpenseControlCantidad.text) ?? 0.0;
    final date = DateTime.now();

    if (name.isNotEmpty && cantidad > 0) {
      final expense = Expense(name: name, cantidad: cantidad, date: date);
      expenses.add(expense);
      addToExpenseHistory(expense);
      addExpenseToFirestore(expense);
      saveExpenses();
      newExpenseControlName.clear();
      newExpenseControlCantidad.clear();
      Navigator.of(context).pop();
      setState(() {
        _resetDailyTotalExpenses();
        showChart = false;
      });
    }
  }

  void addToExpenseHistory(Expense expense) {
    final date =
        DateTime(expense.date.year, expense.date.month, expense.date.day);
    if (expenseHistory.containsKey(date)) {
      expenseHistory[date]!.add(expense);
    } else {
      expenseHistory[date] = [expense];
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
                key: Key(expense.name),
                onDismissed: (direction) {
                  setState(() {
                    expenses.removeAt(index);
                    // Remove from expense history as well
                    final date = DateTime(
                      expense.date.year,
                      expense.date.month,
                      expense.date.day,
                    );
                    expenseHistory[date]?.remove(expense);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Se eliminó el gasto: ${expense.name}'),
                    ),
                  );
                  saveExpenses();
                },
                background: Container(
                  color: Colors.red,
                  child: Icon(FontAwesomeIcons.trash, color: Colors.white),
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
                        'Fecha: ${DateFormat('yyyy-MM-dd HH:mm:ss').format(expense.date)}',
                      ),
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

  @override
  void initState() {
    super.initState();
    loadExpenses();
    _resetDailyTotalExpenses();
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
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Text(
                '\$${_dailyTotalExpenses.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Total gastos diarios',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              Container(
                width: 400,
                height: 350,
                child: TableCalendar(
                  firstDay: DateTime.utc(2023, 1, 1),
                  lastDay: DateTime.utc(2023, 12, 31),
                  focusedDay: _currentDate,
                  calendarFormat: CalendarFormat.month,
                  calendarBuilders: CalendarBuilders(
                    todayBuilder: (context, date, events) {
                      // Define un color de fondo personalizado para los días
                      Color backgroundColor = Colors
                          .blue; // Cambia este color según tus preferencias
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape
                              .circle, // Haz que el fondo sea redondeado
                          color:
                              backgroundColor, // Establece el color de fondo personalizado
                        ),
                        child: Text(
                          date.day.toString(),
                          style: TextStyle(
                            fontSize:
                                18, // Ajusta el tamaño de fuente según tus preferencias
                            color: Colors
                                .white, // Cambia el color del texto según tus preferencias
                          ),
                        ),
                      );
                    },
                  ),
                  headerStyle: HeaderStyle(
                    titleCentered: true,
                    formatButtonVisible: false,
                  ),
                  onPageChanged: (newMonth) {
                    setState(() {
                      selectedMonth = newMonth;
                    });
                  },
                  selectedDayPredicate: (day) {
                    final date = DateTime(day.year, day.month, day.day);
                    return expenseHistory.containsKey(date);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _currentDate = selectedDay;
                    });
                  },
                ),
              ),
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
            const SizedBox(width: 122.0),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: Icon(Icons.brightness_6),
                    title: Text('Cambiar Tema'),
                    onTap: () {
                      _toggleTheme();
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        hoverColor: const Color.fromARGB(146, 0, 111, 166),
        child: const Icon(Icons.add),
        onPressed: addNewExpense,
      ),
    );
  }

  void toggleChart() {
    setState(() {
      showChart = !showChart;
    });
    if (showChart) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChartPage(expenses: expenses),
        ),
      );
    }
  }

  void _toggleTheme() {
    setState(() {
      if (Theme.of(context).brightness == Brightness.light) {
        ThemeMode _themeMode = ThemeMode.dark;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
      } else {
        ThemeMode _themeMode = ThemeMode.light;
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
      }
    });
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

  void cancel() {
    newExpenseControlName.clear();
    newExpenseControlCantidad.clear();
    Navigator.of(context).pop();
  }
}
