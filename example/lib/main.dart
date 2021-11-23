import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_noti/plugin_noti.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Open the database and store the reference.

  final database = openDatabase(
    // Set the path to the database. Note: Using the `join` function from the
    // `path` package is best practice to ensure the path is correctly
    // constructed for each platform.
    join(await getDatabasesPath(), 'time_database.db'),
    // When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE times(id INTEGER PRIMARY KEY, name TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

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



  @override
  void initState() {
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
      debugPrint(data);

    }
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

            ),])),
      ),
    );
  }
}