import 'package:flutter/material.dart';

class CategorySelectorWidget extends StatefulWidget {
  final Map<String, IconData> categories;
  final Function(String) onValueChanged;
  final Function(String name, IconData icon) addCategory;

  const CategorySelectorWidget(
      {super.key,
      required this.categories,
      required this.onValueChanged,
      required this.addCategory});

  @override
  State<CategorySelectorWidget> createState() => _CategorySelectorWidgetState();
}

class CategoryWidget extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool selected;

  CategoryWidget(
      {super.key,
      required this.name,
      required this.icon,
      required this.selected});
  @override
  Widget build(BuildContext context) {
    //  double height = MediaQuery.of(context).size.height * 0.15;

    return Container(
      width: 80,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: 65,
              height: 55, // height,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: selected
                        ? Color.fromARGB(149, 111, 75, 122)
                        : Color.fromARGB(72, 74, 74, 81),
                    width: selected ? 4.0 : 5.0,
                  )),
              child: Icon(
                icon,
                size: 34,
                color: getColor(name),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 6),
              child: Text(
                name,
                style: TextStyle(
                    color: Color.fromARGB(255, 195, 191, 254), fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
      return Colors.white70;
  }
}

class _CategorySelectorWidgetState extends State<CategorySelectorWidget> {
  String currentItem = '';
  @override
  Widget build(BuildContext context) {
    var widgets = <Widget>[];

    widget.categories.forEach((name, icon) {
      widgets.add(GestureDetector(
        onTap: () {
          setState(() {
            currentItem = name;
          });
          widget.onValueChanged(name);
        },
        child: CategoryWidget(
          name: name,
          icon: icon,
          selected: name == currentItem,
        ),
      ));
    });
    return SafeArea(
      right: true,
      left: true,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: widgets,
      ),
    );
  }
}
