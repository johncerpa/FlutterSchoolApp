import 'package:login/base/model.dart';
import 'package:login/models/course.dart';
import 'package:login/models/user.dart';
import 'package:login/services/authentication_service.dart';
import 'package:login/services/courses_service.dart';

import '../locator.dart';

class HomeModel extends BaseModel {
  CourseService _cs = locator<CourseService>();

  List<Course> get courses => _cs.courses;

  final AuthenticationService _authService = locator<AuthenticationService>();
  User get user => _authService.user;

  Future<List<Course>> getCourses(String username, String token) async {
    setState(ViewState.Busy);

    await _cs
        .getCourses(username, token)
        .catchError((error) => Future.error(error));

    setState(ViewState.Idle);

    return _cs.courses;
  }

  Future<bool> addCourse(String username, String token) async {
    setState(ViewState.Busy);
    var response = await _cs.addCourse(username, token);
    notifyListeners();
    setState(ViewState.Idle);
    return response;
  }

  checkToken(String token) async {
    return await _authService.checkToken(token);
  }
}
