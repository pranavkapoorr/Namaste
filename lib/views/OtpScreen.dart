import 'dart:async';
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

class _OtpScreenState extends State<OtpScreen>{
  TextEditingController otp = new TextEditingController();
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
   return new Scaffold(
     backgroundColor: Colors.white,
     body: new Stack(fit: StackFit.expand, children: <Widget>[
       new Image(
         image: new AssetImage("images/bg.jpg"),
         fit: BoxFit.cover,
         colorBlendMode: BlendMode.darken,
         color: Colors.black87,
       ),
       new Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: <Widget>[
           new Container(
             padding: const EdgeInsets.all(40.0),
             child: new Form(
               autovalidate: true,
               child: new Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: <Widget>[
                   Theme(
                     data: ThemeData.dark(),
                     child: new TextFormField(
                       decoration: new InputDecoration(labelText: "Enter OTP",labelStyle: TextStyle(fontSize: 25.0,color: Colors.teal), fillColor: Colors.white),
                       keyboardType: TextInputType.number,
                       controller:  otp,
                     ),
                   ),
                   new Padding(
                     padding: const EdgeInsets.only(top: 60.0),
                   ),
                   new Column(
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
                   )
                 ]
               )
             )
           )
         ]
       )
     ]
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