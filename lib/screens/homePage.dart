import 'package:control_gastos/widgets/graph_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _bottomAction(IconData icon) {
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
        notchMargin: 8.0,
        shape: CircularNotchedRectangle(),
        child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomAction(FontAwesomeIcons.clockRotateLeft),
              _bottomAction(FontAwesomeIcons.chartPie),
              SizedBox(
                width: 48.0,
              ),
              _bottomAction(FontAwesomeIcons.wallet),
              _bottomAction(Icons.settings),
            ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(children: <Widget>[
        _selector(),
        _expenses(),
        _graph(),
        Container(
          color: Colors.blueAccent.withOpacity(0.15),
          height: 14,
        ),
        _list()
      ]),
    );
  }
}

Widget _selector() => Container();
Widget _expenses() {
  return Column(
    children: <Widget>[
      Text(
        '\$2361,41',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 40.0,
        ),
      ),
      Text(
        'Total expenses',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.blueGrey,
        ),
      )
    ],
  );
}

Widget _graph() {
  return Container(height: 250.0, child: GraphWidget());
}

Widget _item(IconData icon, String name, int percent, double value) {
  return ListTile(
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
        itemCount: 15,
        itemBuilder: (BuildContext context, int index) =>
            _item(FontAwesomeIcons.cartShopping, 'Shopping', 14, 145.12),
        separatorBuilder: (BuildContext context, int index) {
          return Container(
            color: Colors.blueAccent.withOpacity(0.15),
            height: 4,
          );
        }),
  );
}
