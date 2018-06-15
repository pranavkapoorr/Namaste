import 'package:flutter/material.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:flutter_app/views/ChatThreadScreen.dart';


class ChatScreen extends StatefulWidget {
  @override
  ChatScreenState createState() {
    return new ChatScreenState();
  }
}

class ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ListView.builder(
        itemCount: dummyDataChat.length,
        itemBuilder: (context, i) => new Column(
          children: <Widget>[
            new Divider(
              height: 10.0,
            ),
            new ListTile(
              leading: new CircleAvatar(
                foregroundColor: Theme.of(context).primaryColor,
                backgroundColor: Colors.grey,
                backgroundImage: new NetworkImage(dummyDataChat[i].avatarUrl),
              ),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  new Text(
                    dummyDataChat[i].name,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  new Text(
                    dummyDataChat[i].time,
                    style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                  ),
                ],
              ),
              subtitle: new Container(
                padding: const EdgeInsets.only(top: 5.0),
                child: new Text(
                  dummyDataChat[i].message,
                  style: new TextStyle(color: Colors.grey, fontSize: 15.0),
                ),
              ),
              onTap:() {
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => new ChatThreadScreen(chatThread: new ChatThread(name:dummyDataChat[i].name,image: dummyDataChat[i].avatarUrl)),
                  ),
                );
              },
            //chat(new ChatThread(name:dummyData_chat[i].name,image:dummyData_chat[i].avatarUrl)),
            )
          ],
        ),
      ),
    );
  }
}