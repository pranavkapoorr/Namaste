import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/models/chat_model.dart';
import 'package:flutter_app/resources/FireBaseDBResources.dart';
import 'package:flutter_app/views/ChatThreadScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  SharedPreferences sharedPreferences;
  String _myNumber;
  FireBaseDB db =  new FireBaseDB();
  bool loading = false;
  List<String> _chatters;
  Map<String,String> userMap;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _myNumber = sharedPreferences.getString("myNumber");
    });
    loading = true;
    loadChatHeads();

  }
  void loadChatHeads()async{
    var data = await db.getChats("Namaste-Conversations").whenComplete((){print("loaded chatdata...");}).catchError((e)=>print(e));
    var map = await db.getUserData("App-Data").whenComplete((){print("loaded userdata");}).catchError((e)=>print(e));
    Set<String> chatters = new Set();
    data.forEach((d){
      chatters.add(d.data['to']);
      chatters.add(d.data['from']);
    });
    chatters.remove(_myNumber);
    setState(() {
      _chatters = chatters.toList();
      print("chats: $_chatters");
      userMap = map;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return new Stack(
        children:<Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new CircularProgressIndicator(strokeWidth: 2.0,backgroundColor: Theme.of(context).accentColor,)
              ],
            ),
          ],
        );

    }else {
      return new Scaffold(
        body: ListView.builder(
          itemCount: _chatters.length!=null?_chatters.length:0,
          itemBuilder: (context, i) =>
          new Column(
            children: <Widget>[
              new Divider(
                height: 10.0,
              ),
              new ListTile(
                leading: new CircleAvatar(
                  foregroundColor: Theme
                      .of(context)
                      .primaryColor,
                  backgroundColor: Colors.grey,
                  backgroundImage: new NetworkImage(userMap[_chatters[i]]),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      _chatters[i],
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      _chatters[i],
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
                onTap: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                      builder: (context) => new ChatThreadScreen(
                          chatThread: new ChatThread(
                              name: _chatters[i],
                              image: userMap[_chatters[i]]),
                          myNumber: _myNumber,
                      ),
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
}