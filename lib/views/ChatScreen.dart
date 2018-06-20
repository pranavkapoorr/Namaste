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
  List<DocumentSnapshot> _chats;
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
    setState(() {
      _chats = data;
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
          itemCount: _chats.length!=null?_chats.length:0,
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
                  backgroundImage: new NetworkImage(userMap[_chats[i].data['to']==_myNumber?_chats[i].data['from']:_chats[i].data['to']]),
                ),
                title: new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    new Text(
                      _chats[i].data['to']==_myNumber?_chats[i].data['from']:_chats[i].data['to'],
                      style: new TextStyle(fontWeight: FontWeight.bold),
                    ),
                    new Text(
                      _chats[i].data['time'],
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
                              name: _chats[i].data['to']==_myNumber?_chats[i].data['from']:_chats[i].data['to'],
                              image: userMap[_chats[i].data['to']==_myNumber?_chats[i].data['from']:_chats[i].data['to']])),
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