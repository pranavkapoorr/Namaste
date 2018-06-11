import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  NotificationScreenState createState() {
    return new NotificationScreenState();
  }

}

class NotificationScreenState extends State<NotificationScreen>{
  bool _notifications = false;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Notifications"),),
        body: new Scaffold(

          body: new ListView(
              children: <Widget>[ new Column(
                children: <Widget>[

                  new ListTile(title: new Text("Notifications"),trailing: new Checkbox(value: _notifications, onChanged: (bool value) {
                    setState(() {
                      _notifications = value;
                    });
                  }
                  ),),


                ],
              ) ]),
        )
    );
  }

}


