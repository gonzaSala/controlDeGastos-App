import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';

class PieGraphWidget extends StatefulWidget {
  final List<double> data;

  const PieGraphWidget({super.key, required this.data});

  @override
  State<PieGraphWidget> createState() => _PieGraphWidgetState();
}

class _PieGraphWidgetState extends State<PieGraphWidget> {
  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
          id: 'Gasto',
          data: widget.data,
          domainFn: (value, index) => index!,
          measureFn: (value, _) => value,
          strokeWidthPxFn: (_, __) => 4),
    ];

    return PieChart(series);
  }
}

class LinesGraphWidget extends StatefulWidget {
  final List<double> data;

  const LinesGraphWidget({super.key, required this.data});
  @override
  _LinesGraphWidgetState createState() => _LinesGraphWidgetState();
}

class _LinesGraphWidgetState extends State<LinesGraphWidget> {
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    var time;
    final measures = <String, double>{};

    if (selectedDatum.isNotEmpty) {
      time = selectedDatum.first.datum;
      selectedDatum.forEach((SeriesDatum datumPair) {
        final displayName = datumPair.series.displayName ?? "Unknown";
        measures[displayName] = datumPair.datum;
      });
    }

    print(time);
    print(measures);
  }

  @override
  Widget build(BuildContext context) {
    List<Series<double, num>> series = [
      Series<double, int>(
          id: 'Gasto',
          colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
          data: widget.data,
          domainFn: (value, index) => index!,
          measureFn: (value, _) => value,
          strokeWidthPxFn: (_, __) => 4),
    ];

    return LineChart(
      series,
      animate: false,
      selectionModels: [
        SelectionModelConfig(
          type: SelectionModelType.info,
          changedListener: _onSelectionChanged,
        )
      ],
      domainAxis: NumericAxisSpec(
          tickProviderSpec: StaticNumericTickProviderSpec([
        TickSpec(0, label: '01'),
        TickSpec(4, label: '05'),
        TickSpec(9, label: '10'),
        TickSpec(14, label: '15'),
        TickSpec(19, label: '20'),
        TickSpec(24, label: '25'),
        TickSpec(29, label: '30'),
      ])),
      primaryMeasureAxis: NumericAxisSpec(
          tickProviderSpec: BasicNumericTickProviderSpec(
        desiredTickCount: 4,
      )),
    );
  }
}
