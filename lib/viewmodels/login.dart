import 'package:login/base/model.dart';
import 'package:login/models/user.dart';
import 'package:login/services/authentication_service.dart';
import '../locator.dart';

class LoginModel extends BaseModel {
  final AuthenticationService _authService = locator<AuthenticationService>();

  User get user => _authService.user;

  Future<bool> login(String email, String password) async {
    setState(ViewState.Busy);

    bool response = await _authService.login(email, password);

    notifyListeners();
    setState(ViewState.Idle);

    return response;
  }
}
