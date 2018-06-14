import 'package:flutter/material.dart';
import 'package:flutter_app/views/AccountScreen.dart';
import 'package:flutter_app/views/NotificationScreen.dart';
import 'package:flutter_app/views/DBtest.dart';
import 'dart:async';

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
      appBar: new AppBar(title: new Text("Settings"),),
      body: new Scaffold(

        body: new ListView(
           children: <Widget>[ new Column(
              children: <Widget>[

                new ListTile(title: new Text("Pranav Kapoor",style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400),),
                    leading: new IconButton(
                      icon:new CircleAvatar(
                        backgroundImage: new NetworkImage("https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg"),
                        backgroundColor: Colors.grey,foregroundColor: Colors.transparent,
                        radius: 50.0,),
                      onPressed: null,iconSize: 50.0,),
                    subtitle: new Text("    Hi there I am using Namaste..!"),
                  onTap: null,
                  isThreeLine: true,
                ),
                new Divider(height: 1.0,color: Colors.black,),
                new ListTile(title: new Text("Account"),leading: new Icon(Icons.vpn_key,color:Colors.black),onTap: _accountPage,),
                new ListTile(title: new Text("Notifications"),leading: new Icon(Icons.notifications,color:Colors.black),onTap: _notificationsPage,),
                new ListTile(title: new Text("Help"),leading: new Icon(Icons.help,color:Colors.black),onTap: _testDbPage,)

              ],
            ) ]),
        )
    );
  }
  Future _accountPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new AccountScreen()));
  }
  Future _notificationsPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new NotificationScreen()));
  }
  Future _testDbPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new DBtest()));
  }

}

