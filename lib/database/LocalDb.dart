import 'package:flutter_app/models/chat_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';


class NamasteDatabase {
  static final NamasteDatabase _instance = NamasteDatabase._internal();

  factory NamasteDatabase() => _instance;

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  NamasteDatabase._internal();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE Chats(id STRING PRIMARY KEY, message TEXT, sender TEXT, receiver TEXT, timeStamp TEXT, synced BIT);");
    print("Database was Created!");
  }

  void dropTable() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    await deleteDatabase(path).catchError((e)=>print(e));
  }


  Future<int> addMessage(ChatMessageModel msg) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Chats", msg.toMap());
      return res;
    } catch (e) {
      int res = await updateMessage(msg);
      return res;
    }
  }

  Future<int> updateMessage(ChatMessageModel msg) async {
    var dbClient = await db;
    int res;
    try {
      res = await dbClient.update("Chats", msg.toMap(),
          where: "id = ?", whereArgs: [msg.id]);
      return res;
    }catch(e){
      print(e);
    }
    return res;
  }

  Future<int> deleteMessage(String id) async {
    var dbClient = await db;
    var res = await dbClient.delete("Chats", where: "id = ?", whereArgs: [id]);
    print("Message deleted $res");
    return res;
  }
  Future<int> deleteAllMessages() async {
    var dbClient = await db;
    var res = await dbClient.execute("DELETE FROM Chats");
    print("Message deleted $res");
    return res;
  }

  Future<List> getMessages() async {
    var dbClient = await db;
    var res = await dbClient.query("Chats",columns:["sender, receiver, message, timeStamp, id, synced"]);
    print("Messages loaded $res");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }
}