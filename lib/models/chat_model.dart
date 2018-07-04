import 'package:meta/meta.dart';

class ChatMessage {
  ChatMessage({
    @required this.sender,
    @required this.receiver,
    @required this.message,
    @required this.time,
    this.synced,
  }){
    id = counter.toString();
    counter++;
  }
  static int counter = 0;
  String sender, id, receiver, message, time;
  bool synced;

  ChatMessage.fromJson(Map json)
      : sender = json["title"],
        receiver = json["poster_path"],
        message = json["overview"],
        synced = false;

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['id'] = id;
    map['sender'] = sender;
    map['receiver'] = receiver;
    map['message'] = message;
    map['synced'] = synced;
    return map;
  }
}
class User {
  User({
    @required this.name,
    @required this.number,
    @required this.dp,
    @required this.id,
    @required this.gender,
  });

  String name, number, id, dp, gender;


  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['number'] = number;
    map['id'] = id;
    map['dp'] = dp;
    map['name'] = name;
    map['gender'] = gender;
    return map;
  }
}



class DataModel {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;

  DataModel({this.name, this.message, this.time, this.avatarUrl});
}

List<DataModel> dummyDataChat = [
  new DataModel(
      name: "Pranav Kapoor",
      message: "Hey there, You are so amazing !",
      time: "15:30",
      avatarUrl:
      "https://i.pinimg.com/736x/34/77/c3/3477c3b54457ef50c2e03bdaa7b3fdc5.jpg"),
  new DataModel(
      name: "Harvey Spectre",
      message: "Hey I have hacked whatsapp!",
      time: "17:30",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Mike Ross",
      message: "Wassup !",
      time: "5:00",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Rachel",
      message: "I'm good!",
      time: "10:30",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Barry Allen",
      message: "I'm the fastest man alive!",
      time: "12:30",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Joe West",
      message: "Hey Flutter, You are so cool !",
      time: "15:30",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Barny len",
      message: "I'm the alive!",
      time: "12:32",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
  new DataModel(
      name: "Jimmy West",
      message: "Hey cool !",
      time: "15:31",
      avatarUrl:
      "http://www.usanetwork.com/sites/usanetwork/files/styles/629x720/public/suits_cast_harvey.jpg?itok=fpTOeeBb"),
];