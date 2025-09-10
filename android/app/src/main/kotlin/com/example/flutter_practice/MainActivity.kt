package com.example.flutter_practice

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "screen_state_event_channel"

    companion object {
        var eventSink: EventChannel.EventSink? = null
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    EventChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        .setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                eventSink = events

                // Send initial state right away
                val pm = getSystemService(POWER_SERVICE) as android.os.PowerManager
                if (pm.isInteractive) {
                    eventSink?.success("ON")
                } else {
                    eventSink?.success("OFF")
                }
            }

            override fun onCancel(arguments: Any?) {
                eventSink = null
            }
        })

    startScreenService()
}


    private fun startScreenService() {
        val intent = Intent(this, ScreenService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }
}
