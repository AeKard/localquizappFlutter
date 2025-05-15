import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateQuestionPage extends StatefulWidget {
  const CreateQuestionPage({super.key});

  @override
  State<CreateQuestionPage> createState() => _CreateQuestionPageState();
}

class _CreateQuestionPageState extends State<CreateQuestionPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _choiceAController = TextEditingController();
  final TextEditingController _choiceBController = TextEditingController();
  final TextEditingController _choiceCController = TextEditingController();
  final TextEditingController _choiceDController = TextEditingController();

  String _correctAnswer = '';

  Future<void> addQuestion() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/addquestion.php",
    );
    debugPrint(
      _questionController.text.trim() +
          _choiceAController.text.trim() +
          _choiceBController.text.trim() +
          _choiceCController.text.trim() +
          _choiceDController.text.trim() +
          _correctAnswer,
    );
    Map<String, String> body = {
      "question": _questionController.text.trim(),
      "a": _choiceAController.text.trim(),
      "c": _choiceBController.text.trim(),
      "b": _choiceCController.text.trim(),
      "d": _choiceDController.text.trim(),
      "answer_letter": _correctAnswer,
    };
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (!mounted) return;
          showMessageDialog(context, "Successfull", "Added Successfuly");
          _questionController.clear();
          _choiceAController.clear();
          _choiceBController.clear();
          _choiceCController.clear();
          _choiceDController.clear();
        }
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  void _checkForError() async {
    String question = _questionController.text.trim();
    String choiceA = _choiceAController.text.trim();
    String choiceB = _choiceBController.text.trim();
    String choiceC = _choiceCController.text.trim();
    String choiceD = _choiceDController.text.trim();
    debugPrint(
      question + choiceA + choiceB + choiceC + choiceD + _correctAnswer,
    );
    if (question.isEmpty ||
        choiceA.isEmpty ||
        choiceB.isEmpty ||
        choiceC.isEmpty ||
        choiceD.isEmpty ||
        _correctAnswer.isEmpty) {
      showMessageDialog(
        context,
        "Fill out all fields",
        "One of the Fields are Empty",
      );
      return;
    }

    addQuestion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _questionController,
              decoration: InputDecoration(labelText: 'Question'),
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _choiceAController,
              decoration: InputDecoration(labelText: 'Choice A'),
            ),
            TextFormField(
              controller: _choiceBController,
              decoration: InputDecoration(labelText: 'Choice B'),
            ),
            TextFormField(
              controller: _choiceCController,
              decoration: InputDecoration(labelText: 'Choice C'),
            ),
            TextFormField(
              controller: _choiceDController,
              decoration: InputDecoration(labelText: 'Choice D'),
            ),
            SizedBox(height: 20),
            Text('Select Correct Answer:'),
            RadioListTile<String>(
              title: Text('A'),
              value: 'A',
              groupValue: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('B'),
              value: 'B',
              groupValue: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('C'),
              value: 'C',
              groupValue: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('D'),
              value: 'D',
              groupValue: _correctAnswer,
              onChanged: (value) {
                setState(() {
                  _correctAnswer = value!;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _checkForError,
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Create Quiz",
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
          Navigator.pop(context);
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/arrow-left-solid.svg'),
        ),
      ),
    );
  }

  void showMessageDialog(
    BuildContext context,
    String title,
    String message,
  ) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
