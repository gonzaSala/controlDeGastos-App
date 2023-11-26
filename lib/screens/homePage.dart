import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/util.dart';
import 'package:control_gastos/widgets/month_widget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:control_gastos/notification_services.dart';
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
  int currentPage = DateTime.now().month - 1;
  Stream<QuerySnapshot>? _query;
  GraphType currentType = GraphType.LINES;

  _HomePageState() {
    _controller = PageController(
      initialPage: currentPage,
      viewportFraction: 0.4,
    );
    final notificationService = NotificationServices();
    notificationService.initNotifications();
  }

  Widget _bottomAction(IconData icon, Function callback) {
    return InkWell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Icon(
          icon,
          color: Colors.white60,
        ),
      ),
      highlightColor: Colors.yellow,
      borderRadius: BorderRadius.all(Radius.circular(10)),
      onTap: () {
        callback();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<expensesRepository>(
      builder: (BuildContext context, expensesRepository db, Widget? child) {
        var user = Provider.of<LoginState>(context).currentUser();

        _query = db.queryByMonth(currentPage + 1);

        return Scaffold(
          bottomNavigationBar: BottomAppBar(
            notchMargin: 8.0,
            color: Color.fromARGB(255, 19, 15, 78),
            shape: CircularNotchedRectangle(),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _bottomAction(FontAwesomeIcons.chartLine, () {
                  setState(() {
                    currentType = GraphType.LINES;
                    print('grafico line');
                  });
                }),
                _bottomAction(FontAwesomeIcons.chartPie, () {
                  setState(() {
                    currentType = GraphType.PIE;
                    print('grafico pie');
                  });
                }),
                SizedBox(
                  width: 48.0,
                ),
                _bottomAction(Icons.plus_one, () {
                  setState(() {
                    _showInviteDialog(context);
                  });
                }),
                _bottomAction(Icons.exit_to_app_rounded, () {
                  Provider.of<LoginState>(context, listen: false).logout();
                }),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            heroTag: 'add_button',
            child: Icon(Icons.add),
            backgroundColor: Color.fromARGB(255, 50, 2, 123),
            onPressed: () {
              Navigator.of(context).pushNamed('/add');
            },
          ),
          body: _body(),
        );
      },
    );
  }

  Widget _body() {
    return SafeArea(
      child: Column(
        children: <Widget>[
          _selector(),
          StreamBuilder<QuerySnapshot>(
            stream: _query,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> data) {
              if (data.hasError) {
                return Text('Error: ${data.error}');
              }

              if (data.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (data.data == null || data.data!.docs.isEmpty) {
                return Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'No hay gastos para mostrar.',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(height: 80),
                    Image.asset(
                      'assets/nothing.png',
                    ),
                  ],
                ));
              }

              return MonthWidget(
                days: daysInMonth(currentPage + 1),
                documents: data.data?.docs ?? [],
                month: currentPage + 1,
                graphType: currentType,
                categoryIcons: {},
                details: data.data?.docs[0]['details'],
              );
            },
          ),
        ],
      ),
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

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String email =
            ''; // Variable para almacenar el correo electrónico ingresado

        return AlertDialog(
          title: Text('Invitar a alguien'),
          content: Column(
            children: [
              Text(
                  'Ingrese el correo electrónico de la persona que desea invitar:'),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  email =
                      value; // Actualiza la variable con el correo electrónico ingresado
                },
                decoration: InputDecoration(
                  hintText: 'Correo electrónico',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el cuadro de diálogo
              },
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                await Provider.of<LoginState>(context, listen: false)
                    .addUser(email);
                print('Invitar a: $email');
              },
              child: Text('Enviar invitación'),
            ),
          ],
        );
      },
    );
  }
}
