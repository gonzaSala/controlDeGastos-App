import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/screens/addPage.dart';
import 'package:control_gastos/widgets/graph_widgett.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum GraphType { LINES, PIE }

class MonthWidget extends StatefulWidget {
  final List<DocumentSnapshot> documents;
  final double total;
  final List<double> perDay;
  final Map<String, double> categories;
  final int month;
  final GraphType graphType;
  final Map<String, IconData> categoryIcons;

  MonthWidget(
      {Key? key,
      required this.documents,
      required days,
      required this.month,
      required this.graphType,
      required this.categoryIcons})
      : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List<double>.generate(
          days,
          (index) {
            final dayDocuments =
                documents.where((doc) => doc['day'] == (index + 1));
            return dayDocuments.isEmpty
                ? 0.0 // No hay documentos para este día
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: <Widget>[
          _expenses(),
          _graph(),
          Container(
            color: Colors.blueAccent.withOpacity(0.18),
            height: 14,
          ),
          _list()
        ],
      ),
    );
  }

  Widget _expenses() {
    return Column(
      children: <Widget>[
        Text(
          'Total gastos',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          '\$${widget.total.toStringAsFixed(2)}',
          style: TextStyle(
            color: Colors.blueGrey,
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
            arguments: DetailsParams(name, widget.month));
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
          color: const Color.fromARGB(255, 116, 151, 168),
        ),
      ),
      subtitle: Text(
        '$percent% of expenses',
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
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
                color: Colors.blueAccent,
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
        return Colors.indigo; // Puedes cambiarlo a un tono diferente de azul
      case 'Shopping':
        return Colors.purple; // Puedes cambiarlo a un tono diferente de morado
      case 'Comida':
        return Colors
            .blueAccent; // Puedes cambiarlo a un tono diferente de azul
      case 'Transporte':
        return Colors
            .deepPurple; // Puedes cambiarlo a un tono diferente de morado
      case 'Alcohol':
        return Colors.blue; // Puedes cambiarlo a un tono diferente de azul
      case 'Salud':
        return Colors
            .pinkAccent; // Puedes cambiarlo a un tono diferente de rosado
      case 'Deudas':
        return Colors
            .purpleAccent; // Puedes cambiarlo a un tono diferente de morado
      case 'Mascotas':
        return Colors
            .blueGrey; // Puedes cambiarlo a un tono diferente de gris/azul
      case 'Educación':
        return Colors
            .teal; // Puedes cambiarlo a un tono diferente de verde azulado
      case 'Ropa':
        return Colors
            .deepPurpleAccent; // Puedes cambiarlo a un tono diferente de morado
      case 'Hogar':
        return Colors
            .indigoAccent; // Puedes cambiarlo a un tono diferente de azul
      default:
        return Colors.grey;
    }
  }
}
