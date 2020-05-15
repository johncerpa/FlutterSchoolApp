import 'package:login/base/model.dart';
import 'package:login/models/course_details.dart';
import 'package:login/models/person.dart';
import 'package:login/services/courses_service.dart';
import 'package:login/services/person_service.dart';
import '../locator.dart';

class CourseViewModel extends BaseModel {
  CourseService _cs = locator<CourseService>();
  PersonService _ps = locator<PersonService>();
  CourseDetailsModel _course;

  CourseDetailsModel get course => _course;

  courseDetails(String username, String token, int courseId) async {
    setState(ViewState.Busy);
    _course = await _cs.courseDetails(username, token, courseId);
    setState(ViewState.Idle);
  }

  addStudent(String username, String token, int courseId) async {
    setState(ViewState.Busy);

    Person newStudent = await _ps.addStudent(username, token, courseId);
    _course.students.add(newStudent);

    notifyListeners();

    setState(ViewState.Idle);
  }
}
