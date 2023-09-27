import 'package:flutter/material.dart';
import 'package:control_gastos/main.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.blue,
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
);

class PaginaDelGrafico extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Aquí puedes construir la interfaz de tu página de gráfico
    return Scaffold(
      appBar: AppBar(
        title: Text('Página del Gráfico'),
      ),
      body: Center(
        child: Text('Contenido del gráfico aquí'),
      ),
    );
  }
}
