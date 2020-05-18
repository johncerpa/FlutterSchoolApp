import 'package:login/models/user.dart';
import '../locator.dart';
import 'api.dart';

class AuthenticationService {
  Api _api = locator<Api>();
  User user;

  Future<bool> login(String email, String password) async {
    try {
      User fetchedUser = await _api.login(email, password);
      user = fetchedUser;
      return true;
    } catch (Exception) {
      return false;
    }
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

  checkToken(String token) async {
    var res = await _api.checkToken(token);
    return res;
  }
}
