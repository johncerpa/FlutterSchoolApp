import 'package:flutter/material.dart';
import 'package:login/base/view.dart';
import 'package:login/base/model.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/signup.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _key = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<SignUpModel>(builder: (context, model, child) {
      return Scaffold(
          body: model.state == ViewState.Busy
              ? Center(child: CircularProgressIndicator())
              : _signupView(model, context));
    });
  }

  Widget _signupView(SignUpModel model, BuildContext ctx) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
      body: Center(
          child: Container(
        margin: new EdgeInsets.only(left: 20.0, right: 20.0),
        child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: "Name", prefixIcon: Icon(Icons.perm_identity)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Icon(Icons.account_box)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                      hintText: "Email", prefixIcon: Icon(Icons.email)),
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
                      hintText: "Password", prefixIcon: Icon(Icons.security)),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20.0),
                signupButton(model, context),
              ],
            )),
      )),
    );
  }

  Widget signupButton(SignUpModel model, BuildContext originCtx) {
    return MaterialButton(
      child: Text(
        "Sign up",
        style: TextStyle(color: Colors.white),
      ),
      color: Colors.blue,
      onPressed: () async {
        if (_key.currentState.validate()) {
          String username = usernameController.text;
          String password = passwordController.text;
          String email = emailController.text;
          String name = nameController.text;

          bool success = await model
              .signup(username, password, email, name)
              .timeout(Duration(seconds: 10), onTimeout: () {
            return false;
          });

          if (success) {
            var provider = Provider.of<AuthProvider>(originCtx, listen: false);
            provider.setLoggedIn(model.user.username, model.user.token);
            Navigator.pop(context);
          }
        }
      },
    );
  }
}
