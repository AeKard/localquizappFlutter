import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AddStudent extends StatefulWidget {
  const AddStudent({super.key});

  @override
  State<AddStudent> createState() => _AddStudent();
}

class _AddStudent extends State<AddStudent> {
  final TextEditingController _studentUsernameController =
      TextEditingController();
  final TextEditingController _studentPasswordController =
      TextEditingController();

  String errorText = '';

  Future<bool> isStudentExist() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/checkstudent.php",
    );
    Map<String, String> body = {
      "username": _studentUsernameController.text.trim(),
      "password": _studentPasswordController.text.trim(),
    };
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          return true;
        }
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
    return false;
  }

  Future<void> addStudent() async {
    Uri uri = Uri.parse("http://localhost/flutter_LocalQuizApp/addStudent.php");
    Map<String, String> body = {
      "username": _studentUsernameController.text.trim(),
      "password": _studentPasswordController.text.trim(),
    };
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          debugPrint("ADD SUCCESSFUL");
        }
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  void _checkStudentExist() async {
    String username = _studentUsernameController.text.trim();
    String password = _studentPasswordController.text.trim();
    bool studentExist = await isStudentExist();
    if (username.isEmpty || password.isEmpty) {
      setState(() {
        errorText = 'Fill out the fields';
      });
      return;
    }

    if (!mounted) return;

    if (!studentExist) {
      await addStudent();
    } else {
      setState(() {
        errorText = 'Student account already exists';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context), body: studentAddContainer());
  }

  Padding studentAddContainer() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _studentUsernameController,
            decoration: InputDecoration(labelText: "Add Student Username"),
          ),
          TextField(
            controller: _studentPasswordController,
            decoration: InputDecoration(labelText: "Add Stdeunt password"),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _checkStudentExist,
            child: Text("Add Student"),
          ),
          if (errorText.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(errorText, style: TextStyle(color: Colors.red)),
            ),
        ],
      ),
    );
  }

  AppBar appbar(BuildContext context) {
    return AppBar(
      title: Text(
        "Add Student",
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
