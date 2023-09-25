import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:control_gastos/models/expenses_item.dart';
import 'package:control_gastos/models/chart_util.dart'; // Asegúrate de que la ruta sea correcta

class ChartPage extends StatelessWidget {
  final List<Expense> expenses;

  ChartPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Gastos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PieChart(
          PieChartData(
            sections:
                getChartSections(expenses), // Utiliza la función importada
            centerSpaceRadius: 40,
          ),
        ),
      ),
    );
  }
}
