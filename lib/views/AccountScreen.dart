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
          appBar: new AppBar(title: new Text("Account",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                borderRadius:  BorderRadius.all(Radius.circular(5.0))
            ),
            child: ListView(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),color: Colors.white,),
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
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
                            new Divider(height: 1.0,color: Colors.black,),
                            new ListTile(leading: new Icon(Icons.delete_outline,color:Colors.redAccent),title: new Text("Delete Your Account"),trailing: Icon(Icons.navigate_next),),
                            new Divider(height: 1.0,color: Colors.black,),
                            new ListTile(leading: new Icon(Icons.business_center,color:Colors.amber),title: new Text("Terms & Conditions"),trailing: Icon(Icons.navigate_next),)
                          ]
                  ),
                    ),
              ],
            ),
            ),
          )
    );
  }
  Future _rootPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new StartUpLoader()));
  }
}

