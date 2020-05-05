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
    bool v=prefs.getBool("logged") ?? false;
    Model user2= new Model();
    if(v){

      user2.name=prefs.get("name");
      user2.username=prefs.get("username");
      user2.token=prefs.get("token");
      user.update(user2);
    }
    return prefs.getBool("logged") ?? false;
  }
}
