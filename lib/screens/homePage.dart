import 'package:control_gastos/login_state.dart';
import 'package:control_gastos/widgets/graph_widget.dart';
import 'package:control_gastos/widgets/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _controller;
  int currentPage = 9;
  Stream<QuerySnapshot>? _query;

  _HomePageState() {
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
  }

  Widget _bottomAction(IconData icon, Function callback) {
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
            _bottomAction(FontAwesomeIcons.clockRotateLeft, () {}),
            _bottomAction(FontAwesomeIcons.chartPie, () {}),
            SizedBox(
              width: 48.0,
            ),
            _bottomAction(FontAwesomeIcons.wallet, () {}),
            _bottomAction(Icons.settings, () {
              Provider.of<LoginState>(context).logout();
            }),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        heroTag: 'add_button',
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('/add');
        },
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(children: <Widget>[
        _selector(),
        StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasData) {
                return MonthWidget(
                  documents: data.data?.docs ?? [],
                );
              }

              return Center(
                child: CircularProgressIndicator(),
              );
            }),
      ]),
    );
  }

  Widget _pageItem(String name, int position) {
    var _aligment;

    final selected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Colors.blueGrey,
    );

    final unselected = TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.normal,
      color: Colors.blueGrey.withOpacity(0.4),
    );

    if (position == currentPage) {
      _aligment = Alignment.center;
    } else if (position > currentPage) {
      _aligment = Alignment.centerRight;
    } else {
      _aligment = Alignment.centerLeft;
    }

    return Align(
        alignment: _aligment,
        child: Text(
          name,
          style: position == currentPage ? selected : unselected,
        ));
  }

  Widget _selector() {
    return SizedBox.fromSize(
      size: Size.fromHeight(70.0),
      child: PageView(
        onPageChanged: (newPage) {
          setState(() {
            currentPage = newPage;

            _query = FirebaseFirestore.instance
                .collection('expenses')
                .where('month', isEqualTo: currentPage + 1)
                .snapshots();
          });
        },
        controller: _controller,
        children: <Widget>[
          _pageItem('Enero', 0),
          _pageItem('Febrero', 1),
          _pageItem('Marzo', 2),
          _pageItem('Abril', 3),
          _pageItem('Mayo', 4),
          _pageItem('Junio', 5),
          _pageItem('Julio', 6),
          _pageItem('Agosto', 7),
          _pageItem('Septiembre', 8),
          _pageItem('Octubre', 9),
          _pageItem('Noviembre', 10),
          _pageItem('Diciembre', 11),
        ],
      ),
    );
  }
}
