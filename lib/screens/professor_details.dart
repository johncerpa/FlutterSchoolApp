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
  final GlobalKey<ScaffoldState> _k = GlobalKey<ScaffoldState>();

  ProfessorDetails({this.professorId});

  @override
  Widget build(BuildContext context) {
    return BaseView<PersonViewModel>(
      onModelReady: (model) => getData(context, model),
      builder: (context, model, child) {
        return Scaffold(
          key: _k,
          appBar: AppBar(
            title: Text("Professor details"),
          ),
          body: model.state == ViewState.Busy
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : model.person != null
                  ? _professorDetails(context, model.person)
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
        );
      },
    );
  }

  Widget _professorDetails(BuildContext context, Person professor) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("${professor.name}",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0)),
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
                  child: Text("Email: ${professor.email}"),
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
                  child: Text("Username: ${professor.username}"),
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
                  child: Text("Phone: ${professor.phone}"),
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
                  child: Text("City: ${professor.city}"),
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
                  child: Text("Country: ${professor.country}"),
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
                  child: Text("Birthday: ${professor.birthday}"),
                )),
          ),
        ],
      ),
    ));
  }

  getData(BuildContext context, PersonViewModel model) async {
    var provider = Provider.of<AuthProvider>(context, listen: false);
    var success = await model.professorDetails(
        provider.username, provider.token, professorId);

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
