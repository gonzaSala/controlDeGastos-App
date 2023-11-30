import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/states/login_state.dart';
import 'package:control_gastos/notification_services.dart';
import 'package:control_gastos/screens/addPage.dart';
import 'package:control_gastos/screens/detailsPage.dart';
import 'package:control_gastos/screens/groupLogin.dart';
import 'package:control_gastos/screens/homePage.dart';
import 'package:control_gastos/screens/loginPage.dart';
import 'package:control_gastos/states/theme_state.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:control_gastos/firebase_options.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final notificationService = NotificationServices();
  notificationService.initNotifications();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeState>(
          create: (_) => ThemeState(),
        ),
        ChangeNotifierProvider<LoginState>(
          create: (BuildContext context) => LoginState(),
        ),
        ProxyProvider<LoginState, expensesRepository>(
          update: (_, LoginState value, __) {
            if (value.isLoggedIn() && value.currentUser() != null) {
              print('currentUser: ${value.currentUser()}');
              return expensesRepository(userId: value.currentUser()!.uid);
            }
            return expensesRepository(userId: '');
          },
        ),
      ],
      child: MaterialApp(
        title: 'Material App',
        theme: ThemeData(
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.black,
          primarySwatch: Colors.deepPurple,
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments as DetailsParams;
            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailsPageConteiner(
                params: params,
              );
            });
          }
        },
        routes: {
          '/': (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            print('isLoggedIn: ${state.isLoggedIn()}');
            if (state.isLoggedIn()) {
              print('Building HomePage');

              return HomePage();
            } else {
              print('Building LoginPage');

              return LoginPage();
            }
          },
          '/add': (BuildContext context) => AddPage(),
          '/groupLogin': (BuildContext context) => groupLogin(),
        },
      ),
    );
  }
}
