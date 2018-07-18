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
            child:new ListView(
                children: <Widget>[ Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                color: Colors.blueGrey.shade100,),
              child:
                    new Column(
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
                          Padding(
                            padding: const EdgeInsetsDirectional.only(top: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                              DecoratedBox(
                                decoration: new BoxDecoration(
                                border: new Border.all(color: Colors.redAccent),
                                borderRadius: new BorderRadius.circular(20.0),
                                ),
                                child:  MaterialButton(onPressed: (){},child: Text("Change Picture"),elevation: 2.0,color: Colors.redAccent,)
                            )
                              ],
                            ),
                          )
                        ],
                        ),
                      ),
                      Container(
                        color: Colors.white70,
                        padding: EdgeInsets.all(10.0),
                        margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 5.0),
                        child: Column(
                          children: <Widget>[
                            Row(children: <Widget>[Text("General",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),

                        new ListTile(leading:Icon(Icons.contact_mail,color: Colors.redAccent,),title: TextField(decoration: InputDecoration.collapsed(hintText: "username"),)),
                        new Divider(height: 0.1,color: Colors.grey.shade400,),
                        new ListTile(leading: new Icon(Icons.person,color:Colors.green),title:TextField(decoration: InputDecoration.collapsed(hintText: "Full name"),)),
                        new Divider(height: 0.1,color: Colors.grey.shade400,),
                        new ListTile(leading: new Icon(Icons.wc,color:Colors.yellowAccent),title: TextField(decoration: InputDecoration.collapsed(hintText: "Gender"),)),
                        ]),
                      ),
                        Container(
                          color: Colors.white70,
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 5.0),
                          child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[Text("Album",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Icon(Icons.image,size: 35.0,color: Colors.redAccent,),
                                        Container(
                                          height: 50.0,
                                          constraints: BoxConstraints(maxWidth: 260.0,maxHeight: 50.0),
                                          child: _album(),
                                        ),
                                        Icon(Icons.navigate_next)
                                      ],
                                    ),
                                  ],
                                )
                              ]
                          ),
                        ),
                        Container(
                          color: Colors.white70,
                          padding: EdgeInsets.all(10.0),
                          margin: EdgeInsetsDirectional.only(top: 8.0,bottom: 15.0),
                          child: Column(
                              children: <Widget>[
                                Row(children: <Widget>[Text("About Me",style: new TextStyle(fontSize: 15.0,fontWeight: FontWeight.bold),)],),
                                Column(
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Icon(Icons.description,color: Colors.green,size: 35.0,),
                                        Container(
                                            constraints: BoxConstraints(maxWidth: 300.0,maxHeight: 90.0),
                                            child:TextField(
                                              decoration: InputDecoration(
                                                  hintText: "short bio",
                                                  border: InputBorder.none
                                              ),
                                              maxLines: 5,
                                              maxLength: 150,
                                              maxLengthEnforced: true,
                                              enabled: true,
                                              keyboardType: TextInputType.multiline,
                                            )
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ]
                          ),
                        )

                    ],
                  )
                )]
              ),

          )
      ),
    );
  }
  Widget _albumImage(Image image){
    return  GestureDetector(onTap:(){},child: Container(margin: EdgeInsets.all(1.0),child:image));
  }
  Widget _album() {
    List<Widget> images = [
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),
      _albumImage(new Image(image: AssetImage("images/bg.jpg"),width: 50.0,height: 50.0,)),

    ];
    return Container(
      child: new ListView(
          scrollDirection: Axis.horizontal,
          children: images
      ),
    );
  }

}