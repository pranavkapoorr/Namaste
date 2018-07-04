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

class _ChatThreadScreenState extends State<ChatThreadScreen> {
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
                      for (int i = snapshot.data.documents.length; i > 0; i--) {
                        DocumentSnapshot ds = snapshot.data.documents[i-1];
                        if((ds.data['message'] != null)&&(ds.data['receiver']==widget.myNumber && ds.data['sender']==widget.chatThread.name)||(ds.data['receiver']==widget.chatThread.name && ds.data['sender']==widget.myNumber)){
                          dataList.add(new ChatMsg(sender: ds.data['sender'], message: ds.data['message'], time: ds.data['time'],));
                          }
                      }
                      dataList.sort((a,b)=>a.toString().compareTo(b.toString()));
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
    String day = time.day
        .toString()
        .length < 2 ? "0" + time.day.toString() : time.day.toString();
    String mnth = time.month
        .toString()
        .length < 2 ? "0" + time.month.toString() : time.month.toString();
    String yr = time.year.toString();
    String hrs = time.hour
        .toString()
        .length < 2 ? "0" + time.hour.toString() : time.hour.toString();
    String mins = time.minute
        .toString()
        .length < 2 ? "0" + time.minute.toString() : time.minute.toString();
    String secs = time.second
        .toString()
        .length < 2 ? "0" + time.second.toString() : time.second.toString();
    String timeX = day +"/"+ mnth +"/"+ yr+ ":" +hrs + ":" + mins + ":" + secs;
    Map<String, String> datax = {
      "receiver": widget.chatThread.name,
      "sender": widget.myNumber,
      "message": message,
      "time": timeX
    };
    _reference.add(datax).whenComplete(() {
      print("message sent : $message at $time");
    }).catchError((e) => print(e));
    _textController.clear();
  }

}

@override
class ChatMsg extends StatelessWidget {
  final String sender;
  final String message;
  final String time;
  ChatMsg({this.sender, this.message, this.time});

  Widget build(BuildContext context) {
    return new Container(
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
                crossAxisAlignment: sender==myNum?CrossAxisAlignment.end:CrossAxisAlignment.start,
                children: <Widget>[
                  new Container(
                    padding:new EdgeInsets.all(4.0),
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(const Radius.circular(10.0)),
                      color: sender==myNum?Colors.lightGreen[300]:Colors.white,
                      border: new Border(bottom: new BorderSide(),top: new BorderSide(),left: new BorderSide(),right: new BorderSide()),
                    ),
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Container(
                      child: new Column(
                        children: <Widget>[
                          new Text(message),
                          new Text(_chatMsgDate(time),style: new TextStyle(fontSize: 10.0),)
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
  }
  String _todaysDate(){
    DateTime time = new DateTime.now();
    return time.day.toString().length<2?"0"+time.day.toString():time.day.toString();
  }
  String _chatMsgDate(String time){
    if(int.parse(time.substring(0,2))+1==int.parse(_todaysDate())){
      return "Yesterday";
    }else if(int.parse(time.substring(0,2))==int.parse(_todaysDate())){
      return time.substring(11,time.length-3);
    }else{
      return time.substring(0,10);
    }
  }
}


class ChatThread {
  final String name;
  final String image;
  ChatThread({this.name,this.image});
}