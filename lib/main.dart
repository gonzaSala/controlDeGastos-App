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
    0xFF1B0087, // Valor del color violeta
    <int, Color>{
      50: Color(0xFFD0BEF3), // Tono 50
      100: Color(0xFFB49BEB), // Tono 100
      200: Color(0xFF9878E3), // Tono 200
      300: Color(0xFF7C56DB), // Tono 300
      400: Color(0xFF6133D3), // Tono 400
      500: Color(0xFF8B6ED7), // Tono 500 (Principal)
      600: Color(0xFF4F0FD2), // Tono 600
      700: Color(0xFF3A00C4), // Tono 700
      800: Color(0xFF2800A7), // Tono 800
      900: Color(0xFF1B0087), // Tono 900
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
