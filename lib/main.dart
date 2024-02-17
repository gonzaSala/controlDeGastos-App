import 'dart:convert';

import 'package:control_gastos/expenses_repository.dart';
import 'package:control_gastos/firebase_Api.dart';
import 'package:control_gastos/screens/categoryData.dart';
import 'package:control_gastos/screens/detailsPageContainer.dart';
import 'package:control_gastos/screens/settingScreen.dart';
import 'package:control_gastos/screens/ui/backgroundTheme.dart';
import 'package:control_gastos/states/login_state.dart';
//import 'package:control_gastos/notification_services.dart';
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
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _loadDefaultCategories();

  await FirebaseApi().initNotifications();

  runApp(MyApp());
}

Future<void> _loadDefaultCategories() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('categories')) {
    Map<String, dynamic> defaultCategories = {
      'Otros': Icons.wallet.codePoint,
      'Shopping': Icons.shopping_cart.codePoint,
      'Comida': FontAwesomeIcons.burger.codePoint,
      'Transporte': Icons.directions_bus_sharp.codePoint,
      'Alcohol': FontAwesomeIcons.beerMugEmpty.codePoint,
      'Salud': Icons.local_hospital_outlined.codePoint,
      'Deudas': Icons.business_center_rounded.codePoint,
      'Mascotas': Icons.pets_sharp.codePoint,
      'Educación': Icons.school_rounded.codePoint,
      'Ropa': FontAwesomeIcons.personDress.codePoint,
      'Hogar': Icons.home.codePoint,
    };

    prefs.setString('categories', json.encode(defaultCategories));
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<FirebaseApi>(
          create: (context) => FirebaseApi(),
        ),
        //  ChangeNotifierProvider(
        //     create: (context) => NotificationState(),
        //   ),
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
        theme: ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: AppBarTheme(
            backgroundColor: Color.fromARGB(126, 135, 135, 135),
          ),
          textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
          brightness: Brightness.dark,
          primaryColor: Color.fromARGB(255, 255, 255, 255),
          secondaryHeaderColor: Color.fromARGB(255, 70, 75, 73),
        ),
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),
        onGenerateRoute: (settings) {
          if (settings.name == '/details') {
            DetailsParams params = settings.arguments as DetailsParams;
            return MaterialPageRoute(builder: (BuildContext context) {
              return DetailsPageContainer(
                params: params,
              );
            });
          }
        },
        home: BackgroundContainerObscure(
          child: Stack(
            children: [
              Builder(
                builder: (context) {
                  var loginState = Provider.of<LoginState>(context);
                  print('isLoggedIn: ${loginState.isLoggedIn()}');

                  if (loginState.isLoggedIn()) {
                    print('Building HomePage');
                    return HomePage();
                  } else {
                    print('Building LoginPage');
                    return loginState.isUserExisting()
                        ? AlertDialog(
                            title: Text('Error de inicio de sesión'),
                            content: Text(
                                'No se pudo iniciar sesión, verifique los datos'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/groupLogin');
                                },
                                child: Text('OK'),
                              ),
                            ],
                          )
                        : LoginPage();
                  }
                },
              ),
            ],
          ),
        ),
        routes: {
          '/homePage': (BuildContext context) => BackgroundContainerObscure(
                child: HomePage(),
              ),
          '/loginPage': (BuildContext context) => BackgroundContainerObscure(
                child: LoginPage(),
              ),
          '/add': (BuildContext context) => BackgroundContainerObscure(
                child: AddPage(),
              ),
          '/groupLogin': (BuildContext context) => BackgroundContainerObscure(
                child: groupLogin(),
              ),
          '/settings': (BuildContext context) => BackgroundContainerObscure(
                child: Settings(),
              ),
        },
      ),
    );
  }
}
