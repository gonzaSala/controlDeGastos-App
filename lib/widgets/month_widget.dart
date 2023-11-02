import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/widgets/graph_widget.dart';
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

  MonthWidget(
      {Key? key,
      required this.documents,
      required days,
      required this.month,
      required this.graphType})
      : total = documents.map((doc) => doc['value']).fold(0.0, (a, b) => a + b),
        perDay = List.generate(days, (int index) {
          return documents
              .where((doc) => doc['day'] == (index + 1))
              .map((doc) => doc['value'])
              .fold(0.0, (a, b) => a + b);
        }),
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
            fontWeight: FontWeight.bold,
            fontSize: 40.0,
          ),
        ),
      ],
    );
  }

  Widget _graph() {
    if (widget.graphType == GraphType.LINES) {
      return Container(
          height: 250.0, child: LinesGraphWidget(data: widget.perDay));
    } else {
      print('grafico pie');
      var perCategory = widget.categories.keys
          .map((name) => widget.categories[name]! / widget.total)
          .toList();
      return Container(height: 250.0, child: PieGraphWidget(data: perCategory));
    }
  }

  Widget _item(IconData icon, String name, int percent, double value) {
    return ListTile(
      onTap: () {
        Navigator.of(context).pushNamed('/details',
            arguments: DetailsParams(name, widget.month));
      },
      leading: Icon(
        icon,
        size: 32.0,
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
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

  Widget _list() {
    return Expanded(
      child: ListView.separated(
        itemCount: widget.categories.keys.length,
        itemBuilder: (BuildContext context, int index) {
          var key = widget.categories.keys.elementAt(index);
          var data = widget.categories[key];

          // Obtén el ícono correspondiente a la categoría
          var categoryIcon = widget.categories[key];

          return _item(categoryIcon as IconData, key,
              (100 * data! ~/ widget.total).toInt(), data);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 4,
          );
        },
      ),
    );
  }
}
