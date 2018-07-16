import 'package:Namaste/views/Settings_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel/carousel.dart';
class ContactsDemo extends StatefulWidget {
  @override
  ContactsDemoState createState() => new ContactsDemoState();
}

class ContactsDemoState extends State<ContactsDemo> {
  final double _appBarHeight = 300.0;


  @override
  Widget build(BuildContext context) {
    var carouselX = new Carousel(
      children: [
        new NetworkImage('https://pbs.twimg.com/profile_images/760249570085314560/yCrkrbl3_400x400.jpg'),
        new NetworkImage('https://webinerds.com/app/uploads/2017/11/d49396_d9c5d967608d4bc1bcf09c9574eb67c9-mv2.png')
      ].map((netImage) => new Image(image: netImage)).toList(),
    );
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
        body: new NestedScrollView(
            headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
            new SliverAppBar(
              leading: Text(""),
              expandedHeight: _appBarHeight,
              pinned: true,
              floating: true,
              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                  },
                ),
                new IconButton(icon: Icon(Icons.settings), onPressed: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new SettingsScreen()));
                })
              ],
              flexibleSpace: new FlexibleSpaceBar(
                title: const Text('Pranav Kapoor'),
                background: new Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    new Image.asset(
                      'images/bg.jpg',
                      fit: BoxFit.cover,
                      height: _appBarHeight,
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
                              backgroundImage: NetworkImage("https://scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/11230099_10206835592669367_2911893136176495642_n.jpg?_nc_cat=0&oh=eb80db39d72968cc4a130d4d075ea24a&oe=5BE80A4C"),
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
          body: Scaffold(
            backgroundColor: Colors.black87.withOpacity(0.08),
            body:Container(
              //padding: const EdgeInsets.all(22.0),
              child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: <Widget>[
                      new Icon(
                        Icons.place,
                        color: Colors.red,
                        size: 16.0,
                      ),
                      new Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: new Text(
                          "location",
                          style: new TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsetsDirectional.only(top: 5.0),
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text("Personal Info",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                          new Icon(Icons.navigate_next)
                        ],
                      ),
                      new Text(
                        'Lorem Ipsum is simply dummy text of the printing and typesetting '
                            'industry. Lorem Ipsum has been the industry\'s standard dummy '
                            'text ever since the 1500s.',
                        style:
                        new TextStyle(color: Colors.grey, fontSize: 13.0),
                      ),
                    ],
                  ),
                ),
                new Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsetsDirectional.only(top: 5.0),
                  decoration: BoxDecoration(color: Colors.white70),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          new Text("Album",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),),
                          new Icon(Icons.navigate_next)
                        ],
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
            ),
          ),
        ),
      ),
    );
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
    return Container(
      child: IconButton(iconSize: 100.0,icon: image, onPressed:(){onImageTap(image);}),
    );
  }
  Widget _album() {
    List<Widget> images = [
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"))),
      _albumImage(new Image(image: AssetImage("images/bg.jpg")))
    ];
    return new ListView(
        padding: const EdgeInsets.only(top: 16.0),
        scrollDirection: Axis.horizontal,
        children: images
    );
  }
  void onImageTap(Image img){
    showDialog(context: this.context,child: AlertDialog(content: Container(child: img,),));
  }
}