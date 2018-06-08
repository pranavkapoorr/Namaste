import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/NamasteHome.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

List<CameraDescription> cameras;

Future<Null> main() async {
  cameras = await availableCameras();
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Namaste',
      theme: new ThemeData(
        primaryColor: CupertinoColors.white,
        accentColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: new NamasteHome(cameras),
    );
  }
}
