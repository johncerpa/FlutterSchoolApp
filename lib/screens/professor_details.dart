import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:login/models/person.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/person_details.dart';
import 'package:provider/provider.dart';

class ProfessorDetails extends StatelessWidget {
  final int professorId;

  ProfessorDetails({this.professorId});

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonViewModel>(
      onModelReady: (model) => getData(context, model),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Professor details"),
          ),
          body: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _professorDetails(context, model.person),
        );
      },
    );
  }

  Widget _professorDetails(BuildContext context, Person professor) {
    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 15.0, right: 15.0),
      child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: <Widget>[
              Text("${professor.name}",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
              SizedBox(
                height: 20.0,
              ),
              Text("Email: ${professor.email}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Username: ${professor.username}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Phone: ${professor.phone}"),
              SizedBox(
                height: 20.0,
              ),
              Text("City: ${professor.city}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Country: ${professor.country}"),
              SizedBox(
                height: 20.0,
              ),
              Text("Birthday: ${professor.birthday}"),
            ],
          )),
    ));
  }

  getData(BuildContext context, PersonViewModel model) {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    model.professorDetails(provider.username, provider.token, professorId);
  }
}
