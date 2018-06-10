import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() {
    return new SettingsScreenState();
  }

}

class SettingsScreenState extends State<SettingsScreen>{
  List<SettingsMenuItems> _settingMenuItems = ([

    new SettingsMenuItems(
        name:new Text("Pranav Kapoor",style: new TextStyle(fontSize: 20.0,fontWeight: FontWeight.w400),),
        status: new Text("    Hi there I am using Namaste..!"),
        icon:new IconButton(
          icon:new CircleAvatar(
            backgroundImage: new NetworkImage("https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg"),
            backgroundColor: Colors.grey,foregroundColor: Colors.transparent,),
          onPressed: null,)),
    new SettingsMenuItems(
        name:new Text("Account"),
        icon:new IconButton(icon:new Icon(Icons.vpn_key,color:Colors.black),onPressed: null,)),
    new SettingsMenuItems(
        name:new Text("Notifications"),
        icon:new IconButton(icon:new Icon(Icons.notifications_active,color:Colors.black),onPressed: null,)),
    new SettingsMenuItems(
        name:new Text("Help"),
        icon:new IconButton(icon:new Icon(Icons.help,color: Colors.black,),onPressed: null,)),
  ]);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Settings Page"),),
      body: new Scaffold(
        /*appBar: new AppBar(
          leading: new IconButton(
              icon:new CircleAvatar(backgroundColor: Colors.grey ,
                backgroundImage: new NetworkImage("https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg"),
                foregroundColor: Colors.transparent,
                radius: 50.0,
              ),
              onPressed: null),
          title: new Text("Pranav Kapoor",style: new TextStyle(fontSize: 18.0),),
          elevation: 0.7,
        ),*/
        body: new ListView.builder(
            itemCount: _settingMenuItems.length,
            itemBuilder:(context,i)=>new Column(
              children: <Widget>[
                new Divider(height: 1.0,color: Colors.black,),
                new ListTile(title: _settingMenuItems[i].name,leading: _settingMenuItems[i].icon,subtitle: _settingMenuItems[i].status,)
              ],
            ) ),
        )
    );
  }

}
class SettingsMenuItems {
  final Text name;
  final Text status;
  final IconButton icon;
  SettingsMenuItems({this.name,this.status,this.icon});
}
