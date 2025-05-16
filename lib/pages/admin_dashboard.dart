import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quizapp/models/categories_model.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final List<CategoriesModel> categories = CategoriesModel.getCategories();

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context), body: categoriesChoose());
  }

  Padding categoriesChoose() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return Container(
            alignment: AlignmentDirectional.centerStart,
            margin: EdgeInsets.only(bottom: 20),
            height: 120,
            decoration: BoxDecoration(
              color: category.boxColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: ListTile(
              leading: SvgPicture.asset(
                category.icon,
                width: 40,
                height: 40,
                color: Colors.black,
              ),
              title: Text(
                category.name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                if (category.name == 'Create Question') {
                  Navigator.pushNamed(context, '/createQuestion');
                } else if (category.name == 'Monitor Result') {
                  Navigator.pushNamed(context, '/monitorResult');
                } else if (category.name == 'Add Student') {
                  Navigator.pushNamed(context, '/addStudent');
                } else if (category.name == 'Delete Question') {
                  Navigator.pushNamed(context, '/deleteQuestion');
                }
              },
            ),
          );
        },
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Admin Dashboard",
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 0.0,
      leading: GestureDetector(
        onTap: () {
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/right-from-bracket-solid.svg'),
        ),
      ),
    );
  }
}
