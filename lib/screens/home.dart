import 'package:flutter/material.dart';
import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:login/models/course.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/home.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Widget build(BuildContext context) {
    return BaseView<HomeModel>(builder: (context, model, child) {
      checkToken(model, context);
      return Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.white, size: 24.0),
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).logout();
              },
            )
          ],
        ),
        body: model.state == ViewState.Busy
            ? Center(child: CircularProgressIndicator())
            : _homeView(model, context),
        floatingActionButton: _floatButton(model),
      );
    });
  }

  Widget _homeView(HomeModel model, BuildContext context) {
    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, ${model.user.name}',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text('These are your courses', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 20.0),
            _futureList(model),
          ],
        ),
      ),
    ));
  }

  checkToken(HomeModel model, BuildContext authContext) async {
    var response = await model.checkToken();
    if (!response["valid"]) {
      Provider.of<AuthProvider>(authContext, listen: false).logout();
    }
  }

  Widget _futureList(HomeModel model) {
    return FutureBuilder(
        future: model.getCourses(),
        builder: (BuildContext context, AsyncSnapshot<List<Course>> snapshot) {
          if (snapshot.hasData) {
            return _list(snapshot.data);
          }
          return Center(
            child: Text(""),
          );
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

  Widget _floatButton(HomeModel model) {
    return FloatingActionButton(
        onPressed: () => model.addCourse(),
        tooltip: 'Add course',
        child: new Icon(Icons.add));
  }
}
