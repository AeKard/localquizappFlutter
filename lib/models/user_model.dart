import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  String? _username;

  String? get username => _username;

  bool get isLoggedIn => _username != null;

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString('username');
    notifyListeners();
  }

  Future<void> login(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    bool result = await prefs.setString('username', username);

    // Debugging
    if (result) {
      debugPrint('Username saved to SharedPreferences: $username');
    } else {
      debugPrint('❌Failed to save username');
    }

    notifyListeners();
  }

  // Clear the user and remove it from storage
  Future<void> logout() async {
    _username = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    notifyListeners();
  }
}
