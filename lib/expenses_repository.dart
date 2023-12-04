import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class expensesRepository {
  final String? userId;

  expensesRepository({required this.userId});

  Stream<QuerySnapshot> queryByCategory(int month, String categoryName) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .where('month', isEqualTo: month)
        .where('category', isEqualTo: categoryName)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByMonth(int month) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .where('month', isEqualTo: month)
        .snapshots();
  }

  Stream<QuerySnapshot> queryByDay(int day) {
    return FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .where('day', isEqualTo: day)
        .snapshots();
  }

  delete(String documentId) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .doc(documentId)
        .delete();
  }

  add(
    String categoryName,
    String details,
    int value,
    DateTime date,
  ) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .doc(
            '${date.year}-${date.month}') // Utiliza el año y el número del mes en el ID de la colección
        .collection(
            'items') // Puedes agregar una subcolección 'items' para los gastos individuales
        .add({
      'category': categoryName,
      'value': value,
      'month': date.month,
      'day': date.day,
      'year': date.year,
      'details': details,
      'timestamp': DateTime.now(), // Puedes agregar un campo de marca de tiempo
    });
  }

  _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Enero';
      case 2:
        return 'Febrero';
      case 3:
        return 'Marzo';
      case 4:
        return 'Abril';
      case 5:
        return 'Mayo';
      case 6:
        return 'Junio';
      case 7:
        return 'Julio';
      case 8:
        return 'Agosto';
      case 9:
        return 'Septiembre';
      case 10:
        return 'Octubre';
      case 11:
        return 'Noviembre';
      case 12:
        return 'Diciembre';
      default:
        return 'Otros';
    }
  }

  Future<double> sumExpensesLastMonth() async {
    var now = DateTime.now();
    var startOfCurrentMonth = DateTime(now.year, now.month, 1);
    var startOfLastMonth = DateTime(now.year, now.month - 1, 1);

    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('user')
          .doc(userId)
          .collection('expenses')
          .where('timestamp', isGreaterThanOrEqualTo: startOfLastMonth)
          .where('timestamp', isLessThan: startOfCurrentMonth)
          .get();

      double total = 0;
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        double amount = doc['value'] ?? 0;
        total += amount;
      }

      return total;
    } catch (e) {
      print('Error al sumar gastos del último mes: $e');
      return 0.0; // Retorna 0 en caso de error
    }
  }
}
