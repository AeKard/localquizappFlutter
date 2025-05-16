import 'package:flutter/material.dart';
import 'package:quizapp/models/user_model.dart';
import 'package:quizapp/pages/adminPage/add_student.dart';
import 'package:quizapp/pages/adminPage/create_quiz_page.dart';
import 'package:quizapp/pages/adminPage/delete_question.dart';
import 'package:quizapp/pages/adminPage/monitor_result.dart';
import 'package:quizapp/pages/student_dashboard.dart';
import 'package:quizapp/pages/admin_dashboard.dart';
import 'package:quizapp/pages/login_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure binding before async
  final userModel = UserModel();
  await userModel.loadUser(); // Load user from SharedPreferences
  runApp(
    ChangeNotifierProvider(create: (_) => UserModel(), child: LocalQuizApp()),
  );
}

class LocalQuizApp extends StatelessWidget {
  const LocalQuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quiz App',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/admin': (context) => AdminDashboard(),
        '/student': (context) => StudentDashboard(),
        '/createQuestion': (context) => CreateQuestionPage(),
        '/monitorResult': (context) => MonitorResult(),
        '/addStudent': (context) => AddStudent(),
        '/deleteQuestion': (context) => DeleteQuestion(),
      },
    );
  }
}
