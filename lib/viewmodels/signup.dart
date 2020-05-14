import 'package:login/base/model.dart';
import 'package:login/models/user.dart';
import 'package:login/services/authentication_service.dart';
import '../locator.dart';

class SignUpModel extends BaseModel {
  final AuthenticationService _authService = locator<AuthenticationService>();

  User get user => _authService.user;

  Future<bool> signup(
      String username, String password, String email, String name) async {
    setState(ViewState.Busy);

    bool response = await _authService.signup(username, password, email, name);

    notifyListeners();
    setState(ViewState.Idle);

    return response;
  }
}
