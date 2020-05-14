import 'package:login/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../locator.dart';
import 'api.dart';

class AuthenticationService {
  Api _api = locator<Api>();
  User user;

  Future<bool> login(String email, String password) async {
    User fetchedUser = await _api.login(email, password);

    bool hasUser = fetchedUser != null;

    if (hasUser) {
      user = fetchedUser;
    }

    return hasUser;
  }

  Future<bool> signup(
      String username, String password, String email, String name) async {
    User newUser = await _api.signup(username, password, email, name);

    bool hasUser = newUser != null;

    if (hasUser) {
      user = newUser;
    }

    return hasUser;
  }

  Future<bool> logout() async {
    decacheInfo();
    return Future.value(true);
  }

  cacheInfo(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logged", true);
    await prefs.setString("username", user.username);
    await prefs.setString("name", user.name);
    await prefs.setString("token", user.token);
  }

  decacheInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("logged");
    await prefs.remove("username");
    await prefs.remove("name");
    await prefs.remove("token");
  }

  cacheEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", email);
  }

  uncacheEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
  }

  checkToken() async {
    var res = await _api.checkToken(user.token);
    return res;
  }
}
