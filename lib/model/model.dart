import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Model extends ChangeNotifier {
  String username;
  String name;
  String token;
  bool logged;

  Model({this.token, this.username, this.name});

  factory Model.fromJson(Map<String, dynamic> json) {
    return Model(
        token: json['token'], username: json['username'], name: json['name']);
  }

  update() {
    notifyListeners();
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
      return throw Exception(response.body);
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
      return throw Exception(response.body);
    }

    return Model.fromJson(json.decode(response.body));
  }

  // Caches logging information
  cacheIt(String username, String name, String token) async {
    logged = true;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("logged", true);
    await prefs.setString("username", username);
    await prefs.setString("name", name);
    await prefs.setString("token", token);

    notifyListeners();
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
}
