import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _username;
  String _token;
  bool _loggedIn = false;

  AuthProvider() {
    _read();
  }

  get username => _username;
  get loggedIn => _loggedIn;
  get token => _token;

  void setLoggedIn(String username, String token) {
    this._username = username;
    _loggedIn = true;
    _token = token;
    _save();
    notifyListeners();
  }

  logout() {
    _loggedIn = false;
    _save();
    notifyListeners();
  }

  _read() async {
    final prefs = await SharedPreferences.getInstance();
    bool loggedIn = prefs.getBool("loggedIn") ?? false;

    if (loggedIn) {
      _loggedIn = loggedIn;
      notifyListeners();
    }
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', _loggedIn);
  }

  remember(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
    prefs.setString('password', password);
  }

  forget() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('email');
    prefs.remove('password');
  }
}
