import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMsg {
  final msgService = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    try {
      NotificationSettings settings = await msgService.requestPermission();

      print("Permission granted: ${settings.authorizationStatus}");

      String? token = await msgService.getToken();
      if (token == null) {
        print("❌ FCM token is null");
      } else {
        print("✅ FCM Token: $token");
      }

      FirebaseMessaging.onBackgroundMessage(handleNotification);
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print(
          "📩 Message received in foreground: ${message.notification?.title}",
        );
      });
    } catch (e) {
      print("❌ Error in FCM init: $e");
    }
  }
}

Future<void> handleNotification(RemoteMessage msg) async {}
