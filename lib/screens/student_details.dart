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
  final GlobalKey<ScaffoldState> _k = GlobalKey<ScaffoldState>();

  StudentDetails({this.studentId});

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonViewModel>(
      onModelReady: (model) => getData(context, model),
      builder: (context, model, child) {
        return Scaffold(
          key: _k,
          appBar: AppBar(
            title: Text("Student details"),
          ),
          body: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.person != null
                  ? _studentDetails(context, model.person)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
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
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)

                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("Email: ${student.email}"),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("Username: ${student.username}"),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("Phone: ${student.phone}"),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("City: ${student.city}"),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("Country: ${student.country}"),
                    )),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20.0),
                child: Align(
                    alignment: Alignment
                        .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                    child: Align(
                      alignment: Alignment
                          .bottomLeft, // Align however you like (i.e .centerRight, centerLeft)
                      child: Text("Birthday: ${student.birthday}"),
                    )),
              )
            ],
          )),
    ));
  }

  getData(BuildContext context, PersonViewModel model) async {
    var provider = Provider.of<AuthProvider>(context, listen: false);

    var success = await model.studentDetails(
        provider.username, provider.token, studentId);

    if (!success) {
      _k.currentState.showSnackBar(SnackBar(
          content: Text("Session expired, log in again",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red));

      Future.delayed(Duration(seconds: 3), () {
        provider.logout();
        Navigator.pop(context, "Error");
      });
    }
  }
}
