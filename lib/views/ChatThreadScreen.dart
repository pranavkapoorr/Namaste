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
                      Map<String,List<Widget>> map = new Map();
                      for (int i = snapshot.data.documents.length; i > 0; i--) {
                        DocumentSnapshot ds = snapshot.data.documents[i-1];
                        if((ds.data['message'] != null)&&(ds.data['receiver']==widget.myNumber && ds.data['sender']==widget.chatThread.name)||(ds.data['receiver']==widget.chatThread.name && ds.data['sender']==widget.myNumber)){
                          dataList.add(new ChatMsg(sender: ds.data['sender'], message: ds.data['message'], time: ds.data['time'],));
                          if(int.parse(ds.data['time'].substring(0,2))+1==int.parse(ChatMsg._todaysDate())){
                            dataList.add(_dateBox("Yesterday"));
                          }else if(int.parse(ds.data['time'].substring(0,2))==int.parse(ChatMsg._todaysDate())){
                            dataList.add(_dateBox("Today"));
                          }else{
                            dataList.add(_dateBox(ds.data['time'].substring(0,10)));
                          }
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
  Widget _dateBox(String text){
    var decoration = BoxDecoration(
      boxShadow: [
        BoxShadow(
            blurRadius: .5,
            spreadRadius: 1.0,
            color: Colors.black.withOpacity(.12))
      ],
      color: Colors.grey.shade300,
      borderRadius: BorderRadius.all(Radius.circular(2.0)),
    );
    return Column(children:[Container(padding:EdgeInsets.all(1.0),decoration:decoration,child: Text(text))]);
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

  String getTime(){
    return this.time;
  }
  Widget build(BuildContext context) {
      final bg = sender!=myNum? Colors.white : Colors.greenAccent.shade100;
      final align = sender!=myNum ? CrossAxisAlignment.start : CrossAxisAlignment.end;
      final radius = sender!=myNum
          ? BorderRadius.only(
        topRight: Radius.circular(5.0),
        bottomLeft: Radius.circular(10.0),
        bottomRight: Radius.circular(5.0),
      )
          : BorderRadius.only(
        topLeft: Radius.circular(5.0),
        bottomLeft: Radius.circular(5.0),
        bottomRight: Radius.circular(10.0),
      );
     return Padding(
       padding: const EdgeInsetsDirectional.only(start: 2.0,end: 2.0),
       child: Column(
        crossAxisAlignment: align,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.all(3.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    blurRadius: .5,
                    spreadRadius: 1.0,
                    color: Colors.black.withOpacity(.12))
              ],
              color: bg,
              borderRadius: radius,
            ),
            child: Stack(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 48.0),
                  child: Text(message),
                ),
                Positioned(
                  bottom: 0.0,
                  right: 0.0,
                  child: Row(
                    children: <Widget>[
                      Text(time.substring(11,time.length-3),
                          style: TextStyle(
                            color: Colors.black38,
                            fontSize: 10.0,
                          )),
                      SizedBox(width: 3.0),
                      sender==myNum?Icon(
                        Icons.done,
                        size: 12.0,
                        color: Colors.black38,
                      ):SizedBox(width: 0.1,)
                    ],
                  ),
                )
              ],
            ),
          )
        ],
    ),
     );
  }
  static String _todaysDate(){
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