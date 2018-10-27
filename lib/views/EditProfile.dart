import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/resources/mynetworkres.dart';
import 'package:Namaste/views/AlbumEditor.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_native_image/flutter_native_image.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}
class _EditProfileState extends State<EditProfile>{
  var _scaffoldKey = new GlobalKey();
  TextEditingController name,username,about,location;
  String _gender,_radioValue;
  File imageFile;

  String imageUrl;

  @override
  void initState() {
    name = new TextEditingController();
    username = new TextEditingController();
    about = new TextEditingController();
    location = new TextEditingController();
    imageUrl = myProfile.me['dp'];
    name.text = myProfile.me['name'];//myProfile.me['name'];
    username.text = myProfile.me['username'];//myProfile.me['username'];
    about.text = myProfile.me['about'];//myProfile.me['about'];
    location.text = myProfile.me['location'];//myProfile.me['location'];
    _radioValue = myProfile.me['gender'];//myProfile.me['gender'];

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
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: new AppBar(elevation: 0.0,leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){
              _updateMyDetails();
              Navigator.pop(context);
            }),title: new Text("Edit Profile",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
            body: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(

                  borderRadius:  BorderRadius.all(Radius.circular(5.0))
              ),
              child:new ListView(
                  children: <Widget>[ Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                  color: Colors.blueGrey.shade100,),
                child:
                      new Column(
                        children: <Widget>[
                          InkWell(
                            onTap: getImage,
                            child: Container(
                              margin: EdgeInsetsDirectional.only(top: 5.0),
                              child: Stack(
                              children: <Widget>[
                                CircleAvatar(backgroundColor: Colors.black45,backgroundImage: NetworkImage(imageUrl),
                                  radius: 60.0,),
                                Positioned(right: 0.0,bottom:0.0,child: Icon(Icons.add_a_photo,color: Colors.black,))
                            ],
                            ),
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
                                                    border: InputBorder.none,
                                                    counterText: "",
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
    String _updateUrl = "https://namaste-backend.herokuapp.com/users/" + myProfile.me['_id'];
    Map _data = {
      "name": name.text,
      "email": myProfile.me['email'],
      "phone": myProfile.me['phone'],
      "gender": _radioValue,
      "dob": myProfile.me['dob'],
      "dp": myProfile.me['dp'],
      "location": location.text,
      "about": about.text,
      "username": username.text,
      "password": myProfile.me['password'],
      "likes": myProfile.me['likes'],
      "dislikes": myProfile.me['dislikes']
    };
    if(myProfile.me['name']!=_data['name']||myProfile.me['gender']!=_data['gender']||myProfile.me['location']!=_data['location']||
        myProfile.me['about']!=_data['about']||myProfile.me['username']!=_data['username']) {
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
          myProfile.getMyDetails().whenComplete((){
              print("exiting");
              return Future.value(true);
          });
        }else{
          return Future.value(false);
        }
      }).whenComplete(() {

        print("details updated");
      });

    }
    return Future.value(false);
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        print("Image is: $image");
        imageFile = image;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = myProfile.me['username']+".jpg";
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask upload = await reference.putFile(imageFile);

    await upload.onComplete.whenComplete(() {
      setState(() {
        imageUrl = "https://firebasestorage.googleapis.com/v0/b/testfirebase-d40b1.appspot.com/o/"+fileName+"?alt=media&token=eddfcbce-47df-4c7d-a6a9-45e59a337f5e";
      });
      Map data = {
        "name": name.text,
        "email": myProfile.me['email'],
        "phone": myProfile.me['phone'],
        "gender": _radioValue,
        "dob": myProfile.me['dob'],
        "dp": imageUrl,
        "location": location.text,
        "about": about.text,
        "username": username.text,
        "password": myProfile.me['password'],
        "likes": myProfile.me['likes'],
        "dislikes": myProfile.me['dislikes']
      };
      myProfile.updateMyDetails(data);
    });
  }
   _compressImage(File file) async{
    File _compressed =  await FlutterNativeImage.compressImage(file.path,
        quality: 50, percentage: 90);
    return _compressed;
  }
  @override
  void dispose() {
    name.dispose();
    username.dispose();
    about.dispose();
    super.dispose();
  }
}