import 'package:login/model/model.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/signup.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool staySignedIn = false;

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
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Email", prefixIcon: Icon(Icons.email)),
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
                        decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.security)),
                        // The validator receives the text that the user has entered.
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.0),
                      checkbox(),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          loginButton(model, context),
                          signUpButton(context),
                        ],
                      ),
                    ],
                  )),
            );
          }),
        ),
      ),
    );
  }

  snackbar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ));
  }

  void loginLogic(Model model, BuildContext originalContext) async {
    String email = emailController.text;
    String password = passwordController.text;

    await Model.login(email, password).then((user) async {
      if (staySignedIn) {
        await model.cacheIt(user);
      }

      await model.update(user);
    }).catchError((error) {
      String errorMsg = error.toString().substring(
          error.toString().indexOf(":") + 1, error.toString().length);
      snackbar(originalContext, errorMsg);
      return;
    }).timeout(Duration(seconds: 5), onTimeout: () {
      snackbar(originalContext, "Time out");
      return;
    });
  }

  Widget loginButton(Model model, BuildContext originalContext) {
    return Container(
        margin: new EdgeInsets.only(right: 10.0),
        child: MaterialButton(
          child: Text(
            "Log in",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () async {
            snackbar(originalContext, "Loging in...");
            if (_key.currentState.validate()) {
              loginLogic(model, originalContext);
            }
          },
        ));
  }

  Widget signUpButton(BuildContext context) {
    return InkWell(
      // When the user taps the button, show a snackbar.
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUp()));
      },
      child: Container(
        padding: EdgeInsets.all(12.0),
        child: Text('Sign Up'),
      ),
    );
  }

  Widget checkbox() {
    return CheckboxListTile(
      title: const Text('Stay signed in'),
      value: staySignedIn,
      onChanged: (bool value) {
        setState(() {
          staySignedIn = value;
        });
      },
      secondary: const Icon(Icons.account_box, color: Colors.grey),
    );
  }
}
