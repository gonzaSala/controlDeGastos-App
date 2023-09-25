import 'package:control_gastos/models/expenses_item.dart';
import 'package:flutter/material.dart';

class ExpenseListPage extends StatelessWidget {
  final List<Expense> expenses;

  ExpenseListPage({required this.expenses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Gastos'),
      ),
      body: ListView.builder(
        itemCount: expenses.length,
        itemBuilder: (context, index) {
          final expense = expenses[index];
          return ListTile(
            title: Text(expense.name),
            subtitle: Text('\$${expense.cantidad.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
