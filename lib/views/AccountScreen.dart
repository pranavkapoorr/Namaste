import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'StartUpLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountScreen extends StatefulWidget {

  @override
  _AccountScreenState createState()=>new _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen>{
  SharedPreferences sharedPreferences;
  bool _loggedIn;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _loggedIn = sharedPreferences.getBool("LoggedIn");
    });
  }

  void persist(bool value) {
    setState(() {
      _loggedIn = value;
    });
    sharedPreferences?.setBool("LoggedIn", value);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(gradient:myGradient,),
        child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(elevation:0.0,leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){Navigator.pop(context);}),title: new Text("Account",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
          body: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),color: Colors.white),
            child: new Column(
                children: <Widget>[
                      new ListTile(leading: new Icon(Icons.phone_android,color:Colors.green),title: new Text("Change Your Number"),
                        onTap: (){
                        setState(() {
                          _loggedIn = false;
                          persist(_loggedIn);
                        });
                          print("logged out");
                          _rootPage();

                        },trailing: Icon(Icons.navigate_next),),

                      new ListTile(leading: new Icon(Icons.delete_outline,color:Colors.redAccent),title: new Text("Delete Your Account"),trailing: Icon(Icons.navigate_next),),

                      new ListTile(leading: new Icon(Icons.business_center,color:Colors.amber),title: new Text("Terms & Conditions"),trailing: Icon(Icons.navigate_next),)
                    ]
            ),
              ),
          )
    );
  }
  Future _rootPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new StartUpLoader()));
  }
}

