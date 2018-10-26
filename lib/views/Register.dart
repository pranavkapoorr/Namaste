import 'dart:convert';

import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/views/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController name,username,number,email;

  @override
  void initState() {
    name = new TextEditingController();
    username = new TextEditingController();
    number = new TextEditingController();
    email = new TextEditingController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      body: new Container(
        decoration: BoxDecoration(
            gradient: myGradient
        ),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text("Namaste",style: new TextStyle(fontSize: 50.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
            Expanded(
              flex: 0,
              child: new Container(
                padding: const EdgeInsets.symmetric(horizontal:40.0),
                child: new Column(
                  children: <Widget>[
                    new TextField(
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(labelText: "Full Name",labelStyle: TextStyle(fontSize: 22.0,color: Colors.teal),fillColor: Colors.white,suffixIcon: Icon(Icons.person)),
                      keyboardType: TextInputType.text,
                      controller:  name,
                    ),
                    new TextField(
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(labelText: "Username",labelStyle: TextStyle(fontSize: 22.0,color: Colors.teal),fillColor: Colors.white,suffixIcon: Icon(Icons.verified_user)),
                      keyboardType: TextInputType.text,
                      controller:  username,
                    ),
                    new TextField(
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(labelText: "Number",labelStyle: TextStyle(fontSize: 22.0,color: Colors.teal),fillColor: Colors.white,suffixIcon: Icon(Icons.phone)),
                      keyboardType: TextInputType.phone,
                      controller:  number,
                    ),
                    new TextField(
                      textAlign: TextAlign.center,
                      decoration: new InputDecoration(labelText: "Email",labelStyle: TextStyle(fontSize: 22.0,color: Colors.teal),fillColor: Colors.white,suffixIcon: Icon(Icons.email)),
                      keyboardType: TextInputType.emailAddress,
                      controller:  email,
                    ),
                    new SizedBox(height: 10.0,),
                    new MaterialButton(
                      height: 50.0,
                      minWidth: 150.0,
                      color: Colors.green,
                      splashColor: Colors.teal,
                      textColor: Colors.white,
                      child: Row(
                        children: <Widget>[
                          Text("Join"),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Icon(Icons.add_circle),
                          )
                        ],
                      ),
                      onPressed: register
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black45.withOpacity(0.2)
                      ),
                      margin: const EdgeInsets.only(top:8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text("Already a user..?",style: TextStyle(color: Colors.white),),
                          MaterialButton(
                              height: 20.0,
                              minWidth: 150.0,
                              color: Colors.green,
                              splashColor: Colors.teal,
                              textColor: Colors.white,
                              child: Row(
                                children: <Widget>[
                                  new Icon(Icons.forward),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text("Login"),
                                  ),
                                ],
                              ),
                              onPressed: (){
                                _loginPage();
                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future register() async{
    Map _data = {
      "name": name.text,
      "email": email.text,
      "phone": number.text,
      "gender": "Male",
      "dob": "01/01/0001",
      "dp": "https://upload.wikimedia.org/wikipedia/commons/9/93/Default_profile_picture_%28male%29_on_Facebook.jpg",
      "location": "undefined",
      "about": "",
      "username": username.text,
      "password": "12345",
      "likes": [],
      "dislikes": []
    };
    return http.post("https://namaste-backend.herokuapp.com/user",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
          "Accept": "application/json"
        },
        body: json.encode(_data)
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if(response.statusCode==200&& response.body.contains('"name"')){
        _showSnackBar("registered successfully");
      }
      //temp = json.decode(response.body);
      //print(" body: $temp");
    }).whenComplete(() {

    }).catchError((e)=>_showSnackBar(e.toString()));
  }
  Future _loginPage(){
    return Navigator.of(context).push(new MaterialPageRoute(
        builder: (context)=> new LoginPage()));
  }
  _showSnackBar(String text){
    _scaffoldKey.currentState.showSnackBar(new SnackBar(content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Icon(Icons.pan_tool),
        Text(text),
      ],
    )));
  }

  @override
  void dispose() {
    name.dispose();
    username.dispose();
    number.dispose();
    email.dispose();
    super.dispose();
  }
}