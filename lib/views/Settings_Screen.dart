import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/views/EditProfile.dart';
import 'package:flutter/material.dart';
import 'AccountScreen.dart';
import 'Profile.dart';
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
      decoration: BoxDecoration(gradient:myGradient,),
      child: new Scaffold(
        backgroundColor: Colors.transparent,
        appBar: new AppBar(elevation:0.0,leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){Navigator.pop(context);}),title: new Text("Settings",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
        body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            color: Colors.white,),
          child: new Column(
             children: <Widget>[
                  new ListTile(leading: new Icon(Icons.vpn_key,color:Colors.green),title:Text("Account"),onTap: _accountPage,trailing: Icon(Icons.navigate_next)),
                  new Divider(height: 1.0,color: Colors.black,),
                  new ListTile(leading: new Icon(Icons.notifications,color:Colors.amberAccent),title: new Text("Notifications"),onTap: _notificationsPage,trailing: Icon(Icons.navigate_next)),
                  new Divider(height: 1.0,color: Colors.black,),
                  new ListTile(leading: new Icon(Icons.help,color:Colors.redAccent),title: new Text("Help and FeedBack"),onTap: (){},trailing: Icon(Icons.navigate_next))
             ]
          ),
        )
      ),
    );
  }
  Future _editProfilePage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new EditProfile()));
  }
  Future _accountPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new AccountScreen()));
  }
  Future _notificationsPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new NotificationScreen()));
  }


}

