
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class PluginNoti {

  static const MethodChannel _channel =
      const MethodChannel('plugin_noti');

  static const BasicMessageChannel<String> _basicMessageChannel =
  BasicMessageChannel("BasicMessageChannelPlugin", StringCodec());

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String> get startService async {
    final String data = await _channel.invokeMethod('startService');
    return data;
  }
  static Future<String> get startTiming async {
    final String data = await _channel.invokeMethod('startTiming');
    return data;
  }
  static Future<void> startSending() async{
    await _channel.invokeMethod('startSending');
  }

}
