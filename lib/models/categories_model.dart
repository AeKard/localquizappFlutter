import 'package:flutter/material.dart';

class CategoriesModel {
  String name;
  String icon;
  Color boxColor;
  String route;

  CategoriesModel({
    required this.name,
    required this.icon,
    required this.boxColor,
    required this.route,
  });

  static List<CategoriesModel> getCategories() {
    List<CategoriesModel> categories = [];
    categories.add(
      CategoriesModel(
        name: 'Create Question',
        icon: 'assets/icons/pen-to-square-solid.svg',
        boxColor: Colors.white,
        route: '/createQuestion',
      ),
    );
    categories.add(
      CategoriesModel(
        name: 'Monitor Result',
        icon: 'assets/icons/chart-column-solid.svg',
        boxColor: Colors.white,
        route: '/monitorResult',
      ),
    );
    categories.add(
      CategoriesModel(
        name: 'Add Student',
        icon: 'assets/icons/user-plus-solid.svg',
        boxColor: Colors.white,
        route: '/addStudent',
      ),
    );
    categories.add(
      CategoriesModel(
        name: 'Delete Question',
        icon: 'assets/icons/trash-solid.svg',
        boxColor: Colors.white,
        route: '/deleteQuestion',
      ),
    );
    return categories;
  }
}
