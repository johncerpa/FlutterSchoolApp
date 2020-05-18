import 'package:login/base/model.dart';
import 'package:login/models/course_details.dart';
import 'package:login/models/person.dart';
import 'package:login/services/authentication_service.dart';
import 'package:login/services/courses_service.dart';
import 'package:login/services/person_service.dart';
import '../locator.dart';

class CourseViewModel extends BaseModel {
  CourseService _cs = locator<CourseService>();
  PersonService _ps = locator<PersonService>();
  CourseDetailsModel _course;
  final AuthenticationService _authService = locator<AuthenticationService>();

  CourseDetailsModel get course => _course;

  Future<bool> courseDetails(
      String username, String token, int courseId) async {
    setState(ViewState.Busy);
    bool success = true;
    try {
      _course = await _cs.courseDetails(username, token, courseId);
    } catch (Exception) {
      success = false;
    }
    setState(ViewState.Idle);
    return success;
  }

  Future<bool> addStudent(String username, String token, int courseId) async {
    setState(ViewState.Busy);
    bool success = true;

    try {
      Person newStudent = await _ps.addStudent(username, token, courseId);
      _course.students.add(newStudent);
    } catch (Exception) {
      success = false;
    }

    notifyListeners();

    setState(ViewState.Idle);

    return success;
  }

  checkToken(String token) async {
    return await _authService.checkToken(token);
  }
}
