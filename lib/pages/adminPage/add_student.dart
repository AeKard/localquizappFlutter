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
  final TextEditingController _studentNumberController =
      TextEditingController();
  final TextEditingController _studentLastNameController =
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
      "studentnumber": _studentNumberController.text.trim(),
      "lastname": _studentLastNameController.text.trim(),
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
      "studentnumber": _studentNumberController.text.trim(),
      "lastname": _studentLastNameController.text.trim(),
    };
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          if (!mounted) return;
          showMessageDialog(context, "Successfull", "Added Successfuly");
          _studentNumberController.clear();
          _studentLastNameController.clear();
          errorText = '';
        }
      }
    } catch (e) {
      debugPrint("Error occurred: $e");
    }
  }

  Future<void> _deleteStudent() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/deleteStudent.php",
    );
    Map<String, String> body = {
      "studentnumber": _studentNumberController.text.trim(),
      "lastname": _studentLastNameController.text.trim(),
    };
    try {
      final response = await http.post(uri, body: body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          await fetchStudents();
          if (!mounted) return;
          showMessageDialog(context, "Successfull", "Deleted Successfuly");
          _studentNumberController.clear();
          _studentLastNameController.clear();
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

  void _checkForError() async {
    String studentNumber = _studentNumberController.text.trim();
    String lastName = _studentLastNameController.text.trim();
    bool studentExist = await isStudentExist();
    if (studentNumber.isEmpty || lastName.isEmpty) {
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

  Padding studentAddContainer() {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
        children: [
          TextField(
            controller: _studentNumberController,
            decoration: InputDecoration(labelText: "Student Number"),
          ),
          TextField(
            controller: _studentLastNameController,
            decoration: InputDecoration(labelText: "Student Last Name"),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: ElevatedButton(
                  onPressed: _checkForError,
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

  SingleChildScrollView scrollableTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text("STUDENT NUMBER")),
          DataColumn(label: Text("LASTNAME")),
        ],
        rows:
            students.map((student) {
              return DataRow(
                cells: [
                  DataCell(Text(student['studentnumber'])),
                  DataCell(Text(student['lastname'])),
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
}
