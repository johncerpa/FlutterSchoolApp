import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:login/models/person.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/person_details.dart';
import 'package:provider/provider.dart';

class StudentDetails extends StatelessWidget {
  final int studentId;

  StudentDetails({this.studentId});

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonViewModel>(
      onModelReady: (model) => getData(context, model),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Student details"),
          ),
          body: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _studentDetails(context, model.person),
        );
      },
    );
  }

  Widget _studentDetails(BuildContext context, Person student) {
    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 15.0, right: 15.0),
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Text("${student.name}",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              SizedBox(
                height: 20.0,
              ),
              Text("Email: ${student.email}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Username: ${student.username}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Phone: ${student.phone}"),
              SizedBox(
                height: 20.0,
              ),
              Text("City: ${student.city}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Country: ${student.country}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Birthday: ${student.birthday}"),
            ],
          )),
    ));
  }

  getData(BuildContext context, PersonViewModel model) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    model.studentDetails(provider.username, provider.token, studentId);
  }
}
