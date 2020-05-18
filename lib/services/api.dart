import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login/models/course.dart';
import 'package:login/models/course_details.dart';
import 'package:login/models/person.dart';
import 'package:login/models/user.dart';
import 'dart:io';

class Api {
  var client = new http.Client();

  Future<User> login(String email, String password) async {
    final http.Response response = await http.post(
        "https://movil-api.herokuapp.com/signin",
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body:
            jsonEncode(<String, String>{'email': email, 'password': password}));

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return User.fromJson(json.decode(response.body));
  }

  Future<User> signup(
      String username, String password, String email, String name) async {
    final http.Response response = await http.post(
        "https://movil-api.herokuapp.com/signup",
        headers: <String, String>{
          'Content-type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{
          'email': email,
          'username': username,
          'password': password,
          'name': name
        }));

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return User.fromJson(json.decode(response.body));
  }

  Future<List<Course>> getCourses(String username, String token) async {
    Uri uri = Uri.https("movil-api.herokuapp.com", '$username/courses');

    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer $token',
    });

    List<Course> courses = List<Course>();

    if (response.statusCode == 200) {
      courses = (jsonDecode(response.body) as List).map((i) {
        return Course.fromJson(i);
      }).toList();
    }

    return courses;
  }

  Future<Course> addCourse(String username, String token) async {
    Uri uri = Uri.https("movil-api.herokuapp.com", '$username/courses');

    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return Course.fromJson(json.decode(response.body));
  }

  Future<CourseDetailsModel> courseDetail(
      String username, String token, int courseId) async {
    Uri uri =
        Uri.https('movil-api.herokuapp.com', '$username/courses/$courseId');
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return CourseDetailsModel.fromJson(json.decode(response.body));
  }

  professorDetails(String username, String token, int professorId) async {
    Uri uri = Uri.https(
        'movil-api.herokuapp.com', '$username/professors/$professorId');
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return Person.fromJson(json.decode(response.body));
  }

  studentDetails(String username, String token, int studentId) async {
    Uri uri =
        Uri.https('movil-api.herokuapp.com', '$username/students/$studentId');
    final http.Response response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return Person.fromJson(json.decode(response.body));
  }

  addStudent(String username, String token, int courseId) async {
    Uri uri = Uri.https('movil-api.herokuapp.com', '$username/students');
    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json;charset=UTF-8',
          HttpHeaders.authorizationHeader: 'Bearer $token'
        },
        body: jsonEncode(<String, String>{
          'courseId': courseId.toString(),
        }));

    if (response.statusCode != 200) {
      Map ref = json.decode(response.body);
      return throw Exception(ref['error'].toString());
    }

    return Person.fromJson(json.decode(response.body));
  }

  checkToken(String token) async {
    Uri uri = Uri.https("movil-api.herokuapp.com", 'check/token');
    final http.Response response = await http.post(uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'token': token}));

    return jsonDecode(response.body);
  }
}
