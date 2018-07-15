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
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}