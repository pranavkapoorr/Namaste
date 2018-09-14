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
  bool _loaded = false;
  String _myNumber;
  int _page = 1;

  void onPageChanged(int page){
    setState((){
      this._page = page;
    });
  }

  void _loadUser() async{
    await SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    }).whenComplete((){
      setState(() {
        _loaded = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
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
          child: _loaded?Stack(
            children: <Widget>[
              new PageView(
                children: <Widget>[
                  new Profile(_myNumber),
                  new Namaste(),
                  new ChatScreen()
                ],
                controller: _pageController,
                onPageChanged: onPageChanged,
              ),
              customNavigationBar()

            ],
          ):Center(child: CircularProgressIndicator(),),
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
  Widget customNavigationBar(){
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        new Padding(
            padding: const EdgeInsets.all(2.0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
              child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  new IconButton(icon: new Icon(_page==0?Icons.person:Icons.person_outline,color: Colors.black),iconSize: 30.0, onPressed: ()=>_navigationTapped(0)),
                  new IconButton(icon: new CircleAvatar(radius: 30.0,backgroundColor: _page==1?Colors.black38.withOpacity(0.7):Colors.black38,child: Image(image: AssetImage("images/logo.png"),color:Colors.white,)),iconSize: 60.0, onPressed: ()=>_navigationTapped(1)),
                  new IconButton(icon: new Icon(_page==2?Icons.chat:Icons.chat_bubble_outline,color: Colors.black,),iconSize: 25.0,onPressed: ()=>_navigationTapped(2)),
                ],
              ),
            )
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loaded = false;
    _pageController.dispose();
  }
}

