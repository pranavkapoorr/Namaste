import 'package:flutter/material.dart';
import 'dart:async';

class AccountScreen extends StatefulWidget {
  @override
  AccountScreenState createState() {
    return new AccountScreenState();
  }

}

class AccountScreenState extends State<AccountScreen>{

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text("Account"),),
        body: new Scaffold(

          body: new ListView(
              children: <Widget>[ new Column(
                children: <Widget>[

                  new ListTile(title: new Text("Change Your Number"),leading: new Icon(Icons.phone_android,color:Colors.black),onTap: _AccountPage,),
                  new ListTile(title: new Text("Delete Your Account"),leading: new Icon(Icons.delete_outline,color:Colors.black),),
                  new ListTile(title: new Text("Terms & Conditions"),leading: new Icon(Icons.business_center,color:Colors.black),)

                ],
              ) ]),
        )
    );
  }
  Future _AccountPage(){
    return Navigator.of(context).push(new MaterialPageRoute(builder: (context)=> new AccountScreen()));
  }
}
class AccountMenuItems {
  final Text name;
  final Text status;
  final IconButton icon;
  AccountMenuItems({this.name,this.status,this.icon});
}
