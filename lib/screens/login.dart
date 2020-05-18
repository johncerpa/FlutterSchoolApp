import 'package:login/base/model.dart';
import 'package:login/base/view.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/signup.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:login/viewmodels/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool rememberMe = false;

  Widget build(BuildContext ctx) {
    return BaseView<LoginModel>(
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(title: Text("Log in")),
            body: model.state == ViewState.Busy
                ? Center(child: CircularProgressIndicator())
                : _loginView(model, ctx)));
  }

  Widget _loginView(LoginModel model, BuildContext context) {
    if (rememberMe) {}
    return Center(
        child: Container(
      margin: new EdgeInsets.only(left: 20.0, right: 20.0),
      child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              emailInput(),
              SizedBox(height: 20.0),
              passwordInput(),
              SizedBox(height: 20.0),
              rememberMeCheckbox(context),
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
    ));
  }

  Widget loginButton(LoginModel model, BuildContext originCtx) {
    return Container(
        margin: new EdgeInsets.only(right: 10.0),
        child: MaterialButton(
          child: Text(
            "Log in",
            style: TextStyle(color: Colors.white),
          ),
          color: Colors.blue,
          onPressed: () async {
            if (_key.currentState.validate()) {
              String email = emailController.text;
              String password = passwordController.text;

              bool success = await model
                  .login(email, password)
                  .timeout(Duration(seconds: 10), onTimeout: () {
                return false;
              });

              if (success) {
                var provider =
                    Provider.of<AuthProvider>(originCtx, listen: false);
                provider.setLoggedIn(
                    model.user.username, model.user.name, model.user.token,rememberMe);

                if (rememberMe) {
                  await provider.remember(email, password);
                } else {
                  
                  await provider.forget();
                }
              }
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

  Widget rememberMeCheckbox(BuildContext originCtx) {
    return CheckboxListTile(
      title: const Text('Remember me'),
      value: rememberMe,
      onChanged: (bool value) {
         var provider =Provider.of<AuthProvider>(originCtx, listen: false);
         
    
          setState(() {
            rememberMe=provider.changeRemember(value);
          });
      },
      secondary: const Icon(Icons.memory, color: Colors.grey),
    );
  }

  Widget emailInput() {
    return FutureBuilder(
        future: getEmailAndPassword(),
        builder: (BuildContext ctx, AsyncSnapshot s) {
          if (s.hasData) {
            
            if (s.data.email.length > 0) {
              if(rememberMe){
                emailController.text = s.data.email;
                passwordController.text=s.data.password;
              }
                
              
            }
          } else {
            emailController.text = "";
          }

          return TextFormField(
            controller: emailController,
            decoration: InputDecoration(
                hintText: "Email", prefixIcon: Icon(Icons.email)),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          );
        });
  }

  Widget passwordInput() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      decoration: InputDecoration(
          hintText: "Password", prefixIcon: Icon(Icons.security)),
      // The validator receives the text that the user has entered.
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  getEmailAndPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String email = await prefs.getString("email") ?? "";
    String password = await prefs.getString("password") ?? "";
    bool reme=prefs.get("remember")??false;
    
  
    setState(() {
      rememberMe=reme;
    });
    // Checks the "Remember me" checkbox
  
    return EmailPassword(email, password,reme);
  }
}

class EmailPassword {
  String email, password;
  bool reme;
  EmailPassword(this.email, this.password,this.reme);
}
