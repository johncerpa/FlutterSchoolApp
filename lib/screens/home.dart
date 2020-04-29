import 'package:flutter/material.dart';
import 'package:login/model/model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatelessWidget {
  Future<String> getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("username");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("Home")),
            body:
                Center(child: Consumer<Model>(builder: (context, model, child) {
              return FutureBuilder(
                future: getPrefs(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Container(
                      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Username: ${model.username}',
                            style: TextStyle(fontSize: 24.0),
                          ),
                          SizedBox(height: 20.0),
                          Text('Name: ${model.name}',
                              style: TextStyle(fontSize: 24.0)),
                          SizedBox(height: 20.0),
                          MaterialButton(
                            child: Text("Log out",
                                style: TextStyle(color: Colors.white)),
                            color: Colors.blue,
                            onPressed: () {
                              model.logout();
                            },
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(child: Text('Home'));
                },
              );
            }))));
  }
}
