import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:Namaste/resources/FireBaseDBResources.dart';
import 'package:Namaste/views/ChatThreadScreen.dart';
//import 'package:contacts_service/contacts_service.dart';

class ContactsUsingScreen extends StatefulWidget{
  final String myNumber;
  ContactsUsingScreen({this.myNumber});

  @override
  _ContactsUsingScreenState createState() => new _ContactsUsingScreenState();

}

class _ContactsUsingScreenState extends State<ContactsUsingScreen> {
  //Iterable<Contact> _contacts;
  FireBaseDB db = new FireBaseDB();
  List<DocumentSnapshot> _numbers;
  bool loading = false;

  @override
  initState() {
    super.initState();
    loading = true;
    loadAllUsers();
  }

  void loadAllUsers()async{
    var data = await db.getAllNumbers("App-Data").whenComplete((){print("loaded...");}).catchError((e)=>print(e));
      setState(() {
        _numbers = data;
        loading = false;
      });
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return new Scaffold(body: new Center(child: new CircularProgressIndicator(),));
    }else {
      return new Scaffold(
        appBar: new AppBar(
          title: new Text("Start New Conversation",style: new TextStyle(color: Theme.of(context).accentColor),),
        ),
        body: new ListView.builder(
          itemCount: _numbers.length != null ? _numbers.length : 0,
          itemBuilder: (context, index) =>
          new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Divider(height: 0.7,),
              new ListTile(
                leading: new CircleAvatar(backgroundImage: new NetworkImage(_numbers[index].data['dp']),),
                title: new Text(_numbers[index].data['number']),
                onTap:() {
                    Navigator.push(
                    context,
                    new MaterialPageRoute(
                    builder: (context) => new ChatThreadScreen(
                      chatThread: new ChatThread(
                      name: _numbers[index].data['number'],
                      image: _numbers[index].data['dp'],),
                      myNumber: widget.myNumber,
                    ),
                    ),
                    );
                },
              ),
            ],
          ),
        ),
      );
    }
  }
}

 /*initPlatformState() async {
    var contacts = await ContactsService.getContacts().catchError((e)=>print(e));
    setState(() {
      print("setting contacts");
      _contacts = contacts;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
    appBar: new AppBar(title: new Text('Contacts plugin example')),
    floatingActionButton: new FloatingActionButton(
    child: new Icon(Icons.add),
    onPressed: (){Navigator.of(context).pushNamed("/add");}
    ),
    body: new SafeArea(
    child: _contacts != null?
    new ListView.builder(
    itemCount: _contacts?.length ?? 0,
    itemBuilder: (BuildContext context, int index) {
    Contact c = _contacts?.elementAt(index);
    return new ListTile(
    onTap: () { Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new _ContactDetails(c)));},
    leading: (c.avatar != null && c.avatar.length > 0) ?
    new CircleAvatar(backgroundImage: new MemoryImage(c.avatar)):
    new CircleAvatar(child:  new Text(c.displayName?.length > 1 ? c.displayName?.substring(0, 2) : "")),
    title: new Text(c.displayName ?? ""),
    );
    },
    ):
    new Center(child: new CircularProgressIndicator()),
    ),
    );
  }
}
class _ContactDetails extends StatelessWidget{

  _ContactDetails(this._contact);
  final Contact _contact;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: new Text(_contact.displayName ?? ""),
            actions: <Widget>[new FlatButton(child:new Icon(Icons.delete), onPressed: (){ContactsService.deleteContact(_contact);})]
        ),
        body: new SafeArea(
          child: new ListView(
            children: <Widget>[
              new ListTile(title: new Text("Name"),trailing: new Text(_contact.givenName ?? "")),
              new ListTile(title: new Text("Middle name"),trailing: new Text(_contact.middleName ?? "")),
              new ListTile(title: new Text("Family name"),trailing: new Text(_contact.familyName ?? "")),
              new ListTile(title: new Text("Prefix"),trailing: new Text(_contact.prefix ?? "")),
              new ListTile(title: new Text("Suffix"),trailing: new Text(_contact.suffix ?? "")),
              new ListTile(title: new Text("Company"),trailing: new Text(_contact.company ?? "")),
              new ListTile(title: new Text("Job"),trailing: new Text(_contact.jobTitle ?? "")),
              new _AddressesTile(_contact.postalAddresses),
              new ItemsTile("Phones", _contact.phones),
              new ItemsTile("Emails", _contact.emails)
            ],
          ),
        )
    );
  }
}

class _AddressesTile extends StatelessWidget{

  _AddressesTile(this._addresses);
  final Iterable<PostalAddress> _addresses;

  Widget build(BuildContext context){
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(title : new Text("Addresses")),
          new Column(
              children: _addresses.map((a) => new Padding(
                padding : const EdgeInsets.symmetric(horizontal: 16.0),
                child: new Column(
                  children: <Widget>[
                    new ListTile(title : new Text("Street"), trailing: new Text(a.street)),
                    new ListTile(title : new Text("Postcode"), trailing: new Text(a.postcode)),
                    new ListTile(title : new Text("City"), trailing: new Text(a.city)),
                    new ListTile(title : new Text("Region"), trailing: new Text(a.region)),
                    new ListTile(title : new Text("Country"), trailing: new Text(a.country)),
                  ],
                ),
              )).toList()
          )
        ]
    );
  }
}

class ItemsTile extends StatelessWidget{

  ItemsTile(this._title, this._items);
  Iterable<Item> _items;
  String _title;

  @override
  Widget build(BuildContext context) {
    return new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListTile(title : new Text(_title)),
          new Column(
              children: _items.map((i) => new Padding(
                  padding : const EdgeInsets.symmetric(horizontal: 16.0),
                  child: new ListTile(title: new Text(i.label ?? ""), trailing: new Text(i.value ?? "")))).toList()
          )
        ]
    );
  }
}*/
