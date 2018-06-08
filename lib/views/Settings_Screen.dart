import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() {
    return new SettingsScreenState();
  }

}

class SettingsScreenState extends State<SettingsScreen>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings Page"),),
      body: new ListView.builder(
          itemCount: 2,
          itemBuilder:(context,i)=>new Column(
            children: <Widget>[
              new ListTile(title: new Text("hello settings"),)
            ],
          ) ),
    );
  }

}