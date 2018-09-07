import 'dart:convert';

import 'package:Namaste/views/AlbumEditor.dart';
import 'package:http/http.dart' as http;
import 'EditProfile.dart';
import 'Settings_Screen.dart';
import 'package:flutter/material.dart';
import 'package:carousel/carousel.dart';
class Profile extends StatefulWidget {
  final String myNumber;

  Profile(this.myNumber);

  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> {
  final double _appBarHeight = 267.0;
  Carousel carouselX;
  var _me;
  bool _loaded = false;

  @override
  initState(){
    super.initState();
    _getMyDetails();
    carouselX = new Carousel(
      displayDuration: Duration(seconds: 5),
      children: [
        AssetImage("images/bg.jpg"),
        AssetImage("images/bg.jpg")
      ].map((netImage) => new Image(image: netImage,fit: BoxFit.cover,height: _appBarHeight,)).toList(),
    );
  }
  void _getMyDetails() async{
    var temp;
    print("my num is ${widget.myNumber}");
    await http.get("http://192.168.0.26:5000/users/uphone/"+ widget.myNumber,
    ).then((response) {
      temp = json.decode(response.body);
      print(" bodyx: $temp");
      _me = temp;
    }).whenComplete(() {
      print("checked db");
      setState(() {
        _loaded = true;
      });

    });
  }


  @override
  Widget build(BuildContext context) {
    return _loaded?Container(
      padding: EdgeInsetsDirectional.only(top: 15.0,start: 10.0 ,end: 10.0),
      color: Colors.transparent,
      child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
              SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(icon: Icon(Icons.mode_edit,color: Colors.white,), onPressed: (){
                _goToEditPage();
              }),
              expandedHeight: _appBarHeight,
              pinned: true,
              floating: true,
              actions: <Widget>[
                new IconButton(icon: Icon(Icons.settings,color:Colors.white,), onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new SettingsScreen()));
                })
              ],
              flexibleSpace: new FlexibleSpaceBar(
                title:  Text(_me['name'],style: TextStyle(color: Colors.white),),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                        Container(
                          color: Colors.transparent.withOpacity(0.4),
                            padding: EdgeInsetsDirectional.only(bottom: 1.0),
                            child: carouselX
                        ),
                    const DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: const LinearGradient(
                          begin: const Alignment(0.0, -1.0),
                          end: const Alignment(0.0, -0.4),
                          colors: const <Color>[const Color(0x60000000), const Color(0x00000000)],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 55.0),
                      child: new Align(
                        alignment: FractionalOffset.center,
                        heightFactor: 1.4,
                        child: new Column(
                          children: <Widget>[
                            new CircleAvatar(
                              radius: 45.0,
                              backgroundImage: NetworkImage(_me['dp']),
                            ),
                            _buildFollowerInfo(),
                            _buildActionButtons(Theme.of(context)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];},
          body: ListView(
            shrinkWrap: true,
              children: <Widget>[
                //Scaffold(
                //backgroundColor: Colors.blueGrey.shade100,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: Colors.white70),
                      child: Column(
                        children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Text("Location",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(Icons.place,color: Colors.red,),
                            new Text(
                              _me['location'],
                              style:
                              new TextStyle(color: Colors.black38, fontSize: 15.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                    GestureDetector(
                      onTap: _goToEditPage,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsetsDirectional.only(top: 5.0),
                      decoration: BoxDecoration(color: Colors.white70),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text("Personal Info",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                              new Icon(Icons.navigate_next)
                            ],
                          ),
                          new Text(
                            _me['about'],
                            style:
                            new TextStyle(color: Colors.black38, fontSize: 13.0),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsetsDirectional.only(top: 5.0),
                    decoration: BoxDecoration(color: Colors.white70),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _goToAlbumUploader,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Text("Album",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                              new Icon(Icons.navigate_next)
                            ],
                          ),
                        ),
                        new Container(
                          height: 100.0,
                          child: _album(),
                        )
                      ],
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: new Row(
                      children: <Widget>[
                        _createCircleBadge(Icons.beach_access, Colors.black12),
                        _createCircleBadge(Icons.cloud, Colors.black12),
                        _createCircleBadge(Icons.shop, Colors.black12),
                      ],
                    ),
                  ),
                ],
                ),
              ],
            ),
        ),
    ):Center(child: CircularProgressIndicator(),);
  }
  void _goToEditPage(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new EditProfile()));
  }
  void _goToAlbumUploader(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new AlbumUploader()));
  }
  Widget _createPillButton(
      String text, {
        Color backgroundColor = Colors.transparent,
        Color textColor = Colors.white70,
      }) {
    return new ClipRRect(
      borderRadius: new BorderRadius.circular(30.0),
      child: new MaterialButton(
        minWidth: 120.0,
        color: backgroundColor,
        textColor: textColor,
        onPressed: () {},
        child: new Text(text),
      ),
    );
  }
  Widget _buildActionButtons(ThemeData theme) {
    return new Padding(
      padding: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new DecoratedBox(
            decoration: new BoxDecoration(
            border: new Border.all(color: Colors.white30),
            borderRadius: new BorderRadius.circular(30.0),
            ),
          child:_createPillButton(
            'HIRE ME',
            backgroundColor: Colors.transparent,
          ),
          ),
          new DecoratedBox(
            decoration: new BoxDecoration(
              border: new Border.all(color: Colors.white30),
              borderRadius: new BorderRadius.circular(30.0),
            ),
            child: _createPillButton(
              'FOLLOW',
              textColor: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFollowerInfo() {
    return new Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text('90 Following',style: new TextStyle(color: Colors.white70),),
          new Text(' | '),
          new Text('100 Followers',style: new TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }


  Widget _createCircleBadge(IconData iconData, Color color) {
    return new Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: new CircleAvatar(
        backgroundColor: color,
        child: new Icon(
          iconData,
          color: Colors.black,
          size: 16.0,
        ),
        radius: 16.0,
      ),
    );
  }
  Widget _albumImage(Image image){
    return  GestureDetector(onTap:(){onImageTap(image);},child: Container(margin: EdgeInsets.all(1.0),child:image));
  }
  Widget _album() {
    List<Widget> images = [
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg")))
    ];
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: new ListView(
          scrollDirection: Axis.horizontal,
          children: images
      ),
    );
  }
  void onImageTap(Image img){
    showDialog(context: this.context,builder:(BuildContext context)=>AlertDialog(content: Container(child: img,),contentPadding: EdgeInsets.all(0.0),));
  }
  @override
  void dispose() {
    _loaded = false;
    _me = null;
    carouselX = null;
    super.dispose();
  }
}