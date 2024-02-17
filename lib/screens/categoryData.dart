import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CategoryData {
  static Map<String, IconData> categories = {};

  static List<CategoryIcon> getCategoryIcons() {
    return categories.entries
        .map((entry) => CategoryIcon(entry.key, entry.value))
        .toList();
  }

  static Future<void> loadCategoriesFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storedCategories = prefs.getString('categories') ?? '{}';
    Map<String, dynamic> savedCategories = json.decode(storedCategories);

    Map<String, IconData> defaultCategories = {
      'Otros': Icons.wallet,
      'Shopping': Icons.shopping_cart,
      'Comida': FontAwesomeIcons.burger,
      'Transporte': Icons.directions_bus_sharp,
      'Alcohol': FontAwesomeIcons.beerMugEmpty,
      'Salud': Icons.local_hospital_outlined,
      'Deudas': Icons.business_center_rounded,
      'Mascotas': Icons.pets_sharp,
      'Educación': Icons.school_rounded,
      'Ropa': FontAwesomeIcons.personDress,
      'Hogar': Icons.home,
    };

    categories = {
      ...defaultCategories,
      ...savedCategories
          .map((key, value) => MapEntry(key, iconFromString(value)))
    };
  }

  static IconData iconFromString(String iconString) {
    return IconData(int.parse(iconString), fontFamily: 'MaterialIcons');
  }

  static void addCategory(String name, IconData icon) {
    categories[name] = icon;
  }
}

class CategoryIcon {
  final String name;
  final IconData icon;

  CategoryIcon(this.name, this.icon);
}
