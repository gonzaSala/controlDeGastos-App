import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:control_gastos/screens/detailsPageContainer.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/widgets/graph_widgett.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';

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

class _MonthWidgetState extends State<MonthWidget>
    with SingleTickerProviderStateMixin {
  int selectedDay = DateTime.now().day;

  String selectedOption = 'optionMonth';
  List<int> daysInMonth = [];

  late AnimationController controller;
  late Animation<double> animation;
  bool isRotated = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final lastDayOfMonth = DateTime(now.year, now.month + 1, 0).day;
    daysInMonth = List<int>.generate(lastDayOfMonth, (index) => index + 1);
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    animation = Tween<double>(
      begin: 0,
      end: 0.25,
    ).animate(controller);
    CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          if (selectedOption == 'optionMonth') _expensesMonth(),
          if (selectedOption == 'optionDay') _expensesDay(),
          SizedBox(
            height: 10,
          ),
          if (selectedOption == 'optionDay') _daySelector(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.12),
            height: 7,
          ),
          _list(),
        ],
      ),
    );
  }

  Widget _popMenu() {
    return PopupMenuButton<String>(
      icon: RotationTransition(
        turns: animation,
        child: Icon(Icons.arrow_forward_ios),
      ),
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
      onCanceled: () {
        setState(() {
          isRotated = !isRotated;

          if (isRotated) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      },
      onOpened: () {
        setState(() {
          isRotated = !isRotated;

          if (isRotated) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      },
      onSelected: (String value) {
        setState(() {
          selectedOption = value;

          isRotated = !isRotated;

          selectedOption = value;
          if (isRotated) {
            controller.forward();
          } else {
            controller.reverse();
          }
        });
      },
      offset: Offset(0, 40),
      elevation: 8,
      shape: BeveledRectangleBorder(
        side: BorderSide(
            color: const Color.fromARGB(125, 255, 255, 255), width: 1),
        borderRadius: BorderRadius.all(Radius.elliptical(8, 5)),
      ),
      shadowColor: const Color.fromARGB(255, 255, 255, 255),
      color: Color.fromARGB(255, 239, 224, 255),
    );
  }

  Widget _expensesMonth() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(49, 255, 255, 255), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(40, 37, 51, 130)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _popMenu(),
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
          AnimatedTextKit(
            totalRepeatCount: 1,
            animatedTexts: [
              TypewriterAnimatedText(
                '\$${widget.total.toStringAsFixed(2)}',
                textStyle: TextStyle(
                    color: Colors.blueGrey[200],
                    fontWeight: FontWeight.bold,
                    fontSize: 40.0),
                curve: Curves.easeInOut,
                speed: Duration(milliseconds: 150),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _daySelector() {
    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(49, 255, 255, 255), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(239, 2, 8, 47)),
      child: Padding(
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
              borderRadius: BorderRadius.circular(30),
              menuMaxHeight: 200,
              underline: Container(
                height: 2,
                color: const Color.fromARGB(127, 255, 255, 255),
              ),
              alignment: AlignmentDirectional.center,
              elevation: 15,
              padding: EdgeInsets.symmetric(horizontal: 2),
              style: TextStyle(color: const Color.fromARGB(255, 23, 22, 22)),
              dropdownColor: Color.fromARGB(211, 21, 21, 21),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expensesDay() {
    final dayDocuments =
        widget.documents.where((doc) => doc['day'] == selectedDay);

    double totalExpensesDay =
        dayDocuments.map((doc) => doc['value']).fold(0.0, (a, b) => a + b);

    return Container(
      padding: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border:
              Border.all(color: Color.fromARGB(49, 255, 255, 255), width: 1),
          borderRadius: BorderRadius.circular(10),
          color: Color.fromARGB(40, 37, 51, 130)),
      child: Column(
        children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            _popMenu(),
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
                fontSize: 40.0),
          )
        ],
      ),
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

    return Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Color.fromARGB(42, 101, 94, 234),
      ),
      child: ListTile(
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
      ),
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
        return Colors.indigo;
      case 'Shopping':
        return Colors.purple;
      case 'Comida':
        return Colors.blueAccent;
      case 'Transporte':
        return Color.fromARGB(255, 147, 91, 242);
      case 'Alcohol':
        return Colors.blue;
      case 'Salud':
        return Colors.pinkAccent;
      case 'Deudas':
        return Colors.purpleAccent;
      case 'Mascotas':
        return Colors.blueGrey;
      case 'Educación':
        return Colors.teal;
      case 'Ropa':
        return Colors.deepPurpleAccent;
      case 'Hogar':
        return Colors.indigoAccent;
      default:
        return Colors.grey;
    }
  }
}
