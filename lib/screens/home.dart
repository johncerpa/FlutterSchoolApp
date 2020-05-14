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
  String _name;

  Widget build(BuildContext context) {
    return BaseView<HomeModel>(
        onModelReady: (model) => getData(context, model),
        builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: <Widget>[
                IconButton(
                  icon:
                      Icon(Icons.exit_to_app, color: Colors.white, size: 24.0),
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                  },
                )
              ],
            ),
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : model.courses != null
                    ? _homeView(model, context)
                    : Center(child: CircularProgressIndicator()),
            floatingActionButton: _floatButton(model, context),
          );
        });
  }

  getData(BuildContext context, HomeModel model) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    model.getCourses(provider.username, provider.token);
    _name = provider.name;
  }

  Widget _homeView(HomeModel model, BuildContext context) {
    checkToken(model, context);
    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome, $_name',
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20.0),
            Text('These are your courses', style: TextStyle(fontSize: 16.0)),
            SizedBox(height: 20.0),
            _list(model.courses),
          ],
        ),
      ),
    ));
  }

  checkToken(HomeModel model, BuildContext authContext) async {
    var provider = Provider.of<AuthProvider>(authContext, listen: false);
    var response = await model.checkToken(provider.token);
    if (!response["valid"]) {
      Provider.of<AuthProvider>(authContext, listen: false).logout();
    }
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

  Widget _floatButton(HomeModel model, BuildContext ctx) {
    var provider = Provider.of<AuthProvider>(ctx, listen: false);
    return FloatingActionButton(
        onPressed: () => model.addCourse(provider.username, provider.token),
        tooltip: 'Add course',
        child: new Icon(Icons.add));
  }
}
