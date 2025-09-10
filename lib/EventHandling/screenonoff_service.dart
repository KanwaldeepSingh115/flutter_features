import 'package:flutter/services.dart';

class ScreenStateService {
  static const _eventChannel = EventChannel("screen_state_event_channel");

  static void listen(Function(String state) onEvent) {
    _eventChannel.receiveBroadcastStream().listen((event) {
      if (event is String) {
        onEvent(event);
      }
    });
  }
}
