import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/models/user_model.dart';
import 'package:quizapp/studentPage/quiz_screen_state.dart';
import 'package:quizapp/studentPage/view_result.dart';
import 'package:flutter_svg/svg.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});
  Future<void> _loadUser(BuildContext context) async {
    await Provider.of<UserModel>(context, listen: false).loadUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUser(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final username = Provider.of<UserModel>(context).username ?? 'Guest';
          return Scaffold(
            appBar: appbar(context, username.toUpperCase()),
            body: studentDashboard(context),
          );
        }
      },
    );
  }

  AppBar appbar(BuildContext context, String username) {
    return AppBar(
      title: Text(
        "Welcome '$username' To Your Dashboard",
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

  Column studentDashboard(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizScreenState()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.question_mark, size: 100, color: Colors.black),
                Text(
                  "Take Quiz",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const QuizResultUIOnly()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Icons.folder, size: 100, color: Colors.black),
                Text(
                  "View Result",
                  style: TextStyle(fontSize: 30, color: Colors.black),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.exit_to_app, size: 100, color: Colors.black),
              Text(
                "Logout",
                style: TextStyle(fontSize: 30, color: Colors.black),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
