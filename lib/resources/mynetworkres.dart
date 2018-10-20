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

}