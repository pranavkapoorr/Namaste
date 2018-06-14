import 'package:flutter/material.dart';
import 'package:flutter_app/models/chat_model.dart';
class StatusScreen extends StatefulWidget {
  @override
  StatusScreenState createState() {
    return new StatusScreenState();
  }

}
class StatusScreenState extends State<StatusScreen>{
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
          itemCount: dummyData_chat.length,
          itemBuilder: (context,index) => new Column(
            children: <Widget>[
              new Divider(height: 10.0),
              new ListTile(
                leading: new CircleAvatar(backgroundImage:new NetworkImage(dummyData_chat[index].avatarUrl),backgroundColor: Colors.grey,radius: 25.0,),
                title: new Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween ,
                    children: <Widget>[
                      new Text(dummyData_chat[index].name,style: new TextStyle(fontWeight: FontWeight.bold),)]
                ),
                subtitle: new Text(dummyData_chat[index].time,style: new TextStyle(color: Colors.grey, fontSize: 14.0)),
              )

            ],
          )),
    );
  }

}