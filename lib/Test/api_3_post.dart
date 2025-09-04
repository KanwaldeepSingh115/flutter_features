import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice/Test/api_3_otp.dart';
import 'package:http/http.dart' as http;

class Api3Post extends StatefulWidget {
  const Api3Post({super.key});

  @override
  State<Api3Post> createState() => _Api3PostState();
}

class _Api3PostState extends State<Api3Post> {
  final emailController = TextEditingController();
  final jobController = TextEditingController();

  String responseData = '';

  Future<void> createPost() async {
    var url = Uri.parse('https://reqres.in/api/users');

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": "reqres-free-v1",
      },
      body: jsonEncode({
        "name": emailController.text.toString(),
        "job": jobController.text.toString(),
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        responseData = response.body;
      });
    }

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Api3Otp(response: responseData),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Api Test 3'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Email',
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: jobController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Enter Job',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: createPost, child: Text('Submit')),
            ],
          ),
        ),
      ),
    );
  }
}
