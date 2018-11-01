import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'views/LogoPage.dart';

var app;

void main(){
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(new MyApp()));
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Namaste',
      theme: new ThemeData(
        //brightness: Brightness.dark,
        primaryColor: new Color(0xffF4F4F4),
        accentColor: new Color(0xffA1A9A9),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: new LogoPage(),
    );
  }
}
