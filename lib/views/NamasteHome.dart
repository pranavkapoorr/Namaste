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
  String _myNumber;
  bool searchClicked = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    });
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 4);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        appBar: searchClicked?_searchAppBar():_normalAppBar(),
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

  AppBar _searchAppBar(){
    return new AppBar(
      leading: new IconButton(icon: new Icon(Icons.arrow_back), onPressed: (){setState(() {
        searchClicked = false;
      });}),
      title:  new TextField(decoration: new InputDecoration(hintText: "         search here",suffixIcon: new Icon(Icons.search),),),
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
    );
  }
  AppBar _normalAppBar(){
    return new AppBar(
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
        new IconButton(icon:new Icon(Icons.search,color: new Color(0xff939696)),onPressed: (){setState(() {
          searchClicked = true;
        });},),
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
        ),
        new PopupMenuButton(
          elevation: 10.0,
          padding: new EdgeInsets.all(0.0),
          tooltip:"Settings",
          icon: new Icon(Icons.more_vert,color: new Color(0xff939696)) ,
          onSelected: (dynamic value){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>value));
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem>[
            new PopupMenuItem(
                value: new SettingsScreen(),
                child: new Text('Settings')
            ),
            new PopupMenuItem(
                value: null,
                child: new Text('About')
            ),
          ],
        ),
      ],
    );
  }

}