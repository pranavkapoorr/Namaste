import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_app/views/CameraScreen.dart';
import 'package:flutter_app/views/CallScreen.dart';
import 'package:flutter_app/views/StatusScreen.dart';
import 'package:flutter_app/views/ChatScreen.dart';
import 'package:flutter_app/views/Settings_Screen.dart';
import 'package:flutter_app/views/ContactsUsingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NamasteHome extends StatefulWidget {
  @override
  _NamasteHomeState createState()=> new _NamasteHomeState();

  static Future<bool> exitApp(BuildContext context) {
    return showDialog(
      context: context,
      // ignore: deprecated_member_use
      child: new AlertDialog(
        title: new Text('Do you want to exit this application?'),
        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => (){return new Future<bool>.value(false);},
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>(){return new Future<bool>.value(true);},
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ;
  }
}

class _NamasteHomeState extends State<NamasteHome> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List<PopupMenuItem> _options = new List<PopupMenuItem>();
  String _myNumber;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    });
    _options.addAll([
      new PopupMenuItem(
          child: new ListTile(
            title:Text("Settings",style: new TextStyle(color: Colors.black, fontSize: 18.0)),
            onTap: _settingPage
          )
      ),
      new PopupMenuItem(
          child: new ListTile(
              title:Text("About",style: new TextStyle(color: Colors.black, fontSize: 18.0)),
              onTap:null)),
    ]);
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 4);
  }

  void _settingPage(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text("Namaste",style: new TextStyle(color: Theme.of(context).accentColor),),
          elevation: 0.7,
          bottom: new TabBar(
            controller: _tabController,
            indicatorColor: Colors.grey,
            labelColor: new Color(0xff939696),//999C9C),
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.photo_camera,size: 22.0,)),
              new Tab(text: "CHATS"),
              new Tab(text: "STATUS"),
              new Tab(text: "CALLS"),
            ],
          ),
          actions: <Widget>[
            new IconButton(icon:new Icon(Icons.search,color: new Color(0xff939696)),onPressed: null,),
            new Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
            ),
            new PopupMenuButton(
                elevation: 10.0,
                padding: EdgeInsets.zero,
                tooltip:"Settings",
                icon: new Icon(Icons.more_vert,color: new Color(0xff939696)) ,
                itemBuilder: (BuildContext context){
                  return _options;
                })
          ],
        ),
        body: new TabBarView(
          controller: _tabController,
          children: <Widget>[
            new CameraScreen(),
            new ChatScreen(),
            new StatusScreen(),
            new CallsScreen(),
          ],
        ),
        floatingActionButton: new FloatingActionButton(
          backgroundColor: Theme.of(context).accentColor,
          child: new Icon(
            Icons.message,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new ContactsUsingScreen(myNumber: _myNumber,))),
        ),
      ),
      onWillPop: (){return new Future<bool>.value(false);},
    );
  }

}