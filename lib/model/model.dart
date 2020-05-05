import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'Course.dart';

class Model extends ChangeNotifier {
  String username;
  String name;
  String token;
  bool logged;

  Model({
    this.token,
    this.username,
    this.name,
    this.logged = false,
  });

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
      token: json['token'],
      username: json['username'],
      name: json['name'],
    );
  }

  Future<Model> login(String email, String password) async {
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

    return Model.fromJson(json.decode(response.body));
  }

  Future<Model> signup(
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

    return Model.fromJson(json.decode(response.body));
  }

  update(Model user) async {
    logged = true;
    username = user.username;
    name = user.name;
    token = user.token;
    await getCourses();
    notifyListeners();
  }

  // Caches logging information
  cacheIt(Model user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logged", true);
    await prefs.setString("username", user.username);
    await prefs.setString("name", user.name);
    await prefs.setString("token", user.token);
  }

  logout() async {
    logged = false;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("logged");
    await prefs.remove("username");
    await prefs.remove("name");
    await prefs.remove("token");

    notifyListeners();
  }

  Future<List<Course>> getCourses() async {
    Uri uri = Uri.https("movil-api.herokuapp.com", '${this.username}/courses');

    final http.Response response =
        await http.get(uri, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: 'Bearer ' + this.token,
    });

    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List).map((i) {
        return Course.fromJson(i);
      }).toList();
    }

    return null;
  }

  addCourse() async {
    Uri uri = Uri.https("movil-api.herokuapp.com", '${this.username}/courses');
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer " + this.token,
      },
    );

    notifyListeners();
    return response.statusCode == 200;
  }
}
