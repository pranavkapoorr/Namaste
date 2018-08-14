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
  PageController _pageController;
  String _myNumber;
  int _page = 1;

  void onPageChanged(int page){
    setState((){
      this._page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    });
    _pageController = new PageController(initialPage: 1);

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
              new PageView(
                children: <Widget>[
                  new Profile(),
                  new Namaste(),
                  new ChatScreen()
                ],
                controller: _pageController,
                onPageChanged: onPageChanged,
              ),
              new Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          new IconButton(icon: new Icon(_page==0?Icons.person:Icons.person_outline),iconSize: 30.0, onPressed: ()=>_navigationTapped(0)),
                          new IconButton(icon: new CircleAvatar(radius: 30.0,backgroundColor: _page==1?Colors.black38.withOpacity(0.7):Colors.black38,child: Image(image: AssetImage("images/logo.png"),color:Colors.white,)),iconSize: 60.0, onPressed: ()=>_navigationTapped(1)),
                          new IconButton(icon: new Icon(_page==2?Icons.chat:Icons.chat_bubble_outline),iconSize: 25.0,onPressed: ()=>_navigationTapped(2)),
                        ],
                    )
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

  void _navigationTapped(int page){
    _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease
    );
  }
  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }
}

