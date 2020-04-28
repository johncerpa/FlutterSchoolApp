import 'package:flutter/material.dart';
import 'package:login/model/model.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text("Home")),
            body:
                Center(child: Consumer<Model>(builder: (context, model, child) {
              return MaterialButton(
                child: Text("Log out", style: TextStyle(color: Colors.white)),
                color: Colors.blue,
                onPressed: () {
                  model.logout();
                },
              );
            }))));
  }
}
