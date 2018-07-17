import 'package:Namaste/resources/UiResources.dart';
import 'package:flutter/material.dart';
class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => new _EditProfileState();
}
class _EditProfileState extends State<EditProfile>{
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient:myGradient,),
      child: new Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(title: new Text("Edit Profile",style: TextStyle(color: Colors.white),),backgroundColor: Colors.transparent,),
          body: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      blurRadius: .5,
                      spreadRadius: 1.0,
                      color: Colors.black.withOpacity(.12))
                ],
                borderRadius:  BorderRadius.all(Radius.circular(5.0))
            ),
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                color: Colors.white,),
              child: new ListView(
                  children: <Widget>[ new Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsetsDirectional.only(top: 5.0),
                        child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircleAvatar(backgroundImage: NetworkImage("https://scontent-lhr3-1.xx.fbcdn.net/v/t1.0-9/11230099_10206835592669367_2911893136176495642_n.jpg?_nc_cat=0&oh=eb80db39d72968cc4a130d4d075ea24a&oe=5BE80A4C"),
                                radius: 45.0,)
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              MaterialButton(onPressed: (){},child: Text("Change Picture"),elevation: 2.0,)
                            ],
                          )
                        ],
                      ),),
                      new ListTile(leading:Icon(Icons.contact_mail,color: Colors.redAccent,),title: TextField(decoration: InputDecoration.collapsed(hintText: "username"),),trailing: Icon(Icons.navigate_next),),
                      new Divider(height: 1.0,color: Colors.black,),
                      new ListTile(leading: new Icon(Icons.person,color:Colors.green),title:TextField(decoration: InputDecoration.collapsed(hintText: "Name"),),trailing: Icon(Icons.navigate_next)),
                      new Divider(height: 1.0,color: Colors.black,),
                      new ListTile(leading: new Icon(Icons.wc,color:Colors.yellowAccent),title: TextField(decoration: InputDecoration.collapsed(hintText: "Gender"),),trailing: Icon(Icons.navigate_next)),


                    ],
                  ) ]),
            ),
          )
      ),
    );
  }


}