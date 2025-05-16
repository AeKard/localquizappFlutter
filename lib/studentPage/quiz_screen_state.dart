import 'package:flutter/material.dart';

class QuizScreenState extends StatefulWidget {
  const QuizScreenState({super.key});

  @override
  State<QuizScreenState> createState() => quizScreenState();
}

class quizScreenState extends State<QuizScreenState> {
  String _selectedOption = '';

  void _onOptionSelected(String option) {
    setState(() {
      _selectedOption = option;
    });
  }

  void _onNextPressed() {
    setState(() {
      _selectedOption = ''; // Reset the selected option
      print("Next Question");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Quiz"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                "1. What is the capital of France?",
                style: const TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
            const SizedBox(height: 30),

            // Options
            _buildOption("A. Paris"),
            const SizedBox(height: 10),
            _buildOption("B. Berlin"),
            const SizedBox(height: 10),
            _buildOption("C. Madrid"),
            const SizedBox(height: 10),
            _buildOption("D. Rome"),
            SizedBox(height: 50),
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
      ),
    );
  }

  Widget _buildOption(String optionText) {
    return GestureDetector(
      onTap: () {
        _onOptionSelected(optionText);
      },
      child: Container(
        decoration: BoxDecoration(
          color:
              _selectedOption == optionText ? Colors.amberAccent : Colors.white,
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
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
