import 'package:login/model/model.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/signup.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Log in")),
        body: Center(
          child: Consumer<Model>(builder: (context, model, child) {
            return Container(
              margin: new EdgeInsets.only(left: 20.0, right: 20.0),
              child: Form(
                  key: _key,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(hintText: "Username"),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Password"),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      MaterialButton(
                        child: Text(
                          "Log in",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.blue,
                        onPressed: () {
                          if (_key.currentState.validate()) {
                            model.loggin(usernameController.text,
                                passwordController.text);
                          }
                        },
                      ),
                      MaterialButton(
                        child: Text(
                          "Sign up",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: Colors.green,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUp()));
                        },
                      )
                    ],
                  )),
            );
          }),
        ),
      ),
    );
  }
}
