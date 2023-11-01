import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieGraphWidget extends StatelessWidget {
  final List<double> data;

  const PieGraphWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        sections: List<PieChartSectionData>.generate(
          data.length,
          (index) {
            return PieChartSectionData(
              color: Color(0xff6A4DBA),
              value: data[index],
              title: data[index].toStringAsFixed(1),
            );
          },
        ),
        sectionsSpace: 0,
      ),
    );
  }
}

class LinesGraphWidget extends StatelessWidget {
  final List<double> data;

  const LinesGraphWidget({required this.data});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(show: false),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0xff37434d), width: 1),
        ),
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: 0,
        maxY:
            data.reduce((value, element) => value > element ? value : element) *
                1.5,
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            spots: List<FlSpot>.generate(data.length, (index) {
              return FlSpot(index.toDouble(), data[index]);
            }),
          ),
        ],
      ),
    );
  }
}
