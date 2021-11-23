
import 'dart:async';

import 'package:flutter/services.dart';

class PluginNoti {
  static const MethodChannel _channel =
      const MethodChannel('plugin_noti');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  static Future<String> get startService async {
    final String data = await _channel.invokeMethod('startService');
    return data;
  }
}
