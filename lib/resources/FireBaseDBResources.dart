import 'package:cloud_firestore/cloud_firestore.dart';

class FireBaseDB{
  CollectionReference documentReference;

  FireBaseDB(String addressDB){
    this.documentReference = Firestore.instance.collection(addressDB);
  }


  void addName(String data) {
    Map<String,String> datax = {"name":data};
    documentReference.add(datax).whenComplete(() {
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

  bool authenticateUser(String number) {
    bool result = false;
    documentReference.getDocuments().then(
            (querySnapshot) {
              for(int i = 0; i < querySnapshot.documents.length; i++){
                print(querySnapshot.documents[i]['number']);
                if(querySnapshot.documents[i]['number'].toString() == number){
                  result = true;
                }
              }
            }
    ).whenComplete((){ return result;}).catchError((e)=>print(e));
    return result;
  }
  void getCollections() {
    //Map<String,String> datax = {"name":data};
    print(documentReference.buildArguments());
  }


}