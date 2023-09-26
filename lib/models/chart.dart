import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:control_gastos/models/expenses_item.dart';
import 'package:control_gastos/models/chart_util.dart';

class ChartPage extends StatelessWidget {
  final List<Expense> expenses;

  ChartPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    // Crear una lista de valores para cada día de la semana
    final List<double> weeklyExpenses = List.generate(7, (index) {
      final dayOfWeek =
          DateTime.now().subtract(Duration(days: 6 - index)).weekday;
      final totalForDay = expenses
          .where((expense) => expense.date.weekday == dayOfWeek)
          .fold(0.0, (sum, expense) => sum + expense.cantidad);
      return totalForDay;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Gráfico de Gastos por Día de la Semana'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: weeklyExpenses.reduce(
                    (value, element) => value > element ? value : element) +
                100, // Ajusta el valor máximo según tus necesidades
            titlesData: FlTitlesData(
              leftTitles: SideTitles(showTitles: true, reservedSize: 30),
              bottomTitles: SideTitles(
                showTitles: true,
                getTitles: (double value) {
                  // Mapea los valores a los días de la semana
                  switch (value.toInt()) {
                    case 0:
                      return 'Lun';
                    case 1:
                      return 'Mar';
                    case 2:
                      return 'Mié';
                    case 3:
                      return 'Jue';
                    case 4:
                      return 'Vie';
                    case 5:
                      return 'Sáb';
                    case 6:
                      return 'Dom';
                    default:
                      return '';
                  }
                },
                margin: 8,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: Border(
                bottom: BorderSide(
                  color: const Color(0xff37434d),
                  width: 1,
                ),
                left: BorderSide(
                  color: Colors.transparent,
                ),
                right: BorderSide(
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            barGroups: List.generate(
              7,
              (index) => BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    y: weeklyExpenses[index],
                    width: 16,
                    colors: Colors.accents,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
