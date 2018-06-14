import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseDB{
  DocumentReference documentReference;

  FireBaseDB(String addressDB){
    this.documentReference = Firestore.instance.document(addressDB);
  }


  void addName(String data) {
    Map<String,String> datax = {"name":data};
    documentReference.setData(datax).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }

  void delete() {
    documentReference.delete().whenComplete(() {
      print("Deleted Successfully");
    }).catchError((e) => print(e));
  }

  void update(String data) {
    Map<String,String> datax = {"name":data};
    documentReference.updateData(datax).whenComplete(() {
      print("Document Updated");
    }).catchError((e) => print(e));
  }

  String fetch(String result) {
    documentReference.get().then((datasnapshot) {
      if (datasnapshot.exists) {
        print("received" + datasnapshot.data['name']);
           result = (datasnapshot.data['name']);
        }else{
        print("Nothing Fetched...");
           result = "Nothing Fetched";
      }
    }).catchError((e)=>print(e));
    return result;
  }


}