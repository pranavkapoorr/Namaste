import 'package:flutter/material.dart';
import 'package:flutter_app/views/StartUpLoader.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Namaste',
      theme: new ThemeData(
        primaryColor: new Color(0xffF4F4F4),
        accentColor: new Color(0xffA1A9A9),
      ),
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: new StartUpLoader(),
    );
  }
}
