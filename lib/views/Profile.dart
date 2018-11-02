import 'package:Namaste/resources/mynetworkres.dart';
import 'package:Namaste/views/AlbumEditor.dart';
import 'package:Namaste/views/Namaste.dart';
import 'EditProfile.dart';
import 'Settings_Screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Profile extends StatefulWidget {


  @override
  _ProfileState createState() => new _ProfileState();
}

class _ProfileState extends State<Profile> with TickerProviderStateMixin{
  final double _appBarHeight = 267.0;
  var _me;
  bool _loaded = false;
  AnimationController _avatarAnimController;
  Animation _avatarSize;

  @override
  initState(){
    super.initState();
    if(myProfile.me!=null){
      setState(() {
        _me = myProfile.me;
        _loaded = true;
      });
    }else{
      myProfile.getMyDetails().whenComplete(() {
        setState(() {
          _me = myProfile.me;
          _loaded = true;
        });
      });
    }
    _avatarAnimController = new AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _avatarSize  = new Tween(begin: 0.0, end: 1.0).animate(
        new CurvedAnimation(
          parent: _avatarAnimController,
          curve: new Interval(
            0.100,
            0.900,
            curve: Curves.elasticOut,
          ),
        ));
    _avatarSize.addListener(() => this.setState(() {}));

    _avatarAnimController.forward();

  }

  Widget _sliverAppBar(BuildContext context)=>SliverAppBar(

    backgroundColor: Colors.transparent,
    leading: IconButton(icon: Icon(FontAwesomeIcons.userEdit,color: Colors.white,),
        onPressed: (){
          _goToEditPage();
        }),
    expandedHeight: _appBarHeight,
    pinned: true,
    floating: true,
    actions: <Widget>[
      new IconButton(icon: Icon(FontAwesomeIcons.cogs,color:Colors.white,), onPressed: (){
        Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new SettingsScreen()));
      })
    ],
    flexibleSpace: new FlexibleSpaceBar(
      title:  Text(_me['name'],style: TextStyle(color: Colors.white),),
      background: new Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ClipPath(
            clipper: MyClipper(),
            child: Container(
                color: Colors.transparent.withOpacity(0.4),
                padding: EdgeInsetsDirectional.only(bottom: 1.0),
                child: Text("")
            ),
          ),
          /*const DecoratedBox(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                begin: const Alignment(0.0, 1.0),
                end: const Alignment(0.0, -0.4),
                colors: const <Color>[const Color(0x60000000), const Color(0x00000000)],
              ),
            ),
          ),*/
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 55.0),
            child: new Align(
              alignment: FractionalOffset.center,
              heightFactor: 1.4,
              child: new Column(
                children: <Widget>[
                  Transform(
                    transform: new Matrix4.diagonal3Values(
                      _avatarSize.value,
                      _avatarSize.value,
                      1.0,
                    ),
                    child: new CircleAvatar(
                      radius: 65.0,
                      backgroundImage: NetworkImage(_me['dp']),
                    ),
                  ),
                  _followerInfo(),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return _loaded?Container(
      padding: EdgeInsetsDirectional.only(top: 0.0,start: 10.0 ,end: 10.0),
      color: Colors.transparent,
      child: NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                _sliverAppBar(context)
          ];},
          body: ListView(
            shrinkWrap: true,
              children: <Widget>[
                //Scaffold(
                //backgroundColor: Colors.blueGrey.shade100,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(color: Colors.white70),
                      child: Column(
                        children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            new Text("Location",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.place,color: Colors.red,),
                              new Text(
                                _me['location'],
                                style:
                                new TextStyle(color: Colors.black45, fontSize: 15.0),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                    GestureDetector(
                      onTap: _goToEditPage,
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      margin: EdgeInsetsDirectional.only(top: 5.0),
                      decoration: BoxDecoration(color: Colors.white70),
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              new Text("Personal Info",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                              new Icon(Icons.navigate_next)
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top:5.0),
                            child: new Text(
                              _me['about'],
                              style:
                              new TextStyle(color: Colors.black45, fontSize: 14.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  new Container(
                    padding: EdgeInsets.all(10.0),
                    margin: EdgeInsetsDirectional.only(top: 5.0),
                    decoration: BoxDecoration(color: Colors.white70),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: _goToAlbumUploader,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Text("Album",style: new TextStyle(fontSize: 16.0,fontWeight: FontWeight.bold),),
                              new Icon(Icons.navigate_next)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:5.0),
                          child: new Container(
                            height: 100.0,
                            child: _album(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
                ),
              ],
            ),
        ),
    ):Center(child: CircularProgressIndicator(),);
  }
  void _goToEditPage(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new EditProfile()));
  }
  void _goToAlbumUploader(){
    Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new AlbumUploader()));
  }


  Widget _followerInfo() {
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



  Widget _albumImage(Image image){
    return  GestureDetector(onTap:(){onImageTap(image);},child: Container(margin: EdgeInsets.all(1.0),child:image));
  }
  Widget _album() {
    List<Widget> images = [
      _albumImage(new Image(fit: BoxFit.cover,image: NetworkImage(_me['dp']))),
      _albumImage(new Image(fit: BoxFit.cover,image: NetworkImage(_me['dp']))),
      _albumImage(new Image(fit: BoxFit.cover,image: NetworkImage(_me['dp']))),
      _albumImage(new Image(fit: BoxFit.cover,image: NetworkImage(_me['dp']))),
    ];
    return Container(
      color: Colors.black.withOpacity(0.1),
      child: new ListView(
          scrollDirection: Axis.horizontal,
          children: images
      ),
    );
  }
  void onImageTap(Image img){
    showDialog(context: this.context,builder:(BuildContext context)=>AlertDialog(content: Container(
      child: img,
      ),contentPadding: EdgeInsets.all(0.5),)
    );
  }
  @override
  void dispose() {
    _avatarAnimController.dispose();
    _loaded = false;
    _me = null;
    super.dispose();
  }
}