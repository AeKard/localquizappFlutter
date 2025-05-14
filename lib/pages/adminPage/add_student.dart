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
  List<dynamic> students = [];

  String errorText = '';

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final response = await http.get(
      Uri.parse("http://localhost/flutter_LocalQuizApp/getstudent.php"),
    );

    if (response.statusCode == 200) {
      setState(() {
        students = jsonDecode(response.body);
      });
    } else {
      setState(() {
        students = jsonDecode(response.body);
      });
    }
  }

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
    Uri uri = Uri.parse("http://localhost/flutter_LocalQuizApp/addstudent.php");
    Map<String, String> body = {
      "username": _studentUsernameController.text.trim(),
      "password": _studentPasswordController.text.trim(),
    };
    debugPrint(
      _studentUsernameController.text.trim() +
          _studentPasswordController.text.trim(),
    );
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          if (!mounted) return;
          showMessageDialog(context, "Successfull", "Added Successfuly");
          _studentUsernameController.clear();
          _studentPasswordController.clear();
          errorText = '';
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
      await fetchStudents();
    } else {
      setState(() {
        errorText = 'Student account already exists';
      });
    }
  }

  Future<void> _deleteStudent() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/deleteStudent.php",
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
          await fetchStudents();
          if (!mounted) return;
          showMessageDialog(context, "Successfull", "Deleted Successfuly");
          _studentUsernameController.clear();
          _studentPasswordController.clear();
          errorText = '';
        } else {
          setState(() {
            errorText = data['message'] ?? "Delete failed";
          });
        }
      } else {
        debugPrint("Server error: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                studentAddContainer(),
                SizedBox(height: 16),
                scrollableTable(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView scrollableTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("ID")),
          DataColumn(label: Text("Username")),
          DataColumn(label: Text("Password")),
        ],
        rows:
            students.map((student) {
              return DataRow(
                cells: [
                  DataCell(Text(student['id'])),
                  DataCell(Text(student['username'])),
                  DataCell(Text(student['password'])),
                ],
              );
            }).toList(),
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
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Padding studentAddContainer() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          TextField(
            controller: _studentUsernameController,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: _studentPasswordController,
            decoration: InputDecoration(labelText: "Password"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: _checkStudentExist,
                  child: Text("Add Student"),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: _deleteStudent,
                  child: Text("Delete Student"),
                ),
              ),
            ],
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
