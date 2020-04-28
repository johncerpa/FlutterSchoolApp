import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Model extends ChangeNotifier {
  bool logged;
  String username;
  String password;

  Model({this.logged, this.username, this.password});

  loggin(String username, String password) async {
    if (username == this.username && password == this.password) {
      logged = true;
      await cacheIt();
      notifyListeners();
    }
  }

  signup(String username, String password) async {
    this.username = username;
    this.password = password;
    //loggin(this.username, this.password);
  }

  // Caches logging information
  cacheIt() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logged", this.logged);
  }

  logout() async {
    logged = false;
    await cacheIt();
    notifyListeners();
  }

  register(String username, String password) {
    this.username = username;
    this.password = password;
  }
}
