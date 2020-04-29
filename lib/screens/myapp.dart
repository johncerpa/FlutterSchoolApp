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
              future: getPrefs(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.hasData) {
                  final isLogged = snapshot.data;
                  return isLogged ? Home() : Login();
                }

                return Login();
              });
        }));
  }

  Future<bool> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("logged") ?? false;
  }
}
