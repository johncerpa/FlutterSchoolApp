import 'package:flutter/material.dart';
import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:login/models/person.dart';
import 'package:login/screens/professor_details.dart';
import 'package:login/screens/student_details.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/course_details.dart';
import 'package:provider/provider.dart';

class CourseDetails extends StatelessWidget {
  final int courseId;
  final GlobalKey<ScaffoldState> _k = GlobalKey<ScaffoldState>();

  CourseDetails({this.courseId});

  @override
  Widget build(BuildContext context) {
    return BaseView<CourseViewModel>(
      onModelReady: (model) => getData(context, model),
      builder: (context, model, child) {
        return Scaffold(
          key: _k,
          appBar: AppBar(title: Text("Course details")),
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : model.course != null
                  ? _courseDetail(context, model)
                  : Center(child: CircularProgressIndicator()),
          floatingActionButton: _floatingButton(context, model),
        );
      },
    );
  }

  getData(BuildContext context, CourseViewModel model) async {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    var response =
        await model.courseDetails(provider.username, provider.token, courseId);
    if (!response) {
      _k.currentState.showSnackBar(SnackBar(
          content: Text("Session expired, log in again",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));

      Future.delayed(Duration(seconds: 3), () {
        provider.logout();
        Navigator.pop(context);
      });
    }
  }

  Widget _courseDetail(BuildContext context, CourseViewModel model) {
    String lowercase = model.course.name.toLowerCase();
    String courseCapitalized =
        '${lowercase[0].toUpperCase()}${lowercase.substring(1)}';

    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 15.0, right: 15.0),
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Text("$courseCapitalized",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              Container(
                margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      child: Card(
                        color: Colors.blue,
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                              "Professor: ${model.course.professor.name}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      onTap: () async {
                        var response =
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfessorDetails(
                                      professorId: model.course.professor.id,
                                    )));

                        if (response == "Error") {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  ],
                ),
              ),
              _item(model.course.students)
            ],
          )),
    ));
  }

  Widget _item(List<Person> list) {
    return Container(
      height: 500.0,
      child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, position) {
            var elem = list[position];
            return Container(
              padding: new EdgeInsets.all(5.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.person, size: 35),
                  title: Text(elem.name,
                      style: TextStyle(fontWeight: FontWeight.w500)),
                  onTap: () async {
                    var response =
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudentDetails(
                                  studentId: elem.id,
                                )));

                    if (response == "Error") {
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            );
          }),
    );
  }

  _floatingButton(BuildContext context, CourseViewModel model) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    return FloatingActionButton(
        onPressed: () {
          model
              .addStudent(provider.username, provider.token, courseId)
              .then((bool success) {
            if (success) {
              _k.currentState.showSnackBar(SnackBar(
                content: Text("Student was added",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ));
            } else {
              _k.currentState.showSnackBar(SnackBar(
                content: Text("Can't add student, token is not valid anymore",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.red,
              ));

              Future.delayed(Duration(seconds: 3), () {
                provider.logout();
                Navigator.pop(context);
              });
            }
          });
        },
        tooltip: 'Add student',
        child: new Icon(Icons.add));
  }
}
