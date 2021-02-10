import 'package:flutter/material.dart';

import 'package:social_app/src/auth/login.dart';
import 'package:social_app/src/auth/register.dart';

import './utils/constants.dart';

import 'package:firebase_database/firebase_database.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Social App",
      theme: ThemeData(
        primarySwatch: Colors.green,
        fontFamily: fontFamily1,
        indicatorColor: Colors.blue[700],
      ),
      home: LoginScreen(
        message: null,
      ),
      // routes: {
      //   '/': (context) => App(),
      //   '/login': (context) => LoginScreen(),
      //   '/register': (context) => RegisterScreen(),
      // },
      // initialRoute: '/',
    );
  }
}
