import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';


Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
/// Initialize the background service
Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'my_foreground', // must exist in Android
      initialNotificationTitle: 'My Service',
      initialNotificationContent: 'Service is running',
      foregroundServiceNotificationId: 888, // unique int id
    ),
    iosConfiguration: IosConfiguration(),
  );
}


@pragma('vm:entry-point')
void onStart(ServiceInstance service) {
  if (service is AndroidServiceInstance) {
    // Make service foreground immediately
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "My Foreground Service",
      content: "Doing background work...",
    );
  }

  // Example: Periodic Task
  Timer.periodic(const Duration(seconds: 5), (timer) async {
    final now = DateTime.now().toIso8601String();
    debugPrint("Service is running at $now");

    // Update notification content dynamically
    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "My Foreground Service",
        content: "Last update: $now",
      );
    }
  });

  // Stop service when called
  service.on("stopService").listen((event) {
    service.stopSelf();
  });
}



class ForegroundServiceDemo extends StatefulWidget {
  const ForegroundServiceDemo({super.key});

  @override
  State<ForegroundServiceDemo> createState() => _ForegroundServiceDemoState();
}

class _ForegroundServiceDemoState extends State<ForegroundServiceDemo> {
  
  @override
  void initState() {
    super.initState();
    requestNotificationPermission();
    initializeService();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Foreground Service Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("stopService");
              },
              child: const Text("Stop Service"),
            ),
          ],
        ),
      ),
    );
  }
}
