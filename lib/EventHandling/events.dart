import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_practice/EventHandling/screenonoff_service.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> with WidgetsBindingObserver {
  final Battery _battery = Battery();
  final Connectivity _connectivity = Connectivity();
  DateTime? lastScreenOffTime;

  String batteryStatus = 'Battery Status Unknown';
  String networkStatus = 'Network Status Unknown';
  String lifecycleStatus = 'Lifecycle Status Unknown';
  String bluetoothStatus = 'Bluetooth Status Unknown';
  String sensorStatus = 'Sensor Status Unknown';
  String keyboardStatus = 'Keyboard Status Unknown';
  String batteryLevelStatus = 'Battery Level Unknown';
  String screenStatus = 'Screen Status Unknown';
  String internetStatus = 'Interenet Status Unknown';

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    listenBattery();
    listenConnectivity();
    listenBluetooth();
    listenSensors();
    listenInternet();

    ScreenStateService.listen((state) {
      setState(() {
        if (state == "OFF") {
          lastScreenOffTime = DateTime.now();
          screenStatus = "Screen: OFF";
        } else if (state == "ON") {
          if (lastScreenOffTime != null) {
            final diff = DateTime.now().difference(lastScreenOffTime!);
            final minutes = diff.inMinutes;
            final seconds = diff.inSeconds % 60;
            screenStatus = "Screen: ON (was OFF for ${minutes}m ${seconds}s)";
          } else {
            screenStatus = "Screen: ON";
          }
        }
      });
    });
  }

  void listenInternet() {
    InternetConnection().onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        setState(() {
          internetStatus = "Internet Status: Connected";
        });
      } else {
        setState(() {
          internetStatus = "Internet Status: Disconnected";
        });
      }
    });
  }

  void listenBattery() {
    _battery.onBatteryStateChanged.listen((BatteryState state) async {
      final level = await _battery.batteryLevel;
      final saverMode = await _battery.isInBatterySaveMode;

      setState(() {
        batteryStatus = "Battery state: $state (SaverMode: $saverMode)";
        batteryLevelStatus = "Battery level: $level%";
      });
    });
  }

  void listenConnectivity() {
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      if (results.contains(ConnectivityResult.mobile)) {
        setState(() => networkStatus = "Connectivity: Mobile Data");
      } else if (results.contains(ConnectivityResult.wifi)) {
        setState(() => networkStatus = "Connectivity: WiFi");
      } else {
        setState(() => networkStatus = "Connectivity: None");
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      lifecycleStatus = 'Lifecycle Status: $state';
    });
  }

  void listenBluetooth() {
    FlutterBluePlus.adapterState.listen((state) {
      setState(() {
        bluetoothStatus = "Bluetooth: $state";
      });
    });
  }

  void listenSensors() {
    accelerometerEvents.listen((event) {
      setState(() {
        sensorStatus =
            "Accelerometer: x=${event.x}, y=${event.y}, z=${event.z}";
      });
    });

    gyroscopeEvents.listen((event) {
      //debugPrint("Gyroscope: x=${event.x}, y=${event.y}, z=${event.z}");
    });
  }

  void checkKeyboard(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = viewInsets > 0;

    setState(() {
      keyboardStatus = isKeyboardOpen ? "Keyboard: Open" : "Keyboard: Closed";
    });
  }

  @override
  Widget build(BuildContext context) {
    checkKeyboard(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('System Event Handling'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(batteryStatus),
          Text(batteryLevelStatus),
          Text(networkStatus),
          Text(lifecycleStatus),
          Text(bluetoothStatus),
          Text(sensorStatus),
          Text(keyboardStatus),
          Text(internetStatus),
          Text(screenStatus),
        ],
      ),
    );
  }
}
