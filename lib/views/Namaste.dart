import 'dart:convert';
import 'dart:math';
import 'package:Namaste/resources/UiResources.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';


class Namaste extends StatefulWidget{
  @override
  _NamasteState createState()=> new _NamasteState();
}
class _NamasteState extends State<Namaste> with TickerProviderStateMixin{
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  bool _searchClicked = false;
  List<Widget> tiles = [];
  bool _loaded = false;
  bool _openProfile = false;
  String name, dp ,location , about;
  double _opacity = 0.0;
  Animation<double> _angleAnimation;
  Animation<double> _scaleAnimation;
  AnimationController _controller;


  @override
  void initState() {
    _setupLoadingAnim();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
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
      await http.get("http://192.168.0.26:5000/users/all",
      ).then((response) {
        print("Response status: ${response.statusCode}");
        print("Response body: ${response.body}");
        temp = json.decode(response.body);
        print(" body: $temp");
      }).whenComplete((){
        print("got users");
        tiles = temp.map((e)=>personTile(e['name'], e['dp'], e['location'],e['about'])).toList();
        setState(() {
          _loaded = true;
        });
      }).catchError((e)=>print(e));
    }



  @override
  Widget build(BuildContext context){
    return  NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _searchClicked?_searchAppBar(innerBoxIsScrolled):_normalAppBar(innerBoxIsScrolled),
        ];
      },
      body: _loaded?Stack(
        children: [
          Container(
            color: Colors.transparent.withOpacity(_opacity),
            child: new ListView(
              children: tiles,
            ),
          ),
          _openProfile?Positioned(
            child: new Container(
              child: profilePanel(name, dp, location,about)
            ),
          ):Text("")
        ]
      ):Center(child: _buildAnimation())
    );
  }

  Widget personTile(String name, String imageUrl, String location, String about){
    return new InkWell(
      onTap: (){
        setState(() {
          this.name = name;
          this.dp = imageUrl;
          this.location = location;
          this.about = about;
          this._opacity = 0.7;
          this._openProfile = true;
        });
        },
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: new Container(
          height: 115.0,
          child: new Stack(
            children: <Widget>[
              myCard(name,location),
              new Positioned(top: 7.5, child:
              personImage(imageUrl)

              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget personImage(String imageUrl) {
    var personAvatar = new Hero(
      tag: Text("lol"),
      child: new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: new NetworkImage(imageUrl),
          ),
        ),
      ),
    );

    var placeholder = new Container(
        width: 100.0,
        height: 100.0,
        decoration: new BoxDecoration(
          shape: BoxShape.circle,
          gradient: new LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.black54, Colors.black, Colors.blueGrey[600]],
          ),
        ),
        alignment: Alignment.center,
        child: new Text(
          'DOGGO',
          textAlign: TextAlign.center,
        ));

    var crossFade = new AnimatedCrossFade(
      firstChild: placeholder,
      secondChild: personAvatar,
      crossFadeState:CrossFadeState.showSecond,
      duration: new Duration(milliseconds: 3000),
    );

    return crossFade;
  }
  Widget myCard(String name, String location){
    return new Positioned(
      right: 0.0,
      child: new Container(
        width: 290.0,
        height: 115.0,
        child: new Card(
          color: Colors.black87,
          child: new Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              bottom: 8.0,
              left: 64.0,
            ),
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                new Text(name,
                    style: TextStyle(color: Colors.white)),
                new Text(location,
                    style: TextStyle(color: Colors.white)),
                new Row(
                  children: <Widget>[
                    new Icon(
                      Icons.star,color: Colors.white,
                    ),
                    new Text(': X / 10',style: TextStyle(color: Colors.white),)
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  SliverAppBar _searchAppBar(bool innerBoxIsScrolled){
    _iconAnimationController.forward();
    var searchTextField = new TextField(decoration: new InputDecoration(hintText: "         search here",suffixIcon: new Icon(Icons.search),border: InputBorder.none),);
    var searchTile = new ListTile(leading: new IconButton(icon: new Icon(Icons.arrow_back), onPressed: (){setState(() {
      _searchClicked = false;
      _iconAnimationController.reset();
    });}),title: searchTextField);
    return new SliverAppBar(
      title:  new Container(
        margin: EdgeInsets.all(5.0),
        width: _iconAnimation.value * 1400.0,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              blurRadius: .5,
              spreadRadius: 0.0,
              color: Colors.black.withOpacity(.12))
        ],),
        child: searchTile,
      ),
      elevation: 3.0,
      backgroundColor: Colors.transparent,
      pinned: true,
      snap: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
    );
  }
  SliverAppBar _normalAppBar(bool innerBoxIsScrolled){
    return new SliverAppBar(
      //leading: Image(image: AssetImage("images/logo.png"),color:Colors.black,),
      centerTitle: true,
      title: new Text("Namaste",style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
      elevation: 3.0,
      backgroundColor: Colors.transparent,
      pinned: true,
      snap: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      actions: <Widget>[
        new IconButton(icon:new Icon(Icons.search),onPressed: (){setState(() {
          _searchClicked = true;
        });},),
      ],
    );
  }
  Widget profilePanel(String name, String dp, String location, String about){
    return new Container(
      margin: EdgeInsets.all(20.0),
      decoration: new BoxDecoration(
        gradient: myGradient, borderRadius:  BorderRadius.all(Radius.circular(10.0))
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: new EdgeInsets.symmetric(vertical: 15.0),
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(icon: Icon(Icons.clear),onPressed: (){
                  setState(() {
                      this._opacity = 0.0;
                      this.name = "";
                      this.dp = "";
                      this.location = "";
                      this.about = "";
                      this._openProfile = false;
                  });
            },)],),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                //image begin
                new Hero(
                  tag: "lol",
                  child: new Container(
                    height: 120.0,
                    width: 120.0,
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
                        image: new NetworkImage(dp),
                      ),
                    ),
                  ),
                ),
                //image ends
                new Text(
                  name + '  🎾',
                  style: new TextStyle(fontSize: 25.0,color: Colors.white),
                ),
                new Text(
                  location,
                  style: new TextStyle(fontSize: 18.0,color: Colors.white),
                ),
                new Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: new Text(about,
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Icon(
                      Icons.star,
                      size: 40.0,
                    ),
                    new Text(' x / 10',
                        style: TextStyle(color: Colors.white)),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
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
    _iconAnimationController.dispose();
    tiles.clear();
    super.dispose();
  }
}
