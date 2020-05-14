import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login/models/course.dart';
import 'package:login/models/user.dart';
import 'dart:io';

class Api {
  static const String baseUrl = "https://movil-api.herokuapp.com";

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

    return Course.fromJson(json.decode(response.body));
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
