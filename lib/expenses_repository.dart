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
        .add({
      'category': categoryName,
      'value': value,
      'month': date.month,
      'day': date.day,
      'year': date.year,
      'details': details,
      'timestamp': DateTime.now(),
    });
  }
}
