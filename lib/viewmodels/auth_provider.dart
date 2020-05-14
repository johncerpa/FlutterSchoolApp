import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String _username;
  String _token;
  String _name;
  bool _loggedIn = false;

  AuthProvider() {
    _read();
  }

  get name => _name;
  get username => _username;
  get loggedIn => _loggedIn;
  get token => _token;

  void setLoggedIn(String username, String name, String token) {
    _loggedIn = true;
    _username = username;
    _name = name;
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
    bool loggedIn = prefs.getBool('loggedIn') ?? false;
    String username = prefs.getString('username') ?? "";
    String token = prefs.getString('token') ?? "";
    String name = prefs.getString('name') ?? "";

    print(loggedIn);
    print(username);
    print(name);

    if (loggedIn) {
      _loggedIn = loggedIn;
      _username = username;
      _token = token;
      _name = name;
      notifyListeners();
    }
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('loggedIn', _loggedIn);
    prefs.setString('username', _username);
    prefs.setString('token', _token);
    prefs.setString('name', _name);
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
