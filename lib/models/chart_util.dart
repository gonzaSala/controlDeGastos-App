import 'package:control_gastos/models/expenses_item.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

List<PieChartSectionData> getChartSections(List<Expense> expenses) {
  List<PieChartSectionData> sections = [];
  double totalExpenses =
      expenses.fold(0.0, (sum, expense) => sum + expense.cantidad);
  for (Expense expense in expenses) {
    double percentage = (expense.cantidad / totalExpenses);

    PieChartSectionData sectionData = PieChartSectionData(
      color: Colors.primaries[sections.length % Colors.primaries.length],
      value: percentage * 100,
      title: '${expense.name} ${percentage.toStringAsFixed(2)}%',
      radius: 0,
    );
    sections.add(sectionData);
  }
  return sections;
}
