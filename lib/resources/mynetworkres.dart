import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

MyProfileHelper myProfile = new MyProfileHelper();

class MyProfileHelper{
  static final MyProfileHelper _db = new MyProfileHelper._internal();
  factory MyProfileHelper() => _db;
  MyProfileHelper._internal();
  bool loaded= false;
  bool loadedTiles = false;
  List tiles = [];
  var me;
  List likes = [];
  List dislikes = [];
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
        getMyDetails().whenComplete((){
          getTiles();
        });
    });
  }
 Future getMyDetails() async {
    loaded = false;
   return http.get(
     "https://namaste-backend.herokuapp.com/users/uphone/" + _myNumber,
   ).then((response) {
     me = json.decode(response.body);
     print(" bodyx: $me");
   }).whenComplete(() {
     likes = me['likes'];
     dislikes = me['dislikes'];
     loaded = true;
     print("checked db");
   });
 }

 Future getTiles() async{
    loadedTiles = false;
   List temp;
   List usernames = [likes, dislikes].expand((x) => x).toList();
   usernames.add(myProfile.me['username']);
   print(usernames);
   return http.post("https://namaste-backend.herokuapp.com/users/all",
       headers: {
         "Content-Type": "application/json",
         "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
         "Accept": "application/json"
       },
       body: json.encode({"usernames": usernames})
   ).then((response) {
     print("Response status: ${response.statusCode}");
     print("Response body: ${response.body}");
     temp = json.decode(response.body);
     print(" body: $temp");
   }).whenComplete(() {
     tiles = temp;
     loadedTiles = true;
     print("got tiles");
 }).catchError((e)=>print(e.toString()));
  }


  updateMyDetails(Map data) async{
   String _updateUrl = "https://namaste-backend.herokuapp.com/users/" + me['_id'];
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
   /*print('here oye');
   if(me['name']!=data['name']||me['gender']!=data['gender']||me['location']!=data['location']||
       me['about']!=data['about']||me['username']!=data['username']||me['likes']!=data['likes']||me['dislikes']!=data['dislikes']) {
     print('here ji');*/
     await http.put(_updateUrl,
       headers: {
         "Content-Type": "application/json",
         "Authorization": "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJpc3MiOiJodHRwczovL2FwaS5jb21hcGkuY29tL2FjY2Vzc3Rva2VucyIsImF1ZCI6Imh0dHBzOi8vYXBpLmNvbWFwaS5jb20iLCJhY2NvdW50SWQiOjM3MTQ0LCJhcGlTcGFjZUlkIjoiYTE4YWY3OTYtMDNiNy00MTg5LTk1OWItMTkzZjA2MjJlOTA1IiwicGVybWlzc2lvbnMiOlsiY29udGVudDp3IiwiY2hhbjpyIiwibXNnOmFueTpzIiwibXNnOnIiLCJwcm9mOnJhIiwiYXBpczpybyJdLCJzdWIiOiJlNTg5OGFhNy1mOTc4LTQ4NGUtYTQyYy1mZGVmMDEwMmFjY2UiLCJwcm9maWxlSWQiOiJOYW1hc3RlLUF1dGgiLCJuYW1lIjoiTmFtYXN0ZUF1dGhYIiwiaWF0IjoxNTI5NDAyMjY3fQ.M7XHQH23dw4qze4UQRZsjGZSNAVs2touYqeyrHz8a8E",
         "Accept": "application/json"
       },
       body: json.encode(data),
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

   //}
 }

}

