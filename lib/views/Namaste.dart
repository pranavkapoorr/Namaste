import 'dart:convert';
import 'dart:math';
import 'package:Namaste/resources/UiResources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


class Namaste extends StatefulWidget{
  @override
  _NamasteState createState()=> new _NamasteState();
}
class _NamasteState extends State<Namaste> with TickerProviderStateMixin{
  List<StatefulWidget> tiles = [];
  bool _loaded = false;
  Animation<double> _angleAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _controller;

  void callback() {
    tiles.removeLast();
    setState(() {
      print(tiles.length);
    });
  }

  @override
  void initState() {
    _setupLoadingAnim();

    _makeTilesX();
    super.initState();

  }
  void _setupLoadingAnim(){
    _controller = new AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    _angleAnimation = new Tween(begin: 0.0, end: 360.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });
    _scaleAnimation = new Tween(begin: 1.0, end: 6.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!_loaded) {
          _controller.reverse();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (!_loaded) {
          _controller.forward();
        }
      }
    });
    _controller.forward();
  }
  void _makeTilesX() async{
    List temp;
    await http.get("https://namaste-backend.herokuapp.com/users/all",
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      temp = json.decode(response.body);
      print(" body: $temp");
    }).whenComplete((){
      print("got users");
      tiles = temp.map((e)=>Dismissible(
          key:Key(e['username']),
          onDismissed: (direction) {
            setState(() {
              tiles.remove(e);
              print('new length ${tiles.length}');
            });
          },
          child: new ProfilePanel(e['name'], e['dp'], e['gender'],e['location'],e['about'],callback))).toList();
      setState(() {
        _loaded = true;
      });
    }).catchError((e)=>print(e));
  }


  @override
  Widget build(BuildContext context){
    return  Scaffold(
        backgroundColor: Colors.transparent,
        appBar:_normalAppBar(),
        body: _loaded?new Stack(
          children: tiles,
        ):Center(child: _buildAnimation())
    );
  }



  AppBar _normalAppBar(){
    return new AppBar(
      centerTitle: true,
      title: new Text("Namaste",style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildAnimation() {
    double circleWidth = 10.0 * _scaleAnimation.value;
    Widget circles = new Container(
      width: circleWidth * 2.0,
      height: circleWidth * 2.0,
      child: new Column(
        children: <Widget>[
          new Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.blue),
              _buildCircle(circleWidth,Colors.red),
            ],
          ),
          new Row (
            children: <Widget>[
              _buildCircle(circleWidth,Colors.yellow),
              _buildCircle(circleWidth,Colors.green),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * pi,
      child: new Container(
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return new Container(
      width: circleWidth,
      height: circleWidth,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
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
  final String name, dp, gender, location, about;
  Function callback;


  ProfilePanel(this.name, this.dp, this.gender, this.location, this.about,this.callback);

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
      widget.callback();
    }
  }
  @override
  Widget build(BuildContext context){
    var size = MediaQuery.of(context).size;
    return Stack(
    children: <Widget>[
      new Container(
        height: size.height/1.27,
        margin: EdgeInsets.all(12.0),
        decoration: new BoxDecoration(
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
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipPath(
                clipper: MyClipper(),
                child: Container(
                  height: size.height/2.27,
                  decoration: BoxDecoration(
                      gradient: myGradient,
                      borderRadius:  BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(10.0))
                  ),
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 50.0,),
                      new Container(
                        height: 170.0,
                        width: 170.0,
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
                                style: new TextStyle(fontSize: 30.0,color: Colors.black,fontWeight: FontWeight.w400),
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

              new Container(
                margin: EdgeInsets.all(5.0),
                height: MediaQuery.of(context).size.height/5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32.0,20.0,0.0,0.0),
                      child: new Text("About",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18.0),),
                    ),
                    new Padding(
                      padding:
                      const EdgeInsets.fromLTRB(32.0,10.0,32.0,10.0),
                      child: new Text(widget.about,
                        style: new TextStyle(color: Colors.black,fontSize: 15.0),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 20.0, 8.0, 5.0),
                child: new Row(
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
                      child: Icon(FontAwesomeIcons.prayingHands,color: Colors.green,size: 30.0,),
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
