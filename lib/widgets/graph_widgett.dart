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
      centerSpaceRadius: 100,
      sectionsSpace: 8,
      startDegreeOffset: 180,
      centerSpaceColor: const Color.fromARGB(0, 0, 0, 0),
    ));
  }

  List<PieChartSectionData> showingSections() {
    double totalPercentage = 0.0;
    double totalValue =
        widget.categoryPercentages.values.fold(0.0, (a, b) => a + b);

    return widget.categoryPercentages.keys.map((categoryName) {
      final IconData icon = widget.categoryIcons[categoryName] ?? Icons.error;
      final double value = widget.categoryPercentages[categoryName] ?? 0;

      double percentage = (value / totalValue) * 100;

      totalPercentage += percentage;

      return PieChartSectionData(
        value: percentage,
        color: getColor(categoryName),
        titlePositionPercentageOffset: BorderSide.strokeAlignOutside,
        title: '${percentage.toStringAsFixed(2)}%, ${categoryName}',
        radius: 30,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Color getColor(String categoryName) {
    switch (categoryName) {
      case 'Otros':
        return Colors.indigo;
      case 'Shopping':
        return Colors.purple;
      case 'Comida':
        return Colors.blueAccent;
      case 'Transporte':
        return Colors.deepPurple;
      case 'Alcohol':
        return Colors.blue;
      case 'Salud':
        return Colors.pinkAccent;
      case 'Deudas':
        return Colors.purpleAccent;
      case 'Mascotas':
        return Colors.blueGrey;
      case 'Educación':
        return Colors.teal;
      case 'Ropa':
        return Colors.deepPurpleAccent;
      case 'Hogar':
        return Colors.indigoAccent;
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
        backgroundColor: Color.fromARGB(176, 1, 3, 45),
        lineBarsData: [
          LineChartBarData(
              spots: flSpotList,
              curveSmoothness: 0.7,
              isCurved: true,
              barWidth: 0.5,
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
                    style: const TextStyle(
                        color: Color.fromARGB(255, 136, 136, 136),
                        fontSize: 14));
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 42,
              getTitlesWidget: (value, meta) {
                if (value < 1000) {
                  return Text(value.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontSize: 14));
                } else {
                  double text = value.toInt() / 1000;
                  return Text('${text.toStringAsFixed(1)}K',
                      style: const TextStyle(
                          color: Color.fromARGB(255, 136, 136, 136),
                          fontSize: 14));
                }
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(
          show: true,
          border:
              Border.all(color: Color.fromARGB(255, 136, 136, 136), width: 1),
        ),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
                color: const Color.fromARGB(255, 136, 136, 136),
                strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: const Color(0xff37434d), strokeWidth: 1);
          },
        ),
      ),
    );
  }
}
