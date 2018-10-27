import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'views/LogoPage.dart';

var app;
void initFirebaseConfig()async{
  app = await FirebaseApp.configure(
    name: 'Namaste',
    options: FirebaseOptions(
      googleAppID: Platform.isIOS
          ? '1:479879833313:ios:904cf32aa0ad975a'
          : '1:479879833313:android:904cf32aa0ad975a',
      gcmSenderID: '479879833313',
      apiKey: 'AIzaSyDXddPgxhkf_M6bBANv8rNBfQzbjfst-r0',
      projectID: 'testfirebase-d40b1',
    ),
  ).catchError((e)=>print(e.toString()));
}
void main(){
  initFirebaseConfig();
  runApp(new MyApp());
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
