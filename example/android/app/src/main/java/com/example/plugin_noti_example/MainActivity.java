package com.example.plugin_noti_example;

import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.RequiresApi;
import java.util.Calendar;
import java.util.Date;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.tekartik.sqflite.SqflitePlugin;

public class MainActivity extends FlutterActivity {

    private Intent forService;

    @RequiresApi(api = Build.VERSION_CODES.O)
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(new FlutterEngine(this));
        SqflitePlugin.registerWith(registrarFor("com.tekartik.sqflite.SqflitePlugin"));

        forService = new Intent(MainActivity.this,MainService.class);

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
                });


    }



    private void startService(){
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            startForegroundService(forService);
        } else {
            startService(forService);
        }
    }



}