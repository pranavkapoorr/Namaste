import 'dart:async';
import 'dart:convert';
import 'package:Namaste/models/chat_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import '../database/LocalDb.dart';
import 'ChatThreadScreen.dart';
import 'ContactsUsingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
//import 'package:rxdart/rxdart.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => new _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessageModel> messages = List();
  bool hasLoaded = true;
  NamasteDatabase db;
  //final PublishSubject subject = PublishSubject<String>();
  final FirebaseMessaging _fireBaseMessaging = new FirebaseMessaging();
  final CollectionReference _reference1 = Firestore.instance.collection("Namaste-Conversations");
  final CollectionReference _reference2 = Firestore.instance.collection("App-Data");
  StreamSubscription<QuerySnapshot> _subscriber1;
  StreamSubscription<QuerySnapshot> _subscriber2;
  SharedPreferences sharedPreferences;
  String _myNumber;
  List<String> _chatters = new List();
  Map<String,String> userMap =  new Map();
  bool _loadedChats = false;
  bool _loadedNumbers = false;
  List<Map<String,dynamic>> _chat = new List();
  Map<String,Map<String,String>> _lastMessage = new Map();

  @override
  void initState() {
    super.initState();
    _loadedNumbers = false;
    _loadedChats = false;
    //_loadDbAndStartStream();
    _loadNumberFromPreferences();
    _startChatStream();
    _startContactsStream();
    _configureFireBasepushNotifications();
  }
  void _startChatStream(){
    _subscriber1 = _reference1.snapshots().listen((datasnapshot) {
      datasnapshot.documents.forEach((d) {
        print(d.data);
        if (d.exists) {
          if(d.data.containsValue(_myNumber)){
            setState(() {
              _loadedChats = true;
              _chat.add(d.data);
              //db.addMessage(new ChatMessageModel(id:d.documentID.toString(),sender: d.data['sender'], receiver: d.data['receiver'], message: d.data['message'], timeStamp: d.data['time'].toString(),synced: true));
              if(d.data['message']!=null) {
                if (d.data['receiver'] == _myNumber) {
                  _chatters.add(d.data['sender']);
                  _lastMessage[d.data['sender']] =
                  {d.data['time']: d.data['message']};
                } else {
                  _chatters.add(d.data['receiver']);
                  _lastMessage[d.data['receiver']] =
                  {d.data['time']: d.data['message']};
                }
              }
            });
          }
        }
      });
    });
  }
  void _startContactsStream(){
    _subscriber2 = _reference2.snapshots().listen((datasnapshot) {
      datasnapshot.documents.forEach((d) {
        print(d.data);
        if (d.exists) {
          setState(() {
            _loadedNumbers = true;
            if(d.data['number']!=null) {
              if (d.data['dp'] != null) {
                userMap[d.data['number']] = d.data['dp'];
              } else {
                userMap[d.data['number']] =
                "https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg";
              }
            }
          });
        }
      });
    });
  }
  void _configureFireBasepushNotifications(){
    _fireBaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) {
        print("onResume: $message");
      },
    );
    _fireBaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _fireBaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _fireBaseMessaging.getToken().then((String token) {
      assert(token != null);
      print("Push Messaging token: $token");
    });

  }
  void _loadNumberFromPreferences(){
    SharedPreferences.getInstance().then((SharedPreferences sp) {
      sharedPreferences = sp;
      _myNumber = sharedPreferences.getString("myNumber");
    });
  }
  
  void _loadDbAndStartStream(){
    db = NamasteDatabase();
    db.initDB();
    //db.dropTable();
    //db.deleteAllMessages();
    db.getMessages().then((l)=>l.forEach((e)=>print(e)));
    //subject.stream.debounce(Duration(milliseconds: 400)).listen(fetchLocalMessages);
  }
  void fetchLocalMessages(query) {
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
      return; //Forgot to add in the tutorial <- leaves function if there is no query in the box.
    }
    setState(() => hasLoaded = false);
    db.getMessages().then((m)=>m.forEach((e)=>print(e))).catchError((e)=>print(e)).then((e){
      setState(() {
        hasLoaded = true;
      });
    });
    
  }
  
  void _resetMessages() {
    setState(() => messages.clear());
  }
  void _onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void _addMessage(item) {
    setState(() {
      //db.addMsg(msg)
      messages.add(ChatMessageModel.fromJson(item));
    });
    print('$ChatMessageModel');
  }

  void _generateNotification(String number) {
    Map data = {
      "to" : "dbf5X4ICAfo:APA91bGP9JkI_QdXk46SVU_InveiOkLAhaGSKCKC8Yj2kb8hr7REb42Ds7i3MK1jvhhjTKMoXow5Xc49GVo5tyjamf7_xsHkPchs9JsW0Pzs8av3aapoBDhBcqlZVmVScgK3v2HaZu2fyf-mAg_8xO3ybuKEt-FMLw",
      "content-available": true,
      "notification" : {
        "body" : "New Message received from $number",
        "title" : "Namaste",
      }

    };
    http.post("https://fcm.googleapis.com/fcm/send",
      headers: {
        "Content-Type":"application/json",
        "Authorization":"key=AIzaSyACX7BJ8RtL68ez84mKCJbHQsVa0gydExM",
        "Accept":"application/json"
      },
      body: json.encode(data),
    ).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
    }).whenComplete((){
      print("sent notification to $number ");
    }).catchError((e)=>print(e));
  }


  @override
  Widget build(BuildContext context) {
    if(!_loadedChats && !_loadedNumbers) {
    return new Stack(
      children: <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new CircularProgressIndicator(
              strokeWidth: 2.0, backgroundColor: Theme
                .of(context)
                .accentColor,)
          ],
        ),
      ],
    );
  }else{
      return _chatters.length==0?new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new FlatButton(
                  onPressed:(){ Navigator.of(context).push(new MaterialPageRoute(builder: (context)=>new ContactsUsingScreen(myNumber:_myNumber,)));},
                  color: Colors.grey,child: new Text("Start New Conversation"),
                  splashColor: Colors.amber,)
              ],)
        ):chats();
    }
  }

  Widget chats(){
    _chatters = _chatters.toSet().toList();
    _chatters.sort((a,b)=>_lastMessage[b].keys.toList()[0].compareTo(_lastMessage[a].keys.toList()[0]));
    //messages.forEach((e)=>print("message -> ${e.message} from-> ${e.sender} to-> ${e.receiver}"));
    return ListView.builder(
      itemCount: _chatters.length,
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
              backgroundImage: new NetworkImage(
                  userMap[_chatters[i]]==null?"https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg":userMap[_chatters[i]]),
            ),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                new Text(
                  _chatters[i],
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Text(
                  _chatHeadDate(_lastMessage[_chatters[i]].keys.toList()[0]),
                  style: new TextStyle(color: Colors.grey, fontSize: 14.0),
                ),
              ],
            ),
            subtitle: new Container(
              padding: const EdgeInsets.only(top: 5.0),
              child: new Text(
                _lastMessage[_chatters[i]].values.toList()[0],
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
          )
        ],
      ),
    );
  }

  String _todaysDate(){
    DateTime time = new DateTime.now();
    return time.day.toString().length<2?"0"+time.day.toString():time.day.toString();
  }
  String _chatHeadDate(String time){
    if(int.parse(time.substring(0,2))+1==int.parse(_todaysDate())){
      return "Yesterday";
    }else if(int.parse(time.substring(0,2))==int.parse(_todaysDate())){
      return time.substring(11,time.length-3);
    }else{
      return time.substring(0,10);
    }
  }
  @override
  void dispose() {
    _lastMessage.clear();
    _chat.clear();
    _chatters.clear();
    _subscriber1.cancel();
    _subscriber2.cancel();
    super.dispose();
  }
}