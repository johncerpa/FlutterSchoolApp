import 'package:flutter/material.dart';
import 'package:login/model/model.dart';
import 'package:provider/provider.dart';
import 'package:login/screens/home.dart';
import 'package:login/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<Model>(
        create: (context) => Model(),
        child: Consumer<Model>(builder: (context, model, child) {
          return FutureBuilder(
              future: getPrefs(model),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  final isLogged = snapshot.data;
                  return isLogged ? Home() : Login();
                }

                return Login();
              });
        }));
  }

  Future<bool> getPrefs(Model user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    bool isLogged = prefs.getBool("logged") ?? false;

    if (isLogged) {
      String token = prefs.get("token");
      String username = prefs.get("username");
      String name = prefs.get("name");

      Model userInfo = new Model(token: token, username: username, name: name);

      user.update(userInfo);
    }

    return isLogged;
  }
}
