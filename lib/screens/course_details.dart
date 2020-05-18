import 'package:flutter/material.dart';
import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:login/models/course_details.dart';
import 'package:login/models/person.dart';
import 'package:login/screens/professor_details.dart';
import 'package:login/screens/student_details.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/course_details.dart';
import 'package:provider/provider.dart';

class CourseDetails extends StatelessWidget {
  final int courseId;
  GlobalKey<ScaffoldState> _k = GlobalKey<ScaffoldState>();

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
              : _courseDetail(context, model.course),
          floatingActionButton: _floatingButton(context, model),
        );
      },
    );
  }

  getData(BuildContext context, CourseViewModel model) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    model.courseDetails(provider.username, provider.token, courseId);
  }

  Widget _courseDetail(BuildContext context, CourseDetailsModel course) {
    String lowercase = course.name.toLowerCase();
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
                          child: Text("Professor: ${course.professor.name}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ProfessorDetails(
                                  professorId: course.professor.id,
                                )));
                      },
                    ),
                  ],
                ),
              ),
              _item(course.students)
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
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => StudentDetails(
                              studentId: elem.id,
                            )));
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
              .then((bool val) {
            _k.currentState.showSnackBar(SnackBar(
              content: Text("Student was added",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
            ));
          });
        },
        tooltip: 'Add student',
        child: new Icon(Icons.add));
  }
}
