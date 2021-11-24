import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_noti/plugin_noti.dart';
import 'package:plugin_noti/db.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.



 runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class Time {
  int id;
  String name;
  Time({
  this.id,
  this.name
  }
  );
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name
    };
  }

}

class _MyHomePageState extends State<MyHomePage> {

  Timer timer;
  bool started=false;
  int count=0;



  @override
   initState() {
    super.initState();

    timer = Timer.periodic(Duration(seconds: 15), (Timer t) => startIfTrue());
  }

  void startIfTrue() {
    if(started==true){
      startTimingInAndroid();
    }
  }


  void turnOnTiming(){
    started=true;
    debugPrint("start timeing now");
  }
  void trunOffTiming(){
    started=false;
  }
  void startTimingInAndroid() async{
    if(Platform.isAndroid){
      debugPrint('Trying to start timing.');
      String data = await PluginNoti.startTiming;
      await commitToDatabase(count, data);
      count++;

    }
  }
  Future<void> cleanUpDatabase() async{
    var db= await DB.instance.database;
    db.rawDelete("delete * from times;");
  }
  Future<void> commitToDatabase(int id,String detail) async {
    var db = await DB.instance.database;
    String sql = "insert into times (id, detail) values (?, ?)";
    db.rawInsert(sql,[id,detail]);
    var result = await db.rawQuery("select * from times;");
    debugPrint(result.toString());


  }
  void startServiceInAndroid() async {
    if(Platform.isAndroid){
      debugPrint('Trying to start service.');
      String data = await PluginNoti.startService;
      started = true;
      debugPrint(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          child:Column( children: <Widget>[
            RaisedButton(
                child: Text("Start Background Service"),
                onPressed: (){
                  startServiceInAndroid();
                }

            ),
            RaisedButton(
                child: Text("Start Timing Service"),
                onPressed: (){
                  turnOnTiming();
                }

            ),
            RaisedButton(
                child: Text("Clean up database"),
                onPressed: (){
                  cleanUpDatabase();
                }

            )])),
      ),
    );
  }
}