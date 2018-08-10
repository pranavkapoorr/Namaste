import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => new _NotificationScreenState();

}

class _NotificationScreenState extends State<NotificationScreen>{
  bool _notifications = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient:myGradient,),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.white,), onPressed:(){Navigator.pop(context);}),title: new Text("Notifications",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                borderRadius:  BorderRadius.all(Radius.circular(5.0))
            ),
            child: ListView(
                children: <Widget>[
            Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
            color: Colors.white,),
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
                  new ListTile(title: new Text("Notifications"),trailing: new Checkbox(value: _notifications, onChanged: (bool value) {
                    setState(() {
                      _notifications = value;
                    });
                  }
                  ),
                  ),
            ]
    ),
    ),
    ]
            )


    ),
      )
    );
  }

}


