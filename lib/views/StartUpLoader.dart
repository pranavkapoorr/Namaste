import 'package:flutter/material.dart';
import 'package:flutter_app/resources/FireBaseDBResources.dart';
import 'package:flutter_app/views/LoginScreen.dart';
import 'package:flutter_app/views/NamasteHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StartUpLoader extends StatefulWidget{

  _StartUpLoaderState createState() => new _StartUpLoaderState();

}

class _StartUpLoaderState extends State<StartUpLoader>{
  SharedPreferences sharedPreferences;
  bool _loggedIn;
  StatefulWidget _startScreen;
  bool _loading;
  FireBaseDB db;

  @override
  void initState() {
    super.initState();
    _loading = true;
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _loggedIn = sharedPreferences.getBool("LoggedIn");
      // will be null if never previously saved
      if (_loggedIn == null) {
        _loggedIn = false;
        persist(_loggedIn); // set an initial value
        _startScreen = new LoginPage();
      }else if(_loggedIn == false){
        _startScreen = new LoginPage();
      }else if(_loggedIn == true){
        _startScreen = new NamasteHome();
      }
      //Navigator.of(context).push(new MaterialPageRoute(
        //  builder: (context)=> _startScreen));
    }).whenComplete((){
      setState(() {
        _loading = false;
      });
    }).catchError((e)=>print(e));
  }

  void persist(bool value) {
    setState(() {
      _loggedIn = value;
    });
    sharedPreferences?.setBool("LoggedIn", value);
  }

  @override
  Widget build(BuildContext context) {
    if(_loading == true){
      return new Scaffold(
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               new CircularProgressIndicator(strokeWidth: 5.0)
                ],
            ),
            new Padding(padding: new EdgeInsetsDirectional.only(top: 15.0)),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
              new Text("loading...",style: new TextStyle(fontSize: 25.0,color: Colors.grey),)
              ],
            ),
          ],)
      );
    }else{
      return _startScreen;
    }
  }

}