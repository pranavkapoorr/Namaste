import 'package:flutter/material.dart';
import 'AccountScreen.dart';
import 'Contacts.dart';
import 'NotificationScreen.dart';
import 'dart:async';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => new _SettingsScreenState();

}

class _SettingsScreenState extends State<SettingsScreen>{

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: new LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: [
          const Color.fromARGB(255, 253, 72, 72),
          const Color.fromARGB(255, 87, 97, 249),
        ],
        stops: [0.0, 1.0],
      )),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(title: new Text("Settings",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
        body: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              borderRadius:  BorderRadius.all(Radius.circular(5.0))
          ),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
              color: Colors.white,),
            child: new ListView(
               children: <Widget>[ new Column(
                  children: <Widget>[

                    new ListTile(leading:Icon(Icons.border_color,color: Colors.blue,),title: Text("Edit Profile"),trailing: Icon(Icons.navigate_next),),
                    new Divider(height: 1.0,color: Colors.black,),
                    new ListTile(leading: new Icon(Icons.vpn_key,color:Colors.green),title:Text("Account"),onTap: _accountPage,),
                    new Divider(height: 1.0,color: Colors.black,),
                    new ListTile(leading: new Icon(Icons.notifications,color:Colors.yellowAccent),title: new Text("Notifications"),onTap: _notificationsPage,),
                    new Divider(height: 1.0,color: Colors.black,),
                    new ListTile(leading: new Icon(Icons.help,color:Colors.redAccent),title: new Text("Help and FeedBack"),onTap: _testDbPage,)

                  ],
                ) ]),
            ),
        )
      ),
    );
  }
  Future _accountPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new AccountScreen()));
  }
  Future _notificationsPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new NotificationScreen()));
  }
  Future _testDbPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ContactsDemo()));
  }

}

