import 'package:flutter/material.dart';
import 'dart:async';
import 'StartUpLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {

  @override
  _AccountScreenState createState()=>new _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  SharedPreferences sharedPreferences;
  bool _loggedIn;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _loggedIn = sharedPreferences.getBool("LoggedIn");
    });
  }

  void persist(bool value) {
    setState(() {
      _loggedIn = value;
    });
    sharedPreferences?.setBool("LoggedIn", value);
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Account"),),
        body: new Scaffold(

          body: new ListView(
              children: <Widget>[ new Column(
                children: <Widget>[

                  new ListTile(title: new Text("Change Your Number"),leading: new Icon(Icons.phone_android,color:Colors.black),
                    onTap: (){
                    setState(() {
                      _loggedIn = false;
                      persist(_loggedIn);
                    });
                      print("logged out");
                      _rootPage();

                    },),
                  new ListTile(title: new Text("Delete Your Account"),leading: new Icon(Icons.delete_outline,color:Colors.black),),
                  new ListTile(title: new Text("Terms & Conditions"),leading: new Icon(Icons.business_center,color:Colors.black),)

                ],
              ) ]),
        )
    );
  }
  Future _rootPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new StartUpLoader()));
  }
}

