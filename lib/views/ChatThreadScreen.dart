import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


var myNum;
class ChatThreadScreen extends StatefulWidget {
  final ChatThread chatThread;
  final List<DocumentSnapshot> chats;
  final String myNumber;

  ChatThreadScreen({Key key, @required this.chatThread, this.chats, this.myNumber}) : super(key: key){
    myNum = myNumber;
  }

  @override
  _ChatThreadScreenState createState() => new _ChatThreadScreenState();

}

class _ChatThreadScreenState extends State<ChatThreadScreen> with TickerProviderStateMixin {
  final CollectionReference _reference = Firestore.instance.collection(
      "Namaste-Conversations");
  final TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: new AppBar(
        titleSpacing: 1.0,
        title: new Row(
          children: <Widget>[
            new IconButton(icon: new CircleAvatar(
              backgroundImage: new NetworkImage('${widget.chatThread.image}'),
              radius: 15.0,), onPressed: null,),
            new Padding(padding: new EdgeInsetsDirectional.only(end: 10.0)),
            new GestureDetector(
              child: new Text('${widget.chatThread.name}',
                  style: new TextStyle(color: new Color(0xffA1A9A9))),
              onTap: null,
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.phone), onPressed: null),
          new IconButton(icon: new Icon(Icons.more_vert), onPressed: null)
        ],
        elevation: 4.0,
      ),
      body: new Container(
          child: new Column(
            children: <Widget>[
              new Flexible(
                child: new StreamBuilder(
                    stream: _reference.snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return const Text('Loading...');
                      List<Widget> dataList = new List();
                      for (int i = snapshot.data.documents.length - 1; i > 0;
                      i--) {
                        DocumentSnapshot ds = snapshot.data.documents[i];
                        if (ds.data['message'] != null) {
                          dataList.add(new ChatMessage(from: ds.data['from'],
                            message: ds.data['message'],
                            time: ds.data['time'],));
                        }
                      }
                      return new ListView(
                        reverse: true,
                        children: dataList,
                      );
                    }
                ),
              ),
              new Divider(height: 1.0),
              new Container(
                  decoration: new BoxDecoration(
                      color: Theme
                          .of(context)
                          .cardColor),
                  child: _buildTestComposer()
              ),
            ],
          ),
          decoration: Theme
              .of(context)
              .platform == TargetPlatform.iOS
              ? new BoxDecoration(
              border: new Border(top: new BorderSide(color: Colors.grey[200])))
              : null), //new
    );
  }

  Widget _buildTestComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme
            .of(context)
            .accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.photo_camera),
                      onPressed: null),
                ),
                new Flexible(
                  child: new TextField(
                    controller: _textController,
                    onChanged: (String text) {
                      setState(() {
                        _isComposing = text.length > 0;
                      });
                    },
                    onSubmitted: _isComposing
                        ? _handleSubmitted
                        : null,
                    decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing
                        ? () => _handleSubmitted(_textController.text)
                        : null,),
                ),
              ]
          ),
        )
    );
  }

  void _handleSubmitted(String message) {
    setState(() {
      _isComposing = false;
    });
    DateTime time = new DateTime.now();
    String hrs = time.hour
        .toString()
        .length < 2 ? "0" + time.hour.toString() : time.hour.toString();
    String mins = time.minute
        .toString()
        .length < 2 ? "0" + time.minute.toString() : time.minute.toString();
    String secs = time.second
        .toString()
        .length < 2 ? "0" + time.second.toString() : time.second.toString();
    String timeX = hrs + ":" + mins + ":" + secs;
    Map<String, String> datax = {
      "to": widget.chatThread.name,
      "from": widget.myNumber,
      "message": message,
      "time": timeX
    };
    _reference.add(datax).whenComplete(() {
      print("message sent : $message at $time");
    }).catchError((e) => print(e));
    _textController.clear();


    /* ChatMessage message = new ChatMessage(
      from: widget.myNumber,
      message: text,
      /*animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),*/
    );*/
    //setState(() {
    //_chat.add({"to":widget.chatThread.name,"from":widget.myNumber,"message":message,"time":time.hour.toString()+":"+time.minute.toString()});
    // _messages.insert(0, message);
    //});
    //message.animationController.forward();
  }

}

@override
class ChatMessage extends StatelessWidget {
  final String from;
  final String message;
  final String time;
  //final AnimationController animationController;
  ChatMessage({this.from, this.message, this.time/*this.animationController*/});

  Widget build(BuildContext context) {
    return /*new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: */new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            /*new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(from[0])),
            ),*/
            new Expanded(
              child: new Column(
                crossAxisAlignment: from==myNum?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding:new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                      color: from==myNum?Colors.lightGreen[300]:Colors.white,
                      border: new Border(bottom: new BorderSide(),top: new BorderSide(),left: new BorderSide(),right: new BorderSide()),
                    ),
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Container(
                      child: new Column(
                        children: <Widget>[
                          new Text(message),
                          new Text(time.substring(0,time.length-3),style: new TextStyle(fontSize: 10.0),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
   // );
  }
}


class ChatThread {
  final String name;
  final String image;
  ChatThread({this.name,this.image});
}