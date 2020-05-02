import 'package:login/model/model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return Scaffold(
      appBar: AppBar(title: Text("Sign up")),
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
                       controller: nameController,
                      decoration: InputDecoration(hintText: "Name",prefixIcon: Icon(Icons.perm_identity)),
              
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
                      decoration: InputDecoration(hintText: "Username",prefixIcon: Icon(Icons.account_box)),
                      
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
                      decoration: InputDecoration(hintText: "Email",prefixIcon: Icon(Icons.email)),
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
                      decoration: InputDecoration(hintText: "Password",prefixIcon: Icon(Icons.security)),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                    )
                    ,
                    SizedBox(height: 20.0),
                    MaterialButton(
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

                          await model
                              .signup(username, password, email, name)
                              .then((user) async {
                            await model.cacheIt(user);
                            await model.update(user);
                          }).catchError((error) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(error.toString().substring(
                                    error.toString().indexOf(":") + 1,
                                    error.toString().length))));
                            return;
                          });
                        }
                      },
                    )
                  ],
                )),
          );
        }),
      ),
    );
  }
}
