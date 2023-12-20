import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CategoryData {
  static Map<String, IconData> categories = {
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

  static List<CategoryIcon> getCategoryIcons() {
    return categories.entries
        .map((entry) => CategoryIcon(entry.key, entry.value))
        .toList();
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
