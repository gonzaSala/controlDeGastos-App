import 'dart:ffi';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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
              barWidth: 6,
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
