import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:sensors_plus/sensors_plus.dart';

class StreamBuild extends StatefulWidget {
  const StreamBuild({super.key});

  @override
  State<StreamBuild> createState() => _StreamBuildState();
}

class _StreamBuildState extends State<StreamBuild> {
  late final StreamController<AccelerometerEvent> _streamController;

  @override
  void initState() {
    super.initState();

    _streamController = StreamController<AccelerometerEvent>();
    accelerometerEvents.listen((event) {
      if (!_streamController.isClosed) _streamController.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream Builder Demo'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: _streamController.stream,
        initialData: AccelerometerEvent(0.0, 0.0, 0.0, DateTime.now()),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('No stream connected');
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.active:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                final event = snapshot.data!;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Accelerometer Data:",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(height: 20),
                      Text("X: ${event.x.toStringAsFixed(2)}"),
                      Text("Y: ${event.y.toStringAsFixed(2)}"),
                      Text("Z: ${event.z.toStringAsFixed(2)}"),

                      SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () => closeStream(),

                        child: Text('Close Stream'),
                      ),
                    ],
                  ),
                );
              } else {
                return Text('No Data Exists!');
              }
            case ConnectionState.done:
              return Center(child: Text('Stream Closed!'));
          }
        },
      ),
    );
  }

  void closeStream() {
    _streamController.close();
    setState(() {
      Fluttertoast.showToast(msg: 'Stream Closed Manually');
    });
  }

  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }
}
