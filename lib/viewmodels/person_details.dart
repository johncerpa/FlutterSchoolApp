import 'package:login/base/model.dart';
import 'package:login/models/person.dart';
import 'package:login/services/person_service.dart';
import '../locator.dart';

class PersonViewModel extends BaseModel {
  PersonService _ps = locator<PersonService>();
  Person _person;
  Person get person => _person;

  professorDetails(String username, String token, int professorId) async {
    setState(ViewState.Busy);
    _person = await _ps.professorDetails(username, token, professorId);
    setState(ViewState.Idle);
  }

  studentDetails(String username, String token, int studentId) async {
    setState(ViewState.Busy);
    _person = await _ps.studentDetails(username, token, studentId);
    setState(ViewState.Idle);
  }
}
