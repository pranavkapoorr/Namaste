import 'dart:async';
import 'package:Namaste/resources/UiResources.dart';
import 'package:Namaste/views/NamasteHome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  final CollectionReference _reference2 = Firestore.instance.collection("App-Data");
  StreamSubscription<QuerySnapshot> _subscriber2;
  bool _loaded = false;
  bool _openProfile = false;
  String name, dp ;
  double _opacity = 0.0;


  @override
  void initState() {
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
  void _makeTilesX(){
    _loaded = true;
    _subscriber2 = _reference2.snapshots().listen((datasnapshot) {
      datasnapshot.documents.forEach((d) {
        print(d.data);
        if (d.exists) {
          setState(() {
            if(d.data['number']!=null) {
              if (d.data['dp'] != null) {
                setState(() {
                  _makeTiles(d.data['number'], d.data['dp']);
                });
              } else {
                setState(() {
                  _makeTiles(d.data['number'], d.data['dp']);
                });
              }
            }
          });
        }
      });
      setState(() {
        _loaded = false;
      });
    });

  }
  void _makeTiles(String name, String dp){
      tiles.add(
          personTile(name,dp)
      );
  }



  @override
  Widget build(BuildContext context){
    return  NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          _searchClicked?_searchAppBar(innerBoxIsScrolled):_normalAppBar(innerBoxIsScrolled),
        ];
      },
      body: _loaded?CircularProgressIndicator():Stack(
        children: [
          Container(
            color: Colors.transparent.withOpacity(_opacity),
            child: new ListView(
              children: tiles,
            ),
          ),
          _openProfile?Positioned(
            child: new Container(
              child: profilePanel(name, dp)
            ),
          ):Text("")
        ]
      )
    );
  }

  Widget personTile(String name, String imageUrl){
    return new InkWell(
      onTap: (){
        setState(() {
          this.name = name;
          this.dp = imageUrl;
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
              myCard(name),
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
  Widget myCard(String name){
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
                new Text(name.substring(0,3).contains("+44")?"GB":name.substring(0,3).contains("+91")?"IN":"Location",
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
  Widget profilePanel(String name, String dp){
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
                  _findLocation(name),
                  style: new TextStyle(fontSize: 18.0,color: Colors.white),
                ),
                new Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  child: new Text("hello how are you",
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
  String _findLocation(String name){
    String location = "";
    if(name.substring(0,3).contains("+44")){
      location = "GB";
    }else if(name.substring(0,3).contains("+91")){
      location = "IN";
    }
    return location;
  }

  @override
  void dispose() {
    _subscriber2.cancel();
    _iconAnimationController.dispose();
    tiles.clear();
    super.dispose();
  }
}
