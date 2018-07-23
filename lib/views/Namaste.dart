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


  @override
  void initState() {
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _makeTiles();
    super.initState();

  }

  void _makeTiles(){
    for(int i =0; i < 2;i++){
      tiles.add(
          _cardBody()
      );
    }
  }
  Widget _cardBody(){
    return new Container(
      padding: const EdgeInsets.all(6.0),
      height: 550.0,
      child: new Card(
        color: Colors.white.withOpacity(0.8),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new SizedBox(
              height: 300.0,
              child: new Stack(
                children: <Widget>[
                  new Positioned.fill(
                    child: new Image.network(
                      "https://scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/11230099_10206835592669367_2911893136176495642_n.jpg?_nc_cat=0&oh=eb80db39d72968cc4a130d4d075ea24a&oe=5BE80A4C",
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 6.0,
                    left: 8.0,
                    right: 16.0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text("Pranav Kapoor",
                              style: TextStyle(color: Colors.white,fontSize:30.0),
                            ),
                            Text(
                              "26",
                              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                            ),
                            Text("My name is pranav, these are my profile details..all you need to know",
                            style: TextStyle(color: Colors.white),),
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: new Icon(Icons.loop, color: Colors.yellow),
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 8.0)),
                  new FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: new Icon(Icons.close, color: Colors.red),
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 8.0)),
                  new FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: new Icon(Icons.favorite, color: Colors.green),
                  ),
                  new Padding(padding: new EdgeInsets.only(right: 8.0)),
                  new FloatingActionButton(
                    mini: true,
                    onPressed: () {},
                    backgroundColor: Colors.white,
                    child: new Icon(Icons.star, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
          body: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
              children: tiles
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
      pinned: true,
      snap: true,
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
    _iconAnimationController.dispose();
    super.dispose();
  }
}