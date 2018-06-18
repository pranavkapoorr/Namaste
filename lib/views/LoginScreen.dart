import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';
import 'dart:async';
import 'package:flutter_app/views/NamasteHome.dart';
import 'package:flutter_app/views/StartUpLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  TextEditingController uname = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  SharedPreferences sharedPreferences;
  bool _loggedIn;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _loggedIn = sharedPreferences.getBool("LoggedIn");
    });
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }

  void persist(bool value) {
    setState(() {
      _loggedIn = value;
    });
    sharedPreferences?.setBool("LoggedIn", value);
  }

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
        onWillPop: (){
          NamasteHome.exitApp(context);
        },
        child: new Scaffold(
          backgroundColor: Colors.white,
          body: new Stack(fit: StackFit.expand, children: <Widget>[
            new Image(
              image: new AssetImage("images/bg.jpg"),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black87,
            ),
            new Theme(
              data: new ThemeData(
                  brightness: Brightness.dark,
                  inputDecorationTheme: new InputDecorationTheme(
                    // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                    labelStyle:
                    new TextStyle(color: Colors.tealAccent, fontSize: 25.0),
                  )),
              isMaterialAppTheme: true,
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new FlutterLogo(
                    size: _iconAnimation.value * 140.0,
                  ),
                  new Container(
                    padding: const EdgeInsets.all(40.0),
                    child: new Form(
                      autovalidate: true,
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new TextFormField(
                            decoration: new InputDecoration(labelText: "Enter Email", fillColor: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            controller:  uname,
                          ),
                          new TextFormField(
                            decoration: new InputDecoration(labelText: "Enter Password",),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            controller: pass,
                          ),
                          new Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                          ),
                          new MaterialButton(
                            height: 50.0,
                            minWidth: 150.0,
                            color: Colors.green,
                            splashColor: Colors.teal,
                            textColor: Colors.white,
                            child: new Icon(Icons.adjust),
                            onPressed: () {
                              if(uname.text=="pk" && pass.text=="pass"){
                                setState(() {
                                  _loggedIn = true;
                                  persist(_loggedIn);
                                });
                                _rootPage();
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]),
        )
    );
  }


  Future _rootPage(){
    return Navigator.of(context).push(new MaterialPageRoute(
        builder: (context)=> new StartUpLoader()
        )
    );
  }
}