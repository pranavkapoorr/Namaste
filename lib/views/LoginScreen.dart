import 'package:flutter/material.dart';
import 'package:flutter_app/views/NamasteHome.dart';
import 'package:flutter_app/views/StartUpLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  TextEditingController number = new TextEditingController();
  TextEditingController pass = new TextEditingController();

  SharedPreferences sharedPreferences;
  bool _loggedIn;

  String generateRandomAuthCode() {
    var rng = new Random();
    String authCode = rng.nextInt(10000).toString();
    print("created auth code:");
    print(authCode);
    return authCode;
  }

  void sendOTP(String number) {
    String otp = generateRandomAuthCode();
    Map<String,String> to = {"phoneNumber":"$number"};
    OtpData data =
    new OtpData(rules:["sms"], body:"This is your OTP to login to Namaste: $otp", to:to);
    var  response =  http.post("https://api.comapi.com/apispaces/a18af796-03b7-4189-959b-193f0622e905/messages",
      headers: {
        "Content-Type":"application/json",
        "Authorization":"Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
        "Accept":"application/json"
      },
      body: json.encode(data),
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).whenComplete((){
  print("sent OTP: $otp to $number ");
  }).catchError((e)=>print(e));
  }


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
                            decoration: new InputDecoration(labelText: "Enter Number", fillColor: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                            controller:  number,
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
                              if(number.text=="447488706094" && pass.text=="pass"){
                                setState(() {
                                  //sendOTP(number.text );
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
class OtpData{
  final List<String> rules;
  final String body;
  final Map<String,String> to;
  OtpData({this.rules,this.body,this.to});
  Map<String, dynamic> toJson() => {
    'rules': rules,
    'body': body,
    'to': to
  };
}