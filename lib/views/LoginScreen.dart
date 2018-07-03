import 'package:flutter/material.dart';
import 'package:flutter_app/views/NamasteHome.dart';
import 'package:flutter_app/views/OtpScreen.dart';
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
      body: JSON.encode(data),
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).whenComplete((){
  print("sent OTP: $otp to $number ");
  }).catchError((e)=>print(e));
    return otp;
  }


  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.bounceOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();
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
                            child: new Icon(Icons.adjust),
                            onPressed: () {
                              if(number.text.length>11){
                                String generatedOtp = sendOTP(number.text);
                                _otpPage(generatedOtp,number.text);
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