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
        body: Container(
          decoration: new BoxDecoration(
              gradient: myGradient
          ),
          child: Stack(
            children: <Widget>[
              new TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    new Profile(),
                    new Namaste(),
                    new ChatScreen(),
                  ],
                ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: new TabBar(
                      labelColor: Colors.black38.withOpacity(0.7),
                      indicator:UnderlineTabIndicator(),
                      unselectedLabelColor: Colors.grey,
                      controller: _tabController,
                      tabs: <Widget>[
                        new Tab(icon: new Icon(_currentTab==0?Icons.person:Icons.person_outline,size: 22.0,)),
                        new Tab(icon: new CircleAvatar(radius: 30.0,backgroundColor: _currentTab==1?Colors.black38.withOpacity(0.7):Colors.black38,child: Icon(Icons.pages,color: Colors.white,size: 35.0,)),),
                        new Tab(icon: new Icon(_currentTab==2?Icons.chat:Icons.chat_bubble_outline,size: 22.0,)),
                      ],
                    ),
                  ),
                ],
              ),

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

