import 'dart:async';
import 'dart:convert';

import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/views/AlbumEditor.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class EditProfile extends StatefulWidget {
  final Map user;

  EditProfile({this.user});

  @override
  _EditProfileState createState() => new _EditProfileState();
}
class _EditProfileState extends State<EditProfile>{
  TextEditingController name,username,about,location;
  String _gender,_radioValue;

  @override
  void initState() {
    name = new TextEditingController();
    username = new TextEditingController();
    about = new TextEditingController();
    location = new TextEditingController();
    name.text = widget.user['name'];
    username.text = widget.user['username'];
    about.text = widget.user['about'];
    location.text = widget.user['location'];
    _radioValue = widget.user['gender'];

    super.initState();
  }

  void _handleGenderChange(String value){
    setState(() {
      _radioValue = value;
      switch (_radioValue) {
        case "Male":
          _gender = "Male";
          break;
          case "Female":
          _gender = "Female";
          break;
    }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _updateMyDetails,
      child: Container(
        decoration: BoxDecoration(gradient:myGradient,),
        child: new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){
              _updateMyDetails();
              Navigator.pop(context);
            }),title: new Text("Edit Profile",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
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
              child:new ListView(
                  children: <Widget>[ Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                  color: Colors.blueGrey.shade100,),
                child:
                      new Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsetsDirectional.only(top: 5.0),
                            child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  CircleAvatar(backgroundImage: NetworkImage(widget.user['dp']),
                                    radius: 45.0,)
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.only(top: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                DecoratedBox(
                                  decoration: new BoxDecoration(
                                  border: new Border.all(color: Colors.redAccent),
                                  borderRadius: new BorderRadius.circular(20.0),
                                  ),
                                  child:  MaterialButton(onPressed: (){},child: Text("Change Picture"),elevation: 2.0,color: Colors.redAccent,)
                              )
                                ],
                              ),
                            )
                          ],
                          ),
                        ),
                        Container(
                          color: Colors.white70,
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 5.0),
                          child: Column(
                            children: <Widget>[
                              Row(children: <Widget>[Text("General",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),

                          new ListTile(leading:Icon(Icons.contact_mail,color: Colors.redAccent,),title: TextField(decoration: InputDecoration.collapsed(hintText: "username"),controller: username,)),
                          new Divider(height: 0.1,color: Colors.grey.shade400,),
                          new ListTile(leading: new Icon(Icons.person,color:Colors.green),title:TextField(decoration: InputDecoration.collapsed(hintText: "Full name"),controller: name,)),
                              new ListTile(leading: new Icon(Icons.location_on,color:Colors.red),title:TextField(decoration: InputDecoration.collapsed(hintText: "Location"),controller: location,)),
                          new Divider(height: 0.1,color: Colors.grey.shade400,),
                          new ListTile(leading: new Icon(Icons.wc,color:Colors.amberAccent),title:Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Radio(value: "Male",groupValue: _radioValue,onChanged: _handleGenderChange,),Text("Male"),
                              Radio(value: "Female",groupValue: _radioValue,onChanged: _handleGenderChange,),Text("Female")
                            ],
                          )),
                          ]),
                        ),
                          GestureDetector(
                            onTap: _goToAlbumUploader,
                            child: Container(
                              color: Colors.white70,
                              padding: EdgeInsets.all(10.0),
                              margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 5.0),
                              child: Column(
                                  children: <Widget>[
                                    Row(children: <Widget>[Text("Album",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),
                                    Column(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Icon(Icons.image,size: 35.0,color: Colors.redAccent,),
                                            Container(
                                              height: 50.0,
                                              constraints: BoxConstraints(maxWidth: 260.0,maxHeight: 50.0),
                                              child: _album(),
                                            ),
                                            Icon(Icons.navigate_next)
                                          ],
                                        ),
                                      ],
                                    )
                                  ]
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white70,
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 15.0),
                            child: Column(
                                children: <Widget>[
                                  Row(children: <Widget>[Text("About Me",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),
                                  Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Icon(Icons.description,color: Colors.green,size: 35.0,),
                                          Container(
                                              constraints: BoxConstraints(maxWidth: 200.0,maxHeight: 90.0),
                                              child:TextField(
                                                controller: about,
                                                decoration: InputDecoration(
                                                    hintText: "short bio",
                                                    border: InputBorder.none
                                                ),
                                                maxLines: 5,
                                                maxLength: 150,
                                                maxLengthEnforced: true,
                                                enabled: true,
                                                keyboardType: TextInputType.multiline,
                                              )
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ]
                            ),
                          )

                      ],
                    )
                  )]
                ),

            )
        ),
      ),
    );
  }
  Widget _albumImage(Image image){
    return  GestureDetector(onTap:(){},child: Container(margin: EdgeInsets.all(1.0),child:image));
  }
  Widget _album() {
    List<Widget> images = [
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),

    ];
    return Container(
      child: new ListView(
          scrollDirection: Axis.horizontal,
          children: images
      ),
    );
  }
  void _goToAlbumUploader(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new AlbumUploader()));
  }

  Future<bool> _updateMyDetails() async{
    String _updateUrl = "http://192.168.0.26:5000/users/" + widget.user['_id'];
    Map _data = {
      "name": name.text,
      "email": widget.user['email'],
      "phone": widget.user['phone'],
      "gender": _radioValue,
      "dob": widget.user['dob'],
      "dp": widget.user['dp'],
      "location": location.text,
      "about": about.text,
      "username": username.text,
      "password": widget.user['password']
    };
    if(widget.user['name']!=_data['name']||widget.user['gender']!=_data['gender']||widget.user['location']!=_data['location']||
        widget.user['about']!=_data['about']||widget.user['username']!=_data['username']) {
      await http.put(_updateUrl,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
          "Accept": "application/json"
        },
        body: json.encode(_data),
      ).then((response) {
        print('response -> ${response.statusCode}');
        if(response.statusCode == 200){
          return Future.value(true);
        }else{
          return Future.value(false);
        }

      }).whenComplete(() {
        print("details updated");
      });

    }
    return Future.value(false);
  }
  @override
  void dispose() {
    name.dispose();
    username.dispose();
    about.dispose();
    super.dispose();
  }
}