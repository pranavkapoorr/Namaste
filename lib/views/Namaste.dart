import 'package:flutter/material.dart';

class Namaste extends StatefulWidget{
  @override
  _NamasteState createState()=> new _NamasteState();
}
class _NamasteState extends State<Namaste>{
  @override
  Widget build(BuildContext context){
    return  NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(title: Text("hello"),)
              //_searchClicked?_searchAppBar(innerBoxIsScrolled):_normalAppBar(innerBoxIsScrolled),
            ];
          },
          body: new Scaffold(backgroundColor: Colors.white,),
      );
  }
}