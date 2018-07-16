import 'package:Namaste/views/Contacts.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'CameraScreen.dart';
import 'LogoPage.dart';
import 'ChatScreen.dart';
import 'Settings_Screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NamasteHome extends StatefulWidget {
  @override
  _NamasteHomeState createState()=> new _NamasteHomeState();

  static Future<bool> exitApp(BuildContext context) {
    return showDialog(
      context: context,
      // ignore: deprecated_member_use
      child: new AlertDialog(
        title: new Text('Do you want to exit this application?'),
        content: new Text('We hate to see you leave...'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => (){return new Future<bool>.value(false);},
            child: new Text('No'),
          ),
          new FlatButton(
            onPressed: () =>(){return new Future<bool>.value(true);},
            child: new Text('Yes'),
          ),
        ],
      ),
    ) ;
  }
}

class _NamasteHomeState extends State<NamasteHome> with TickerProviderStateMixin{
  ScrollController _scrollViewController;
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;
  TabController _tabController;
  String _myNumber;
  bool _searchClicked = false;
  int _currentTab = 1;


  void _updateCurrentTab(){
    setState(() {
      _currentTab = _tabController.index;
    });
  }

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    });
    _scrollViewController = new ScrollController(keepScrollOffset: true);
    _tabController = new TabController(vsync: this, initialIndex: 2, length: 4);
    _tabController.addListener(_updateCurrentTab);
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeIn,
    );
    _iconAnimation.addListener(() => this.setState(() {}));


  }

  void _easeInOutAppbar(){
    if(_currentTab==0) {
      _scrollViewController.animateTo(
          170.0, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    }else if(_tabController.previousIndex==0){
      _scrollViewController.animateTo(
          0.0, duration: const Duration(milliseconds: 200), curve: Curves.easeIn);
    }
  }
  @override
  Widget build(BuildContext context) {
    _easeInOutAppbar();
    return new WillPopScope(
      child: new Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: new TabBar(
          indicator:UnderlineTabIndicator(),
          unselectedLabelColor: Colors.grey,
          controller: _tabController,
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.person,size: 22.0,)),
            new Tab(icon: new Icon(Icons.message,size: 22.0,)),
            new Tab(icon: new Icon(Icons.camera_alt,size: 22.0,)),
            new Tab(icon: new CircleAvatar(backgroundColor: Colors.grey,child: Text("🙏")),),
          ],
        ),
        body: Container(
          decoration: new BoxDecoration(
              gradient: new LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                colors: [
                  const Color.fromARGB(255, 253, 72, 72),
                  const Color.fromARGB(255, 87, 97, 249),
                ],
                stops: [0.0, 1.0],
              )
          ),
          child: new NestedScrollView(
            controller: _scrollViewController,
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _searchClicked?_searchAppBar(innerBoxIsScrolled):_normalAppBar(innerBoxIsScrolled),
              ];
            },
            body: new TabBarView(
              controller: _tabController,
              children: <Widget>[
                new ContactsDemo(),
                new ChatScreen(),
                new ContactsDemo(),
                new CameraScreen(),
              ],
            ),
          ),
        ),
      ),
      onWillPop: (){return new Future<bool>.value(false);},
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
        new Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
        ),
        new PopupMenuButton(
          elevation: 10.0,
          tooltip:"Settings",
          icon: new Icon(Icons.more_vert) ,
          onSelected: (dynamic value){
            Navigator.push(context, new MaterialPageRoute(builder: (context)=>value));
          },
          itemBuilder: (BuildContext context) => <PopupMenuItem>[
            new PopupMenuItem(
                value: new SettingsScreen(),
                child: new Text('Settings')
            ),
            new PopupMenuItem(
                value: new LogoPage(),
                child: new Text('About')
            ),
          ],
        ),
      ],
    );
  }



  @override
  void dispose() {
    super.dispose();
    _scrollViewController.dispose();
    _tabController.dispose();
    _tabController.removeListener(_updateCurrentTab);
    _iconAnimationController.dispose();
  }
}

