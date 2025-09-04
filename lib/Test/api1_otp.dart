import 'package:flutter/material.dart';

class Api1Otp extends StatefulWidget {
  final int id;
  final String avatar;
  final String first_name;
  final String last_name;
  final String email;
  const Api1Otp({
    super.key,
    required this.id,
    required this.first_name,
    required this.last_name,
    required this.email,
    required this.avatar,
  });

  @override
  State<Api1Otp> createState() => _Api1OtpState();
}

class _Api1OtpState extends State<Api1Otp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api 1 Test'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.avatar),
              ),
              const SizedBox(height: 20),
              Text(
                'First Name: ${widget.first_name} \nLast Name: ${widget.last_name}',

                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Email: ${widget.email}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
