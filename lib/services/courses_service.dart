import 'package:login/models/course.dart';
import 'package:login/models/course_details.dart';
import '../locator.dart';
import 'api.dart';

class CourseService {
  Api _api = locator<Api>();
  List<Course> _courses;
  List<Course> get courses => _courses;

  Future getCourses(String username, String token) async {
    _courses = await _api.getCourses(username, token);
  }

  Future addCourse(String username, String token) async {
    try {
      Course course = await _api.addCourse(username, token);
      _courses.add(course);
      return true;
    } catch (Exception) {
      return false;
    }
  }

  Future<CourseDetailsModel> courseDetails(
      String username, String token, int courseId) async {
    return await _api.courseDetail(username, token, courseId);
  }
}
