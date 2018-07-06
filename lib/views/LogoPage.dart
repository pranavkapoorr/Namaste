import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/views/StartUpLoader.dart';

class LogoPage extends StatefulWidget{
  @override
  _logoPageState createState()=>new _logoPageState();
}

class _logoPageState extends State<LogoPage> {

  @override
  void initState() {
    super.initState();
    new Timer(const Duration(seconds: 5), onClose);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.grey.shade300, Colors.grey.shade500, Colors.grey.shade300])),
            child: Stack(
                children: <Widget>[
                  Theme(
                      data: new ThemeData(
                          brightness: Brightness.light,
                          inputDecorationTheme: new InputDecorationTheme(
                            // hintStyle: new TextStyle(color: Colors.blue, fontSize: 20.0),
                            labelStyle:
                            new TextStyle(
                                color: Colors.tealAccent, fontSize: 25.0),
                          )),
                      isMaterialAppTheme: true,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: new Image(
                                color: Colors.black87,
                                fit: BoxFit.scaleDown,
                                image: new AssetImage("images/logo.png"),
                              ),
                            ),
                            new Container(
                                padding: const EdgeInsetsDirectional.only(top: 260.0),
                                child: new Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .start,
                                    children: <Widget>[
                                      new Container(
                                          height: 50.0,
                                          width: 170.0,
                                          color: Colors.grey.shade400,
                                          child: Image(image: new AssetImage("images/earth_loader.gif")),
                                      ),
                                    ])
                            )
                          ])
                  )
                ]
            )
        )
    );
  }

  void onClose() {
    Navigator.of(context).pushReplacement(new PageRouteBuilder(
        maintainState: true,
        opaque: true,
        pageBuilder: (context, _, __) => new StartUpLoader(),
        transitionDuration: const Duration(seconds: 2),
        transitionsBuilder: (context, anim1, anim2, child) {
          return new FadeTransition(
            child: child,
            opacity: anim1,
          );
        }));
  }
}