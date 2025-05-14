import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorText = '';

  Future<bool> isStudentExist() async {
    Uri uri = Uri.parse(
      "http://localhost/flutter_LocalQuizApp/checkstudent.php",
    );
    debugPrint(_usernameController.text + _passwordController.text);
    Map<String, String> body = {
      "studentnumber": _usernameController.text.trim(),
      "lastname": _passwordController.text.trim(),
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

  void _login() async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    bool studentExist = await isStudentExist();
    if (!mounted) return;

    if (username == "admin" && password == "admin") {
      Navigator.pushReplacementNamed(context, '/admin');
    } else {
      if (studentExist) {
        Navigator.pushReplacementNamed(context, '/student');
      } else {
        setState(() {
          errorText = 'Invalid username or password';
        });
      }
      debugPrint(errorText);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: appbar(context), body: loginContainer());
  }

  Padding loginContainer() {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: "Username"),
          ),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: "Enter Password"),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: _login, child: Text("Login")),
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
        "Login Page",
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
          Navigator.pushReplacementNamed(context, '/');
        },
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.all(10),
        ),
      ),
    );
  }
}
