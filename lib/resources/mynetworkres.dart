import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

MyProfileHelper myProfile = new MyProfileHelper();

class MyProfileHelper{
  static final MyProfileHelper _db = new MyProfileHelper._internal();
  factory MyProfileHelper() => _db;
  MyProfileHelper._internal();
  bool loaded= false;
  var me;
  String _myNumber;

  ObserverList<Function> _listeners = new ObserverList<Function>();

  /// ---------------------------------------------------------
  /// Adds a callback to be invoked in case of incoming
  /// notification
  /// ---------------------------------------------------------
  addListener(Function callback){
    _listeners.add(callback);
  }
  removeListener(Function callback){
    _listeners.remove(callback);
  }

  Future loadUser() async{
    return SharedPreferences.getInstance().then((SharedPreferences sp) {
      _myNumber = sp.getString("myNumber");
    }).whenComplete((){
        getMyDetails();
    });
  }
 Future getMyDetails() async {
   var temp;
   return http.get(
     "https://namaste-backend.herokuapp.com/users/uphone/" + _myNumber,
   ).then((response) {
     temp = json.decode(response.body);
     print(" bodyx: $temp");
     me = temp;
   }).whenComplete(() {
     loaded = true;
     print("checked db");
   });
 }

 Future updateMyDetails(Map _data) async{
   String _updateUrl = "https://namaste-backend.herokuapp.com/users/" + myProfile.me['_id'];
   /*Map _data = {
     "name": me['name'],
     "email": me['email'],
     "phone": me['phone'],
     "gender": me['gender'],
     "dob": me['dob'],
     "dp": me['dp'],
     "location": me['location'],
     "about": me['about'],
     "username": me['username'],
     "password": me['password'],
     "likes": me['likes'],
     "dislikes": me['dislikes']
   };*/
   if(myProfile.me['name']!=_data['name']||myProfile.me['gender']!=_data['gender']||myProfile.me['location']!=_data['location']||
       myProfile.me['about']!=_data['about']||myProfile.me['username']!=_data['username']) {
     return http.put(_updateUrl,
       headers: {
         "Content-Type": "application/json",
         "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
         "Accept": "application/json"
       },
       body: json.encode(_data),
     ).then((response) {
       print('response -> ${response.statusCode}');
       if(response.statusCode == 200){
           print("status ok");
         }else{
         print("status ko");
       }
       }).whenComplete(() {
       print("details updated");
     });

   }else{
     return new Future.value("nothing to update");
   }
 }

}

