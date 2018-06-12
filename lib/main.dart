import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/NamasteHome.dart';
import 'package:flutter_app/views/LoginScreen.dart';
import 'package:flutter/cupertino.dart';


 void main(){
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  static bool loggedIn = false;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Namaste',
      theme: new ThemeData(
        primaryColor: new Color(0xffF4F4F4),
        accentColor: new Color(0xffA1A9A9),
      ),
      debugShowCheckedModeBanner: false,
      home: loggedIn==true?new NamasteHome():new LoginPage(),//new NamasteHome(cameras),
    );
  }
}
