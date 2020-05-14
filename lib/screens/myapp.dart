import 'package:flutter/material.dart';
import 'package:login/viewmodels/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:login/screens/home.dart';
import 'package:login/screens/login.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (ctx) => AuthProvider(),
        child: MaterialApp(
            title: 'School app',
            theme: ThemeData(primarySwatch: Colors.blue),
            home: ConditionalView()));
  }
}

class ConditionalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (ctx, authProvider, child) {
      return authProvider.loggedIn ? Home() : Login();
    });
  }
}
