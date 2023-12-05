import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/screens/addPage.dart';
import 'package:control_gastos/screens/detailsPageContainer.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/widgets/graph_widgett.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

enum GraphType { LINES, PIE }

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final int month;
  final String details;
  final GraphType graphType;
  final Map<String, IconData> categoryIcons;

  MonthWidget({
    Key? key,
    required this.documents,
    required days,
    required this.month,
    required this.graphType,
    required this.categoryIcons,
    required this.details,
  })  : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List<double>.generate(
          days,
          (index) {
            final dayDocuments =
                documents.where((doc) => doc['day'] == (index + 1));
            return dayDocuments.isEmpty
                ? 0.0
                : dayDocuments
                    .map((doc) => doc['value'])
                    .fold(0.0, (a, b) => a + b);
          },
        ),
        categories = documents.fold<Map<String, double>>({}, (map, document) {
          if (!map.containsKey(document['category'])) {
            map[document['category']] = 0.0;
          }
          map[document['category']] =
              (map[document['category']] ?? 0) + document['value'];
          return map;
        }),
        super(key: key);

  @override
  State<MonthWidget> createState() => _MonthWidgetState();
}

class _MonthWidgetState extends State<MonthWidget> {
  int selectedDay = 3;

  String selectedOption = 'optionMonth';
  List<int> daysInMonth = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    daysInMonth = List<int>.generate(lastDayOfMonth, (index) => index + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          if (selectedOption == 'optionMonth') _expensesMonth(),
          if (selectedOption == 'optionDay') _expensesDay(),
          if (selectedOption == 'optionDay') _daySelector(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.18),
            height: 14,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _popMenu() {
    return PopupMenuButton<String>(
      icon: Icon(Icons.keyboard_arrow_down_sharp, color: Colors.white),
      itemBuilder: (BuildContext context) => [
        PopupMenuItem<String>(
          value: 'optionMonth',
          child: Text('Mes'),
        ),
        PopupMenuItem<String>(
          value: 'optionDay',
          child: Text('Dia'),
        ),
      ],
      onSelected: (String value) {
        setState(() {
          selectedOption = value;
        });
      },
      offset: Offset(0, 40), // Ajusta la posición vertical del menú
      elevation: 4, // Sombra del menú emergente
      color: Colors.white, // Color de fondo del menú emergente
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
      ),
    );
  }

  Widget _expensesMonth() {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _popMenu(),
            SizedBox(
              width: 80,
            ),
            Text(
              'Total gastos del mes',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.blueGrey[300],
              ),
            ),
          ],
        ),
        Text(
          '\$${widget.total.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.blueGrey[200],
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _daySelector() {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Seleccionar día:',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(width: 10),
          DropdownButton<int>(
            value: selectedDay,
            items: daysInMonth.map((day) {
              return DropdownMenuItem<int>(
                value: day,
                child: Text(
                  day.toString(),
                  style: TextStyle(color: Colors.white),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedDay = value!;
              });
            },
            menuMaxHeight: 100,
            underline: Container(
              height: 2, // Altura de la línea de debajo del botón
              color: const Color.fromARGB(
                  127, 255, 255, 255), // Color de la línea de debajo del botón
            ),
            alignment: AlignmentDirectional.centerEnd,
            elevation: 15,
            padding: EdgeInsets.symmetric(horizontal: 2),
            style: TextStyle(
                color: const Color.fromARGB(
                    255, 23, 22, 22)), // Estilo del texto del botón
            dropdownColor: const Color.fromARGB(255, 33, 31, 31),
          ),
        ],
      ),
    );
  }

  Widget _expensesDay() {
    // Filtrar los documentos para obtener solo los del día seleccionado
    final dayDocuments =
        widget.documents.where((doc) => doc['day'] == selectedDay);

    // Calcular el total de gastos del día
    double totalExpensesDay =
        dayDocuments.map((doc) => doc['value']).fold(0.0, (a, b) => a + b);

    return Column(
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          _popMenu(),
          SizedBox(
            width: 80,
          ),
          Text(
            'Total gastos del día $selectedDay',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
              color: Colors.blueGrey[300],
            ),
          ),
        ]),
        Text(
          '\$${totalExpensesDay.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.blueGrey[200],
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 280.0,
            padding: EdgeInsets.all(10),
            child: LinesGraph(data: widget.perDay)),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 280.0,
            padding: EdgeInsets.all(5),
            child: PieGraphWidget(
              categoryPercentages: widget.categories,
              categoryIcons: widget.categoryIcons,
            )),
      );
    }
  }

  Widget _item(
      IconData icon, String name, int percent, double value, Color getColor) {
    if (name == null) {
      name = 'Otros';
    }

    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: DetailsParams(
              name,
              widget.month,
            ));
      },
      leading: Icon(
        icon,
        size: 32.0,
        color: getColor,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Color.fromARGB(255, 167, 186, 196),
        ),
      ),
      subtitle: Text(
        '$percent% of expenses',
        style: TextStyle(
          fontSize: 16,
          color: Color.fromARGB(255, 141, 155, 162),
        ),
      ),
      trailing: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.2),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '\$$value',
              style: TextStyle(
                color: const Color.fromARGB(255, 114, 163, 247),
                fontWeight: FontWeight.w500,
                fontSize: 18.0,
              ),
            ),
          )),
    );
  }

  List<Map<String, IconData>> categoryIcons = [
    {
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
    }
  ];

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];
          var categoryIcon =
              categoryIcons.firstWhere((element) => element.containsKey(key));
          var colorIcon = getColor(key);

          return _item(categoryIcon[key] ?? Icons.error, key,
              (100 * data! ~/ widget.total).toInt(), data, colorIcon);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Color.fromARGB(255, 39, 86, 168).withOpacity(0.18),
            height: 4,
          );
        },
      ),
    );
  }

  Color getColor(String categoryName) {
    // Implementación de colores dinámicos para cada categoría
    switch (categoryName) {
      case 'Otros':
        return const Color.fromARGB(
            255, 241, 111, 71); // Cambiado a un tono diferente de naranja
      case 'Shopping':
        return Colors.indigoAccent; // Cambiado a un tono diferente de índigo
      case 'Comida':
        return Colors.green; // Cambiado a un tono diferente de verde
      case 'Transporte':
        return Colors.amber; // Cambiado a un tono diferente de ámbar
      case 'Alcohol':
        return Colors.red; // Cambiado a un tono diferente de rojo
      case 'Salud':
        return Colors
            .tealAccent; // Cambiado a un tono diferente de verde azulado
      case 'Deudas':
        return Colors.purpleAccent; // Cambiado a un tono diferente de morado
      case 'Mascotas':
        return Colors.brown; // Cambiado a un tono diferente de marrón
      case 'Educación':
        return Colors.cyan; // Cambiado a un tono diferente de cian
      case 'Ropa':
        return Colors.pink; // Cambiado a un tono diferente de rosa
      case 'Hogar':
        return Colors.lightBlue; // Cambiado a un tono diferente de azul claro
      default:
        return Colors.grey;
    }
  }
}
