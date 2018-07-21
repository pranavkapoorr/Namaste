import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/views/Profile.dart';
import 'package:Namaste/views/Namaste.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'ChatScreen.dart';
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

class _NamasteHomeState extends State<NamasteHome> with TickerProviderStateMixin{
  TabController _tabController;
  String _myNumber;
  int _currentTab = 1;


  void _updateCurrentTab(){
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    });
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 3);
    _tabController.addListener(_updateCurrentTab);

  }


  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      child: new Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            gradient: myGradient
          ),
          child: new TabBar(
            indicator:UnderlineTabIndicator(),
            unselectedLabelColor: Colors.grey,
            controller: _tabController,
            tabs: <Widget>[
              new Tab(icon: new Icon(Icons.person,size: 22.0,)),
              new Tab(icon: new CircleAvatar(radius: 30.0,backgroundColor: Colors.pinkAccent,child: Text("🙏")),),
              new Tab(icon: new Icon(Icons.message,size: 22.0,)),
            ],
          ),
        ),
        body: Container(
          decoration: new BoxDecoration(
              gradient: myGradient
          ),
          child: new TabBarView(
              controller: _tabController,
              children: <Widget>[
                new Profile(),
                new Namaste(),
                new ChatScreen(),
              ],
            ),
        ),
      ),
      onWillPop: (){return new Future<bool>.value(false);},
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
    _tabController.removeListener(_updateCurrentTab);
  }
}

