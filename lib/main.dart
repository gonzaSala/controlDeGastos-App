import 'package:control_gastos/login_state.dart';
import 'package:control_gastos/screens/addPage.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/screens/homePage.dart';
import 'package:control_gastos/screens/loginPage.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:control_gastos/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments as DetailsParams;
            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailsPage(
                params: params,
              );
            });
          }
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLoggedIn()) {
              return HomePage();
            } else {
              return LoginPage();
            }
          },
          '/add': (BuildContext context) => AddPage(),
        },
      ),
    );
  }
}
