import 'package:flutter/material.dart';

class ChatThreadScreen extends StatefulWidget {
  final ChatThread chatThread;

  ChatThreadScreen({Key key, @required this.chatThread}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new ChatThreadScreenState();
  }

}

class ChatThreadScreenState extends State<ChatThreadScreen> with TickerProviderStateMixin{
  final TextEditingController _textController = new TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  bool _isComposing = false;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        titleSpacing:1.0,
        title: new Row(
          children: <Widget>[
            new IconButton(icon: new CircleAvatar(backgroundImage: new NetworkImage('${widget.chatThread.image}'),radius: 15.0,),onPressed: null,),
            new Padding(padding: new EdgeInsetsDirectional.only(end: 10.0)),
            new GestureDetector(
              child: new Text('${widget.chatThread.name}',style: new TextStyle(color: new Color(0xffA1A9A9))),
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
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) => _messages[index],
                    itemCount: _messages.length,
                  )),
              new Divider(height: 1.0),
              new Container(
                  decoration: new BoxDecoration(
                      color: Theme.of(context).cardColor),
                  child: _buildTestComposer()
              ),
            ],
          ),
          decoration: Theme.of(context).platform == TargetPlatform.iOS ? new BoxDecoration(border: new Border(top: new BorderSide(color: Colors.grey[200]))) : null),//new
    );
  }

  Widget _buildTestComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: new Row(
              children: <Widget>[
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                      icon: new Icon(Icons.photo_camera),
                      onPressed:null),
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
                        ?_handleSubmitted
                        :null,
                    decoration:
                    new InputDecoration.collapsed(hintText: "Send a message"),
                  ),
                ),
                new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: /*Theme.of(context).platform == TargetPlatform.iOS ?
                  new CupertinoButton(
                    child: new Text("Send"),
                    onPressed:  null,) :
*/
                  new IconButton(
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

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    ChatMessage message = new ChatMessage(
      text: text,
      animationController: new AnimationController(
        duration: new Duration(milliseconds: 700),
        vsync: this,
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages)
      message.animationController.dispose();
    super.dispose();
  }
}


@override
class ChatMessage extends StatelessWidget {
  String _name = "Pranav";
  ChatMessage({this.text, this.animationController});
  final String text;
  final AnimationController animationController;

  Widget build(BuildContext context) {
    return new SizeTransition(
      sizeFactor: new CurvedAnimation(
          parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new CircleAvatar(child: new Text(_name[0])),
            ),
            new Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  new Text(_name, style: Theme.of(context).textTheme.subhead),
                  new Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: new Text(text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}

class ChatThread {
  final String name;
  final String image;
  ChatThread({this.name,this.image});
}