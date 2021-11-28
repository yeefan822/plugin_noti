package com.example.plugin_noti_example;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;
import java.util.Calendar;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import android.os.Handler;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import app.loup.streams_channel.StreamsChannel;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.StringCodec;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.tekartik.sqflite.SqflitePlugin;
import androidx.annotation.NonNull;
import io.flutter.embedding.engine.FlutterEngine;


public class MainActivity extends FlutterActivity {

    private Intent forService;
    private String CHANNEL = "CHANNEL";

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        FlutterEngine flutterEngine=new FlutterEngine(this);
       // StreamPlugin.registerWith(GeneratedPluginRegistrant.);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        flutterEngine.getPlugins().add(new StreamPlugin());
        SqflitePlugin.registerWith(registrarFor("com.tekartik.sqflite.SqflitePlugin"));

        forService = new Intent(MainActivity.this,MainService.class);

        new EventChannel(getFlutterView(),"samples.flutter.io/charging").setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object o, EventChannel.EventSink eventSink) {
                eventSink.success("hello world !");
            }

            @Override
            public void onCancel(Object o) {

            }
        });
        new MethodChannel(getFlutterView(),"plugin_noti")
                .setMethodCallHandler(new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        if(methodCall.method.equals("startService")){
                            startService();
                            result.success("Service Started");
                        }else if (methodCall.method.equals("startTiming")){
                            Date currentTime = Calendar.getInstance().getTime();
                            DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
                            result.success(dateFormat.format(currentTime));



    }


                        }
                    }
                );}






    private void startService(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(forService);
        } else {
            startService(forService);
        }
    }
}



