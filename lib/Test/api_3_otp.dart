import 'package:flutter/material.dart';

class Api3Otp extends StatefulWidget {
  final String response;
  const Api3Otp({super.key, required this.response});

  @override
  State<Api3Otp> createState() => _Api3OtpState();
}

class _Api3OtpState extends State<Api3Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api 3 Output'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(child: Text(widget.response)),
    );
  }
}
