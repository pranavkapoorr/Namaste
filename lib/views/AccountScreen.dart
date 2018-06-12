import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/main.dart';
import 'package:flutter_app/views/LoginScreen.dart';

class AccountScreen extends StatefulWidget {
  @override
  AccountScreenState createState() {
    return new AccountScreenState();
  }

}

class AccountScreenState extends State<AccountScreen>{

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
                      MyApp.loggedIn = false;
                      print("logged out");
                      _HomePage();

                    },),
                  new ListTile(title: new Text("Delete Your Account"),leading: new Icon(Icons.delete_outline,color:Colors.black),),
                  new ListTile(title: new Text("Terms & Conditions"),leading: new Icon(Icons.business_center,color:Colors.black),)

                ],
              ) ]),
        )
    );
  }
  Future _HomePage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new LoginPage()));
  }
}

