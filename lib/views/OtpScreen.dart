import 'dart:async';
import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';
import '../resources/FireBaseDBResources.dart';
import 'StartUpLoader.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpScreen extends StatefulWidget{
  final String generatedOtp;
  final String myNumber;

  OtpScreen({this.generatedOtp,this.myNumber});

  @override
  _OtpScreenState createState() => new _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> with TickerProviderStateMixin{
  TextEditingController otp = new TextEditingController();
  SharedPreferences sharedPreferences;
  bool _loggedIn;
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

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
   return new Scaffold(
     key: _scaffoldKey,
     resizeToAvoidBottomPadding: true,
     backgroundColor: Colors.white,
     body: Container(
       decoration: BoxDecoration(
         gradient: myGradient
       ),
       child: new Stack(
           fit: StackFit.expand,
           children: <Widget>[
             new Column(
               mainAxisAlignment: MainAxisAlignment.center,
               children: <Widget>[
                 Text("Namaste",style: new TextStyle(fontSize: 100.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
                 new Container(
                   padding: const EdgeInsets.all(40.0),
                   child: new Form(
                     autovalidate: true,
                     child: new Column(
                       mainAxisAlignment: MainAxisAlignment.start,
                       children: <Widget>[
                         Text("Enter the 4 digit OTP received by sms"),
                         _buildInputBox(),
                         _actionButtons()
                   ]
                 )
               )
             )
           ]
         )
       ]
       ),
     )
   );
  }


  Widget _actionButtons(){
    return new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          new MaterialButton(
            height: 50.0,
            minWidth: 150.0,
            color: Colors.green,
            splashColor: Colors.teal,
            textColor: Colors.white,
            child: Row(
              children: <Widget>[
                new Text("Submit"),
                new Icon(Icons.play_arrow),
              ],
            ),
            onPressed: () {
              if(otp.text == widget.generatedOtp){
                setState(() {
                  String myNum = widget.myNumber;
                  new FireBaseDB().addToDb(myNum);
                  print("mynumber $myNum");
                  sharedPreferences.setString("myNumber", myNum);
                  _loggedIn = true;
                  persist(_loggedIn);
                });
                _rootPage();
              }else{
                _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("wrong otp!!")));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: new MaterialButton(
              height: 50.0,
              minWidth: 130.0,
              color: Colors.green,
              splashColor: Colors.teal,
              textColor: Colors.white,
              child: Row(
                children: <Widget>[
                  new Text("Resend"),
                  new Icon(Icons.refresh),
                ],
              ),
              onPressed: ()
              {
                _rootPage();
              },
            ),
          )
        ]
    );
  }

  Widget _buildInputBox() {
    return Container(
      alignment: Alignment.bottomCenter,
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: TextField(
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        controller: otp,
        maxLengthEnforced: true,
        maxLength: 4,
        style: TextStyle(fontSize: 32.0, color:  Colors.black,),
        decoration: InputDecoration(
          border: InputBorder.none,
          suffixIcon: Icon(Icons.vpn_key,color: Colors.black,),
          counterStyle: TextStyle(fontSize: 0.0),
          enabled: true,
          filled: true,
          hintStyle: TextStyle(fontSize: 32.0,fontWeight: FontWeight.bold,letterSpacing: 10.0),
          hintText: "----",
        ),
      ),
    );
  }

  Future _rootPage(){
    return Navigator.of(context).push(new MaterialPageRoute(
        builder: (context)=> new StartUpLoader()
    )
    );
  }


}