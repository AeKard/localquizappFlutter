import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizResultUIOnly extends StatefulWidget {
  const QuizResultUIOnly({super.key});

  @override
  State<QuizResultUIOnly> createState() => _QuizResultUIOnlyState();
}

class _QuizResultUIOnlyState extends State<QuizResultUIOnly> {
  String _score = "Loading...";
  String _questionCount = "Loading...";

  Future<void> _loadUserAndScore(BuildContext context) async {
    await Provider.of<UserModel>(context, listen: false).loadUser();
    final username =
        Provider.of<UserModel>(context, listen: false).username ?? 'Guest';
    debugPrint(username);
    final response = await http.post(
      Uri.parse("http://localhost/flutter_LocalQuizApp/getscore.php"),
      body: {'studentnumber': username},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        setState(() {
          _score = data['score'].toString();
          _questionCount = data['question_count'].toString();
        });
      } else {
        setState(() {
          _score = "Score not found";
          _questionCount = "Question count not found";
        });
      }
    } else {
      setState(() {
        _score = "Error fetching score";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // Delay to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserAndScore(context);
    });
  }

  AppBar appbar(BuildContext context, String username) {
    return AppBar(
      title: Text(
        "$username Results",
        style: const TextStyle(
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
          margin: const EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/right-from-bracket-solid.svg'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = Provider.of<UserModel>(context).username ?? 'Guest';
    return Scaffold(
      appBar: appbar(context, username.toUpperCase()),
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
                  'Quiz Score',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Total Questions: $_questionCount', // You can make this dynamic later
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 15),
                Text(
                  'Correct Answers: $_score', // Also can be dynamic
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                const SizedBox(height: 15),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
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
