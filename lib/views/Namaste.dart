import 'dart:async';

import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/resources/mynetworkres.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Namaste extends StatefulWidget{
  @override
  _NamasteState createState()=> new _NamasteState();
}
class _NamasteState extends State<Namaste> {
  List<StatefulWidget> tiles = [];


  void callback(String buttonValue,String username) {
    if(buttonValue=="like"){
        _dislikeReq("like", username);
    }else if(buttonValue=="dislike"){
        _dislikeReq("dislike", username);
    }
    tiles.removeLast();
    setState(() {
      print(tiles.length);
    });
  }

  @override
  void initState() {
    //jugaad to load
    new Timer(const Duration(milliseconds: 2000), () {
      setState(() {
        print("done");
        _makeTilesX();
      });
    });
    super.initState();

  }

  void _dislikeReq(String likeOrDislike,String username){
    List tempVal = likeOrDislike=="dislike"?myProfile.dislikes:myProfile.likes;
    tempVal.add(username);
    Map _data = {
      "name": myProfile.me['name'],
      "email": myProfile.me['email'],
      "phone": myProfile.me['phone'],
      "gender": myProfile.me['gender'],
      "dob": myProfile.me['dob'],
      "dp": myProfile.me['dp'],
      "location": myProfile.me['location'],
      "about": myProfile.me['about'],
      "username": myProfile.me['username'],
      "password": myProfile.me['password'],
      "likes": likeOrDislike=="like"?tempVal:myProfile.likes,
      "dislikes": likeOrDislike=="dislike"?tempVal:myProfile.dislikes
    };
    myProfile.updateMyDetails(_data);
  }

  void _makeTilesX() async{
        tiles = myProfile.tiles.map((e) =>
            Dismissible(
                key: Key(e['username']),
                onDismissed: (direction) {
                  if (direction == DismissDirection.endToStart) {
                    /*List tempDislikes = myProfile.dislikes;
                    tempDislikes.add(e['username']);
                    Map _data = {
                      "name": myProfile.me['name'],
                      "email": myProfile.me['email'],
                      "phone": myProfile.me['phone'],
                      "gender": myProfile.me['gender'],
                      "dob": myProfile.me['dob'],
                      "dp": myProfile.me['dp'],
                      "location": myProfile.me['location'],
                      "about": myProfile.me['about'],
                      "username": myProfile.me['username'],
                      "password": myProfile.me['password'],
                      "likes": myProfile.likes,
                      "dislikes": tempDislikes
                    };
                    myProfile.updateMyDetails(_data);*/
                    _dislikeReq("dislike", e['username']);
                  } else if (direction == DismissDirection.startToEnd) {
                    /*List templikes = myProfile.likes;
                    templikes.add(e['username']);
                    Map _data = {
                      "name": myProfile.me['name'],
                      "email": myProfile.me['email'],
                      "phone": myProfile.me['phone'],
                      "gender": myProfile.me['gender'],
                      "dob": myProfile.me['dob'],
                      "dp": myProfile.me['dp'],
                      "location": myProfile.me['location'],
                      "about": myProfile.me['about'],
                      "username": myProfile.me['username'],
                      "password": myProfile.me['password'],
                      "likes": templikes,
                      "dislikes": myProfile.dislikes
                    };
                    myProfile.updateMyDetails(_data);*/
                    _dislikeReq("like", e['username']);
                  }
                  setState(() {
                    tiles.removeLast();
                    print('new length ${tiles.length}');
                  });
                },
                child: new ProfilePanel(
                    e['name'],
                    e['dp'],
                    e['gender'],
                    e['location'],
                    e['about'],
                    e['username'],
                    callback))).toList();
        setState(() {
        });

  }


  @override
  Widget build(BuildContext context){
    return  Scaffold(
        backgroundColor: Colors.transparent,
        appBar:_normalAppBar(),
        body: myProfile.loadedTiles?new Stack(
          children: tiles.length==0?[reloadPanel()]:tiles,
        ):Center(child: CircularProgressIndicator())
    );
  }


  Widget reloadPanel()=>Center(
    child: new Container(
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: ppGradient,
          color: Colors.white,
          border: Border.all(color: Colors.black26),
          boxShadow: [new BoxShadow(
              color: Colors.black12,
              offset: new Offset(2.0, 5.0),
              blurRadius: 1.0,
              spreadRadius: 1.0
          )],
          borderRadius:  BorderRadius.all(Radius.circular(10.0))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            //load my details first to update me.likes and dislikes,then load tiles data then make tiles
            onPressed:()=> myProfile.getMyDetails().whenComplete((){
            myProfile.getTiles().whenComplete((){
              _makeTilesX();
            });
          }), icon: Icon(Icons.refresh),iconSize: 80.0,),
          Text('Reload..?',style: TextStyle(fontSize:20.0,fontWeight: FontWeight.w500),)
        ],
      ),
    ),
  );

  AppBar _normalAppBar(){
    return new AppBar(
      centerTitle: true,
      leading: Text(""),
      title: new Text("Namaste",style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }



  @override
  void dispose() {
    tiles.clear();
    super.dispose();
  }
}
class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path p = new Path();
    p.lineTo(size.width, 0.0);
    p.lineTo(size.width, size.height * 0.85);
    p.arcToPoint(
      Offset(0.0, size.height * 0.85),
      radius: const Radius.elliptical(50.0, 10.0),
      rotation: 0.0,
    );
    p.lineTo(0.0, 0.0);
    p.close();
    return p;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
class ProfilePanel extends StatefulWidget {
  final String name, dp, gender, location, about,username;
  Function callback;

  ProfilePanel(this.name, this.dp, this.gender, this.location, this.about,this.username,this.callback);

  get id => username;
  
  _ProfilePanelState createState()=> new _ProfilePanelState();

}
class _ProfilePanelState extends State<ProfilePanel> with TickerProviderStateMixin{
  AnimationController _stampAnimController;
  Animation _stampSize;
  var buttonValue = "";
  

  @override
  void initState() {
    _stampAnimController = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _stampSize  = new CurvedAnimation(
      parent: _stampAnimController,
      curve: new Interval(
        0.100,
        0.400,
        curve: Curves.elasticOut,
      ),
    );
    _stampSize.addListener(() => this.setState(() {}));
    _stampAnimController.addStatusListener(statusListener);
    super.initState();
  }

  void statusListener(status){
    if(status==AnimationStatus.completed){
      widget.callback(buttonValue,widget.username);
    }
  }
  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        new Container(
          height: size.height/1.27,
          margin: EdgeInsets.fromLTRB(12.0,5.0,12.0,0.0),
          decoration: new BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black26),
              boxShadow: [new BoxShadow(
                  color: Colors.black12,
                  offset: new Offset(1.0, 2.0),
                  blurRadius: 0.2,
                  spreadRadius: 0.2
              )],
              borderRadius:  BorderRadius.all(Radius.circular(10.0))
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: size.height/2,
                  decoration: BoxDecoration(
                      gradient: ppGradient,
                      borderRadius:  BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      new Container(
                        height: 150.0,
                        width: 150.0,
                        constraints: new BoxConstraints(),
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            const BoxShadow(
                                offset: const Offset(1.0, 2.0),
                                blurRadius: 2.0,
                                spreadRadius: -1.0,
                                color: const Color(0x33000000)),
                            const BoxShadow(
                                offset: const Offset(2.0, 1.0),
                                blurRadius: 3.0,
                                spreadRadius: 0.0,
                                color: const Color(0x24000000)),
                            const BoxShadow(
                                offset: const Offset(3.0, 1.0),
                                blurRadius: 4.0,
                                spreadRadius: 2.0,
                                color: const Color(0x1F000000)),
                          ],
                          image: new DecorationImage(
                            fit: BoxFit.cover,
                            image: new NetworkImage(widget.dp),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: new Text(
                                widget.name ,
                                style: new TextStyle(fontSize: 25.0,color: Colors.black,fontWeight: FontWeight.w400),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: new CircleAvatar(
                                  foregroundColor: widget.gender=="Male"?Colors.blueAccent:Colors.pinkAccent,
                                  backgroundColor: Colors.transparent.withOpacity(0.2),
                                  child: new Text(widget.gender=="Male"?"M":"F",
                                    style: TextStyle(fontWeight: FontWeight.w700,fontStyle: FontStyle.italic),)
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(Icons.location_on,color: Colors.red,),
                            new Text(
                              widget.location,
                              style: new TextStyle(fontSize: 18.0,color: Colors.black,fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //image ends
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10.0,10.0,0.0,0.0),
                      child: new Text("About",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17.0),),
                    ),
                    new Padding(
                      padding:
                      const EdgeInsets.fromLTRB(10.0,10.0,10.0,15.0),
                      child: new Text(widget.about,
                        style: new TextStyle(color: Colors.black,fontSize: 14.0),
                      ),
                    ),
                  ],
                ),
              ),


              new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  new FloatingActionButton(
                    elevation: 10.0,
                    highlightElevation: 10.0,
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: ()=>_applyStamp("dislike"),
                    child: Icon(Icons.clear,color: Colors.red,),
                  ),
                  new FloatingActionButton(
                    elevation: 10.0,
                    highlightElevation: 10.0,
                    backgroundColor: Colors.white,
                    onPressed: ()=>_applyStamp("like"),
                    child: Icon(FontAwesomeIcons.heartbeat,color: Colors.green,size: 30.0,),
                  ),
                  new FloatingActionButton(
                    elevation: 10.0,
                    highlightElevation: 10.0,
                    mini: true,
                    backgroundColor: Colors.white,
                    onPressed: ()=>_applyStamp("star"),
                    child: Icon(Icons.star,
                      color: Colors.yellow.shade700,),
                  ),
                ],
              ),
            ],
          ),
        ),
        buttonValue=="like"?stamp(" NAMASTE ", Colors.green,size)
            :buttonValue=="dislike"?stamp(" DISLIKE ", Colors.red,size)
            :buttonValue=="star"?stamp(" SUPERLIKE ", Colors.blue,size):Text('')
      ],
    );
  }

  Widget stamp(String text,Color color,Size size)=>Positioned(
    bottom: size.height/3,
    left: size.width/3,
    child: Transform.rotate(
      angle: 250.8,
      child: new Container(
        decoration: BoxDecoration(
          border: Border.all(color: color,width: 2.0),
        ),
        transform: new Matrix4.diagonal3Values(
          _stampSize.value,
          _stampSize.value,
          1.0,
        ),
        child: Text(text,style: TextStyle(color: color,fontSize: 40.0,fontWeight: FontWeight.bold,),),
      ),
    ),
  );

  _applyStamp(String stamp){
    _stampAnimController.forward();
    setState(() {
      buttonValue = stamp;
    });
  }
  @override
  void dispose() {
    buttonValue = null;
    _stampAnimController.removeStatusListener(statusListener);
    _stampAnimController.dispose();
    super.dispose();
  }
}
