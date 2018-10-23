import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';
import 'NamasteHome.dart';
import 'OtpScreen.dart';
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
  var _scaffoldKey = new GlobalKey<ScaffoldState>();


  String generateRandomAuthCode() {
    var rng = new Random();
    String authCode = rng.nextInt(10000).toString();
    print("created auth code:");
    print(authCode);
    return authCode;
  }

  String sendOTP(String number) {
    String otp = generateRandomAuthCode();
    Map<String,String> to = {"phoneNumber":"$number"};
    Map<String,dynamic> sms = {"from":"NAMASTE","allowUnicode":true};
    OtpData data =
    new OtpData(rules:["sms"], body:"This is your OTP to login to Namaste: $otp", to:to, channelOptions: new ChannelOptions(sms: sms));
    print(data);
    http.post("https://api.comapi.com/apispaces/a18af796-03b7-4189-959b-193f0622e905/messages",
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
    return otp;
  }
  void _checkIfAlreadyRegistered(String number, BuildContext context) async{
    var temp;
    await http.get("https://namaste-backend.herokuapp.com/users/uphone/"+number,
    ).then((response) {
      temp = response.body;
      print(" bodyx: $temp");
    }).whenComplete((){
      print("checked db");
      if(temp.toString().contains("exist")){
        print('register first');
        Scaffold.of(context).showSnackBar(SnackBar(content: Text("Register First")));
      }else{
        String generatedOtp = sendOTP(number);
        _otpPage(generatedOtp,number);
      }
    }).catchError((e)=>print(e));
  }


  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
  }



  @override
  Widget build(BuildContext context) {
    var _screenSize = MediaQuery.of(context).size;
    return new WillPopScope(
        onWillPop: (){
          NamasteHome.exitApp(context);
        },
        child: Scaffold(
          key: _scaffoldKey,
          body: new Container(
            decoration: BoxDecoration(
              gradient: myGradient
            ),
            child: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Namaste",style: new TextStyle(fontSize: _iconAnimation.value * 100.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
                        new Container(
                          padding: const EdgeInsets.all(40.0),
                          child: new Form(
                            autovalidate: true,
                            child: new Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                new TextField(
                                  textAlign: TextAlign.center,
                                  decoration: new InputDecoration(labelText: "Enter Number",labelStyle: TextStyle(fontSize: 25.0,color: Colors.teal),fillColor: Colors.white),
                                  keyboardType: TextInputType.phone,
                                  controller:  number,
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
                                  child: Row(
                                    children: <Widget>[
                                      Text("Login"),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: new Icon(Icons.forward),
                                      )
                                    ],
                                  ),
                                  onPressed: () {
                                    if(number.text.length>11){
                                      print("here");
                                      _checkIfAlreadyRegistered(number.text,context);
                                    }else{
                                      print("snackbar");
                                      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("type in valid phone number")));
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    Positioned(
                      bottom: 30.0,
                      left: _screenSize.width/2,
                      child: MaterialButton(
                        height: 50.0,
                        minWidth: 150.0,
                        color: Colors.green,
                        splashColor: Colors.teal,
                        textColor: Colors.white,
                        child: Row(
                          children: <Widget>[
                            new Icon(Icons.add_circle),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text("Register"),
                            ),
                          ],
                        ),
                        onPressed: () {

                        },
                      ),
                    )
                  ]
              ),
          ),
        )
    );
  }


  Future _otpPage(String generatedOtp,String myNumber){
    return Navigator.of(context).push(new MaterialPageRoute(
        builder: (context)=> new OtpScreen(generatedOtp:generatedOtp,myNumber: myNumber,)
    )
    );
  }
}
class ChannelOptions{
  final Map<String,dynamic> sms;
  ChannelOptions({this.sms});
  Map<String, dynamic> toJson() => {
    'sms':sms
  };
}
class OtpData{
  final List<String> rules;
  final String body;
  final ChannelOptions channelOptions;
  final Map<String,String> to;
  OtpData({this.rules,this.body,this.to,this.channelOptions});
  Map<String, dynamic> toJson() => {
    'rules': rules,
    'body': body,
    'to': to,
    'channelOptions':channelOptions
  };
}