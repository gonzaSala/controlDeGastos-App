class Expense {
  final String name;
  final double cantidad;
  final DateTime date;

  Expense({required this.name, required this.cantidad, required this.date});

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      name: json['name'] as String,
      cantidad: json['cantidad'] as double,
      date: DateTime.parse(json['date']
          as String), // Asumiendo que 'date' es una cadena de fecha válida
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cantidad': cantidad,
      'date': date.toIso8601String(), // Convertir la fecha a una cadena ISO8601
    };
  }
}
