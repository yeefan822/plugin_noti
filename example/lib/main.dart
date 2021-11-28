import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_noti/plugin_noti.dart';
import 'package:plugin_noti/db.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:plugin_noti/streams_channel.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open the database and store the reference.



 runApp(MyApp());
}
final StreamsChannel streamsChannel = StreamsChannel('streams_channel_example');
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
  StreamSubscription<dynamic> _subscriptionA;
  StreamSubscription<dynamic> _subscriptionB;
  Timer timer;
  bool started=false;
  int count=0;
  String _chargingStatus = 'Battery status: unknown.';
  final StreamsChannel streamsChannel = StreamsChannel('streams_channel_example');
  static const EventChannel eventChannel = EventChannel('samples.flutter.io/charging');


  @override
   initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 10), (Timer t) => startIfTrue());
    eventChannel.receiveBroadcastStream().listen(_onEvent, onError: _onError);

  }
  void _onEvent(Object event) {
    debugPrint(event.toString());
  }

  void _onError(Object error) {
    setState(() {
      PlatformException exception = error;
      _chargingStatus = exception?.message ?? 'Battery status: unknown.';
    });
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
  void _start(bool a) {
    // ignore: cancel_subscriptions
    StreamSubscription<dynamic> subscription =
    a ? _subscriptionA : _subscriptionB;

    if (subscription != null) {
      subscription.cancel();
      subscription = null;
    } else {
      final streamId = 'Stream ${a ? 'A' : 'B'}';
      subscription = streamsChannel
          .receiveBroadcastStream(streamId)
          .listen((data) => debugPrint('Received from $streamId: $data'));

      subscription.onDone(() {
        setState(() {
          if (a) {
            _subscriptionA = null;
          } else {
            _subscriptionB = null;
          }
        });
      });
    }

    setState(() {
      if (a) {
        _subscriptionA = subscription;
      } else {
        _subscriptionB = subscription;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Container(
          child:Column( children: <Widget>[
            Spacer(),
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
                  startIfTrue();
                }

            ),
            RaisedButton(
              onPressed: () => _start(false),
              child: Text(_subscriptionB != null ? 'Stop B' : 'Start B'),
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