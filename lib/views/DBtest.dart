import 'package:flutter/material.dart';
import 'package:flutter_app/resources/FireBaseDBResources.dart';

class DBtest extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new DBtestState();
  }

}
class DBtestState extends State<DBtest>{
  TextEditingController controller = new TextEditingController();
  String myText = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Firebase Demo"),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new TextField(controller: controller,),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: (){new FireBaseDB().addName(controller.value.text);},
              child: new Text("AddX"),
              color: Colors.cyan,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: (){new FireBaseDB().update(controller.value.text);},
              child: new Text("UpdateX"),
              color: Colors.lightBlue,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: (){new FireBaseDB().delete();},
              child: new Text("DeleteX"),
              color: Colors.orange,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: (){
                print(new FireBaseDB().authenticateUser("App-Data",controller.value.text));

                },
              child: new Text("Fetch"),
              color: Colors.lime,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            new RaisedButton(
              onPressed: (){
                 new FireBaseDB().addToDb( controller.text);
              },
              child: new Text("FetchX"),
              color: Colors.lime,
            ),
            new Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            myText == null
                ? new Text("empty")
                : new Text(
              myText,
              style: new TextStyle(fontSize: 20.0),
            )
          ],
        ),
      ),
    );

  }



}