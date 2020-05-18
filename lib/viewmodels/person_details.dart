import 'package:login/base/model.dart';
import 'package:login/models/person.dart';
import 'package:login/services/person_service.dart';
import '../locator.dart';

class PersonViewModel extends BaseModel {
  PersonService _ps = locator<PersonService>();
  Person _person;
  Person get person => _person;

  Future<bool> professorDetails(
      String username, String token, int professorId) async {
    setState(ViewState.Busy);
    bool success = true;
    try {
      _person = await _ps.professorDetails(username, token, professorId);
    } catch (Exception) {
      success = false;
    }

    setState(ViewState.Idle);

    return success;
  }

  Future<bool> studentDetails(
      String username, String token, int studentId) async {
    setState(ViewState.Busy);
    bool success = true;
    try {
      _person = await _ps.studentDetails(username, token, studentId);
    } catch (Exception) {
      success = false;
    }
    setState(ViewState.Idle);

    return success;
  }
}
