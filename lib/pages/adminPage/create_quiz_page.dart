import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CreateQuizPage extends StatefulWidget {
  const CreateQuizPage({super.key});

  @override
  State<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends State<CreateQuizPage> {
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _choiceAController = TextEditingController();
  final TextEditingController _choiceBController = TextEditingController();
  final TextEditingController _choiceCController = TextEditingController();
  final TextEditingController _choiceDController = TextEditingController();

  String _correctAnswer = 'A'; // or nullable if you want to validate selection

  void _submitQuestion() {
    // Handle submission logic here
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
                onPressed: _submitQuestion,
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
          Navigator.pushReplacementNamed(context, '/admin');
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
          child: SvgPicture.asset('assets/icons/arrow-left-solid.svg'),
        ),
      ),
    );
  }
}
