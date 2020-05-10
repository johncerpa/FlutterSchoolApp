import 'package:flutter/material.dart';
import 'package:login/model/Course.dart';
import 'package:login/model/model.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(title: Text("Home")),
      body: Center(child: Consumer<Model>(builder: (context, model, child) {
        checkToken(model, context);

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
              Text('Name: ${model.name}', style: TextStyle(fontSize: 24.0)),
              SizedBox(height: 20.0),
              logoutButton(model),
              SizedBox(height: 20.0),
              _futureList(model),
            ],
          ),
        );
      })),
      floatingActionButton: _floatButton(),
    ));
  }

  checkToken(Model model, BuildContext context) async {
    var response = await Model.checkToken(model.token);

    if (!response["valid"]) {
      snackbar(context, "Token is not valid anymore, log in again.");
      model.logout();
    }
  }

  Widget _futureList(Model model) {
    return FutureBuilder(
        future: model.getCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.hasData) {
            return _list(snapshot.data);
          } else if (snapshot.hasError) {
            return Center(
              child: Text("No courses available"),
            );
          } else {
            print(snapshot.connectionState);
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }

  Widget _list(List<Course> list) {
    return Container(
        height: 500.0,
        child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, position) {
              var element = list[position];
              return _item(element, position);
            }));
  }

  Widget _item(Course element, int position) {
    return Card(
        child: ListTile(
            title: Text(element.name),
            subtitle: Text(
                "Professor: ${element.professor}, Students: ${element.students}")));
  }

  Widget _floatButton() {
    return Consumer<Model>(builder: (context, model, child) {
      return FloatingActionButton(
          onPressed: () async {
            bool response = await model.addCourse();
            if (response) {
              snackbar(context, "Course was added");
            } else {
              snackbar(context, "Error adding course");
            }
          },
          tooltip: 'Add course',
          child: new Icon(Icons.add));
    });
  }

  Widget logoutButton(Model model) {
    return MaterialButton(
      child: Text("Log out", style: TextStyle(color: Colors.white)),
      color: Colors.blue,
      onPressed: () {
        model.logout();
      },
    );
  }

  snackbar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
