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
  MaterialColor myCustomColor = MaterialColor(
    0xFF1C85FF, // Valor del color azul
    <int, Color>{
      50: Color(0xFFB3E0FF), // Tono 50
      100: Color(0xFF81C1FF), // Tono 100
      200: Color(0xFF4FA3FF), // Tono 200
      300: Color(0xFF1C85FF), // Tono 300
      400: Color(0xFF005FD1), // Tono 400
      500: Color(0xFF1B0087), // Tono 500 (Principal)
      600: Color(0xFF003E85), // Tono 600
      700: Color(0xFF002D6F), // Tono 700
      800: Color(0xFF001F5C), // Tono 800
      900: Color(0xFF001347), // Tono 900
    },
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(
          primarySwatch: myCustomColor,
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
