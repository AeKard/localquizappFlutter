import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class QuizResultUIOnly extends StatelessWidget {
  const QuizResultUIOnly({super.key});

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Student Dashboard",
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
          Navigator.pushReplacementNamed(context, '/student');
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/right-from-bracket-solid.svg'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      backgroundColor: Colors.black,
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          color: Colors.white,
          shadowColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Quiz Title',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Total Questions: 10',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Correct Answers: 8',
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Score: 80%',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
