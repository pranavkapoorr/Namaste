import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class ContactsDemo extends StatefulWidget {
  @override
  ContactsDemoState createState() => new ContactsDemoState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class ContactsDemoState extends State<ContactsDemo> {
  static final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final double _appBarHeight = 256.0;


  @override
  Widget build(BuildContext context) {
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
        platform: Theme.of(context).platform,
      ),
      child: new Scaffold(
        key: _scaffoldKey,
        body: new CustomScrollView(
          slivers: <Widget>[
            new SliverAppBar(
              leading: Text(""),
              expandedHeight: _appBarHeight,
              pinned: false,
              floating: true,
              actions: <Widget>[
                new IconButton(
                  icon: const Icon(Icons.create),
                  tooltip: 'Edit',
                  onPressed: () {
                    _scaffoldKey.currentState.showSnackBar(const SnackBar(
                        content: const Text("Editing isn't supported in this screen.")
                    ));
                  },
                ),
                new IconButton(icon: Icon(Icons.settings), onPressed: (){})
              ],
              flexibleSpace: new FlexibleSpaceBar(
                title: const Text('Ali Connors'),
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
                    new Align(
                      alignment: FractionalOffset.bottomCenter,
                      heightFactor: 1.4,
                      child: new Column(
                        children: <Widget>[
                          new CircleAvatar(
                            radius: 50.0,
                            backgroundImage: NetworkImage("https://scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/11230099_10206835592669367_2911893136176495642_n.jpg?_nc_cat=0&oh=eb80db39d72968cc4a130d4d075ea24a&oe=5BE80A4C"),
                          ),
                          //_buildFollowerInfo(textTheme),
                          _buildActionButtons(Theme.of(context)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        minWidth: 140.0,
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
          _createPillButton(
            'HIRE ME',
            backgroundColor: Colors.transparent,
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

}