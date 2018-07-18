import 'package:Namaste/views/LogoPage.dart';
import 'package:flutter/material.dart';
import 'Settings_Screen.dart';

class Namaste extends StatefulWidget{
  @override
  _NamasteState createState()=> new _NamasteState();
}
class _NamasteState extends State<Namaste> with TickerProviderStateMixin{
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  bool _searchClicked = false;
  List tiles = [];


  @override
  void initState() {
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    super.initState();

  }

  void _makeTiles(){

  }
  @override
  Widget build(BuildContext context){
    return  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              _searchClicked?_searchAppBar(innerBoxIsScrolled):_normalAppBar(innerBoxIsScrolled),
            ];
          },
          body: new Scaffold(
            backgroundColor: Colors.white.withOpacity(0.6),
            body: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
              children: <Widget>[GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),
              GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),GridTile(child: Icon(Icons.person)),],
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
      elevation: 0.7,
      backgroundColor: Colors.transparent,
      pinned: false,
      floating: true,
      forceElevated: innerBoxIsScrolled,
    );
  }
  SliverAppBar _normalAppBar(bool innerBoxIsScrolled){
    return new SliverAppBar(
      leading: Image(image: AssetImage("images/logo.png"),color:Colors.black,),
      centerTitle: true,
      title: new Text("Namaste",style: new TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,fontFamily: "BeautifulX")),
      elevation: 0.7,
      backgroundColor: Colors.transparent,
      pinned: false,
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
    _iconAnimationController.dispose();
    super.dispose();
  }
}