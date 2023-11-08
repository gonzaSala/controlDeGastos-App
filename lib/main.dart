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
    0xFFFF0000, // Valor del color rojo
    <int, Color>{
      50: Color(0xFFFFEBEE), // Tono 50 (rojo claro)
      100: Color(0xFFFFCDD2), // Tono 100 (rojo claro)
      200: Color(0xFFEF9A9A), // Tono 200 (rojo claro)
      300: Color(0xFFE57373), // Tono 300 (rojo medio)
      400: Color(0xFFEF5350), // Tono 400 (rojo medio)
      500: Color(0xFFFF0000), // Tono 500 (rojo principal)
      600: Color(0xFFD32F2F), // Tono 600 (rojo oscuro)
      700: Color(0xFFC62828), // Tono 700 (rojo oscuro)
      800: Color(0xFFB71C1C), // Tono 800 (rojo oscuro)
      900: Color(0xFFA70404), // Tono 900 (rojo oscuro)
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
