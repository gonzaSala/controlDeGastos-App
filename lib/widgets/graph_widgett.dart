import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class PieGraphWidget extends StatefulWidget {
  final Map<String, double> categoryPercentages;
  final Map<String, IconData> categoryIcons;

  const PieGraphWidget({
    Key? key,
    required this.categoryPercentages,
    required this.categoryIcons,
  }) : super(key: key);

  @override
  _PieGraphWidgetState createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  @override
  Widget build(BuildContext context) {
    return PieChart(PieChartData(
      sections: showingSections(),
      centerSpaceRadius: 0,
      sectionsSpace: 2,
      startDegreeOffset: 180,
      centerSpaceColor: Colors.grey[200],
    ));
  }

  List<PieChartSectionData> showingSections() {
    return widget.categoryPercentages.keys.map((categoryName) {
      final IconData icon = widget.categoryIcons[categoryName] ?? Icons.error;
      final double value = widget.categoryPercentages[categoryName]! / 10 ?? 0;
      return PieChartSectionData(
        value: value,
        color: getColor(categoryName),
        title: '${value.toStringAsFixed(2)}%',
        radius: 100,
        titleStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color getColor(String categoryName) {
    // Implementación de colores dinámicos para cada categoría
    switch (categoryName) {
      case 'Otros':
        return Colors.blue;
      case 'Shopping':
        return Colors.deepOrange;
      case 'Comida':
        return Colors.green;
      case 'Transporte':
        return Colors.orange;
      case 'Alcohol':
        return Colors.amber;
      case 'Salud':
        return Colors.red;
      case 'Deudas':
        return Colors.purple;
      case 'Mascotas':
        return Colors.brown;
      case 'Educación':
        return Colors.indigo;
      case 'Ropa':
        return Colors.pink;
      case 'Hogar':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }
}

class LinesGraph extends StatefulWidget {
  const LinesGraph({super.key, required this.data});
  final List<double> data;

  @override
  State<LinesGraph> createState() => LinesGraphState();
}

class LinesGraphState extends State<LinesGraph> {
  final List<Color> gradientColor = [
    const Color(0xff23b6e6),
    const Color(0xff02d439a),
  ];

  @override
  Widget build(BuildContext context) {
    List<FlSpot> flSpotList = widget.data.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value);
    }).toList();

    return LineChart(
      LineChartData(
        backgroundColor: Color(0xFF01032D),
        lineBarsData: [
          LineChartBarData(
              spots: flSpotList,
              isCurved: true,
              barWidth: 2,
              isStepLineChart: false,
              belowBarData: BarAreaData(
                  show: true,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment(0.8, 1),
                    colors: <Color>[
                      Color(0xff1f005c),
                      Color(0xff5b0060),
                      Color(0xff870160),
                      Color(0xffac255e),
                      Color(0xffca485c),
                      Color(0xffe16b5c),
                      Color(0xfff39060),
                      Color(0xffffb56b),
                    ],
                  )),
              preventCurveOverShooting: true,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xff1f005c),
                  Color(0xff5b0060),
                  Color(0xff870160),
                  Color(0xffac255e),
                  Color(0xffca485c),
                  Color(0xffe16b5c),
                  Color(0xfff39060),
                  Color(0xffffb56b),
                ],
              ) // Gradient from https:/            barWidth: 3.5,
              ),
        ],
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 16,
              interval: 1,
              getTitlesWidget: (value, meta) {
                String text = '';
                switch (value.toInt()) {
                  case 0:
                    text = '01';
                    break;
                  case 4:
                    text = '05';
                    break;
                  case 9:
                    text = '10';
                    break;
                  case 14:
                    text = '15';
                    break;
                  case 19:
                    text = '20';
                    break;
                  case 24:
                    text = '25';
                    break;
                  case 29:
                    text = '30';
                    break;
                  default:
                    break;
                }
                return Text(text,
                    style: const TextStyle(color: Colors.black, fontSize: 14));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: Color(0xff37434d), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
          },
          horizontalInterval: 100,
          verticalInterval: 1,
        ),
      ),
    );
  }
}
