import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class expensesRepository {
  final String? userId;
  String? _profileImageUrl;

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

  Future<void> resetApp() async {
    try {
      await _deleteCollection('user/$userId/expenses');
      print('Firestore reset successful');
    } catch (e) {
      print('Error resetting Firestore: $e');
    }
  }

  Future<void> _deleteCollection(String collectionPath) async {
    var collectionRef = FirebaseFirestore.instance.collection(collectionPath);
    var snapshots = await collectionRef.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteMonthCurrent() async {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    final expensesSnapshot = await FirebaseFirestore.instance
        .collection('user')
        .doc(userId)
        .collection('expenses')
        .where('month', isEqualTo: currentMonth)
        .where('year', isEqualTo: currentYear)
        .get();

    for (var doc in expensesSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<String> uploadProfileImage(File imageFile) async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String path = 'user/$userId/profile/avatar.png';

      final storageReference = FirebaseStorage.instance.ref().child(path);
      await storageReference.putFile(imageFile);

      String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error al subir la imagen al almacenamiento: $e');
      throw e;
    }
  }

  Future<String?> getProfileImageUrl() async {
    try {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      String path = 'user/$userId/profile/avatar.png';

      final storageReference = FirebaseStorage.instance.ref().child(path);
      String imageUrl = await storageReference.getDownloadURL();

      return imageUrl;
    } catch (e) {
      print('Error al obtener la URL de la imagen del almacenamiento: $e');
      return null;
    }
  }
}
