package com.example.plugin_noti_example;

import android.os.Handler;

import com.example.plugin_noti.StreamsChannel;
import com.example.plugin_noti.StreamsChannelPlugin;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.PluginRegistry;


public class StreamPlugin implements FlutterPlugin {

    public static void registerWith(PluginRegistry.Registrar registrar) {
        final StreamsChannel channel = new StreamsChannel(registrar.messenger(), "streams_channel_example");
        channel.setStreamHandlerFactory(arguments -> new StreamHandler());
    }

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        final StreamsChannel channel = new StreamsChannel(binding.getBinaryMessenger(), "streams_channel_example");
        channel.setStreamHandlerFactory(arguments -> new StreamHandler());
    }

    @Override
    public void onDetachedFromEngine(FlutterPluginBinding binding) {

    }

    // Send "Hello" 10 times, every second, then ends the stream
    public static class StreamHandler implements EventChannel.StreamHandler {

        private final Handler handler = new Handler();
        private final Runnable runnable = new Runnable() {
            @Override
            public void run() {
                if (count > 10) {
                    eventSink.endOfStream();
                } else {
                    eventSink.success("Hello " + count + "/10");
                }
                count++;
                handler.postDelayed(this, 1000);
            }
        };

        private EventChannel.EventSink eventSink;
        private int count = 1;

        @Override
        public void onListen(Object o, final EventChannel.EventSink eventSink) {
            System.out.println("StreamHandler - onListen: " + o);
            this.eventSink = eventSink;
            runnable.run();
        }

        @Override
        public void onCancel(Object o) {
            System.out.println("StreamHandler - onCancel: " + o);
            handler.removeCallbacks(runnable);
        }
    }
}