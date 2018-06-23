import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class FireBaseDB {
  CollectionReference _documentReference;

  void addToDb(String number) {
    bool result = false;
    _documentReference = Firestore.instance.collection("App-Data");
    _documentReference.getDocuments().then(
            (querySnapshot) {
          for (int i = 0; i < querySnapshot.documents.length; i++) {
            print(querySnapshot.documents[i]['number']);
            if (querySnapshot.documents[i]['number'].toString() == number) {
              result = true;
            }}}).whenComplete((){
              if(result!=true){
                Map<String, String> datax = {"number": number,"dp":"https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg"};
                _documentReference.add(datax).whenComplete(() {
                  print("Number Added");
                }).catchError((e) => print(e));
              }else{
                print("User already exists");
              }
    });

  }
  void fetch() {
    _documentReference = Firestore.instance.collection("App-Data");
  }

  void addName(String data) {
    Map<String, String> datax = {"name": data};
    _documentReference.add(datax).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void delete() {
    // documentReference.delete().whenComplete(() {
    //  print("Deleted Successfully");
    //}).catchError((e) => print(e));
  }

  void update(String data) {
    //Map<String,String> datax = {"name":data};
    //documentReference.updateData(datax).whenComplete(() {
    //  print("Document Updated");
    //}).catchError((e) => print(e));
  }

  authenticateUser(String addressDB, String number) {
    bool result = false;
    _documentReference = Firestore.instance.collection(addressDB);
    return _documentReference.getDocuments().then(
            (querySnapshot) {
          for (int i = 0; i < querySnapshot.documents.length; i++) {
            print(querySnapshot.documents[i]['number']);
            if (querySnapshot.documents[i]['number'].toString() == number) {
              result = true;
            }
          }
        }
    ).whenComplete(() {
      return result;
    }).catchError((e) => print(e));
  }

  Future<List<DocumentSnapshot>> getAllNumbers(String addressDB) async {
    _documentReference = Firestore.instance.collection(addressDB);
    var dox = await _documentReference.getDocuments();
    print("loaded numbers:");
    dox.documents.forEach((d) => print(d.data));
    return dox.documents;
  }

  Future<Map<String, String>> getUserData(String addressDB) async {
    Map<String, String> map = new Map();
    _documentReference = Firestore.instance.collection(addressDB);
    var dox = await _documentReference.getDocuments();
    print("loaded numbers:");
    dox.documents.forEach((d) {
      map[d.data['number']] = d.data['dp'];
    });
    print(map);
    return map;
  }

  Future<List<DocumentSnapshot>> getChats(String addressDB) async {
    _documentReference = Firestore.instance.collection(addressDB);
    var dox = await _documentReference.getDocuments();
    print("loaded chats:");
    dox.documents.forEach((d) => print(d.data));
    dox.documents.removeWhere((d) => !d.data.containsValue("447488706094"));
    print("chats with me:");
    dox.documents.forEach((d) => print(d.data));
    return dox.documents;
  }

  void fetchLive(String addressDB) {
    _documentReference = Firestore.instance.collection(addressDB);
    StreamSubscription<QuerySnapshot> subscription = _documentReference
        .snapshots().listen((datasnapshot) {
          datasnapshot.documents.forEach((d)=>print(d.data));
    });
    subscription.cancel();
  }
}