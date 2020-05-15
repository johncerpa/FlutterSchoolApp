import 'package:login/models/person.dart';
import '../locator.dart';
import 'api.dart';

class PersonService {
  Api _api = locator<Api>();

  Future<Person> professorDetails(
      String username, String token, int courseId) async {
    return await _api.professorDetails(username, token, courseId);
  }

  Future<Person> studentDetails(
      String username, String token, int courseId) async {
    return await _api.studentDetails(username, token, courseId);
  }

  Future<Person> addStudent(String username, String token, int courseId) async {
    return await _api.addStudent(username, token, courseId);
  }
}
