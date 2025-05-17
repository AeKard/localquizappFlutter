import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/models/user_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuizScreenState extends StatefulWidget {
  const QuizScreenState({super.key});

  @override
  State<QuizScreenState> createState() => quizScreenState();
}

class quizScreenState extends State<QuizScreenState> {
  Future<void> _loadUser(BuildContext context) async {
    await Provider.of<UserModel>(context, listen: false).loadUser();
  }

  List<dynamic> _questions = [];
  int _currentQuestionIndex = 0;
  String _selectedOption = '';
  bool _loadingQuestions = true;
  String? _error;
  int _score = 0;

  final String apiUrl = "http://localhost/flutter_LocalQuizApp/getquestion.php";
  Future<void> updateScore(String studentNumber, String score) async {
    final uri = Uri.parse(
      'http://localhost/flutter_LocalQuizApp/updatescore.php',
    );

    try {
      final response = await http.post(
        uri,
        body: {'studentnumber': studentNumber.toString(), 'score': score},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          debugPrint("Score updated: ${result['message']}");
        } else {
          debugPrint("Update failed: ${result['message']}");
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error updating score: $e");
    }
  }

  Future<void> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _questions = data;
          _loadingQuestions = false;
          _error = null;
        });
      } else {
        setState(() {
          _error =
              'Failed to load questions. Status code: ${response.statusCode}';
          _loadingQuestions = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error fetching questions: $e';
        _loadingQuestions = false;
      });
    }
  }

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onNextPressed() async {
    if (_selectedOption.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an option before proceeding.'),
        ),
      );
      return;
    }

    // Check if the selected option is correct
    if (_selectedOption == _questions[_currentQuestionIndex]['answer_letter']) {
      _score++; // <-- Increment score if the answer is correct
    }
    if (_currentQuestionIndex >= _questions.length - 1) {
      final username =
          Provider.of<UserModel>(context, listen: false).username ?? 'Guest';
      updateScore(username, _score.toString());
    }
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedOption = '';
      });
    } else {
      // Display the score at the end
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: const Text('Quiz Completed'),
              content: Text(
                'You scored $_score out of ${_questions.length}',
              ), // <-- Show score here
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _currentQuestionIndex = 0;
                      _selectedOption = '';
                      _score = 0; // <-- Reset the score
                    });
                  },
                  child: const Text('Restart'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context); // <-- Go back to previous screen
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadUser(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          return Scaffold(
            appBar: appbar(context),
            body:
                _loadingQuestions
                    ? const Center(child: CircularProgressIndicator())
                    : _error != null
                    ? Center(child: Text(_error!))
                    : quizscreen(_questions[_currentQuestionIndex]),
          );
        }
      },
    );
  }

  Center quizscreen(dynamic question) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Center(
            child: Text(
              "${_currentQuestionIndex + 1}. ${question['question'] ?? 'No question'}",
              style: const TextStyle(fontSize: 24, color: Colors.black),
            ),
          ),
          const SizedBox(height: 30),
          _buildOption("A. ${question['a'] ?? ''}", "A"),
          const SizedBox(height: 10),
          _buildOption("B. ${question['b'] ?? ''}", "B"),
          const SizedBox(height: 10),
          _buildOption("C. ${question['c'] ?? ''}", "C"),
          const SizedBox(height: 10),
          _buildOption("D. ${question['d'] ?? ''}", "D"),
          const SizedBox(height: 50),
          GestureDetector(
            onTap: _onNextPressed,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              child: const Text(
                "Next",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text("Quiz"),
      centerTitle: true,
    );
  }

  Widget _buildOption(String optionText, String optionLetter) {
    return GestureDetector(
      onTap: () {
        _onOptionSelected(optionLetter);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              _selectedOption == optionLetter
                  ? Colors.amberAccent
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          optionText,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
