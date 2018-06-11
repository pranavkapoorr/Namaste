import 'package:flutter/material.dart';
import 'package:flutter_app/views/CameraScreen.dart';
import 'package:flutter_app/views/CallScreen.dart';
import 'package:flutter_app/views/StatusScreen.dart';
import 'package:flutter_app/views/ChatScreen.dart';
import 'package:flutter_app/views/Settings_Screen.dart';

class NamasteHome extends StatefulWidget {

  var camera;
  NamasteHome(this.camera);

  @override
  _NamasteHomeState createState()=> new _NamasteHomeState();

}

class _NamasteHomeState extends State<NamasteHome> with SingleTickerProviderStateMixin{
  TabController _tabController;
  List<PopupMenuItem> _options = new List<PopupMenuItem>();

  @override
  void initState() {
    super.initState();
    _options.addAll([
      new PopupMenuItem(
          child: new ListTile(
            title:Text("Settings",style: new TextStyle(color: Colors.black, fontSize: 18.0)),
            onTap: _settingPage
          )
      ),
      new PopupMenuItem(
          child: new ListTile(
              title:Text("About",style: new TextStyle(color: Colors.black, fontSize: 18.0)),
              onTap:null)),
    ]);
    _tabController = new TabController(vsync: this, initialIndex: 1, length: 4);
  }

  void _settingPage(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new SettingsScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Namaste"),
        elevation: 0.7,
        bottom: new TabBar(
          controller: _tabController,
          indicatorColor: Colors.grey,
          labelColor: new Color(0xff939696),//999C9C),
          tabs: <Widget>[
            new Tab(icon: new Icon(Icons.photo_camera,size: 22.0,)),
            new Tab(text: "CHATS"),
            new Tab(text: "STATUS"),
            new Tab(text: "CALLS"),
          ],
        ),
        actions: <Widget>[
          new Icon(Icons.search,color: new Color(0xff939696),),
          new Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
          ),
          new PopupMenuButton(
              elevation: 10.0,
              padding: EdgeInsets.zero,
              tooltip:"Settings",
              icon: new Icon(Icons.more_vert,color: new Color(0xff939696)) ,
              itemBuilder: (BuildContext context){
                return _options;
              })
              //Button(icon: new Icon(Icons.more_vert,color: new Color(0xff939696)), onPressed: options())
        ],
      ),
      body: new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new CameraScreen(widget.camera),
          new ChatScreen(),
          new StatusScreen(),
          new CallsScreen(),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Theme.of(context).accentColor,
        child: new Icon(
          Icons.message,
          color: Colors.white,
        ),
        onPressed: () => print("open chats"),
      ),
    );
  }

}