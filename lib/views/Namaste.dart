import 'dart:async';

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
      body: _loaded?CircularProgressIndicator():new ListView(
        children: tiles,
      )
    );
  }
  Widget personTile(String name, String imageUrl){
    return new InkWell(
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

  @override
  void dispose() {
    _subscriber2.cancel();
    _iconAnimationController.dispose();
    tiles.clear();
    super.dispose();
  }
}