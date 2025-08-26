import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice/API/get.dart';
import 'package:http/http.dart' as http;

class ReqResPostDemo extends StatefulWidget {
  const ReqResPostDemo({super.key});

  @override
  State<ReqResPostDemo> createState() => _ReqResPostDemoState();
}

class _ReqResPostDemoState extends State<ReqResPostDemo> {
  String responseData = '';

  Future<void> createUserData() async {
    var url = Uri.parse('https://reqres.in/api/login');

    print(url.toString());

    var response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "x-api-key": "reqres-free-v1",
      },
      body: jsonEncode({
        "email": "eve.holt@reqres.in",
        "password": "cityslicka",
      }),
    );

    setState(() {
      responseData = response.body;
    });

    print("Status: ${response.statusCode}");
    print("Body: ${response.body}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ReqResPost Api Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: createUserData, child: Text('Post Data')),
            SizedBox(height: 20),
            Text(responseData),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ReqResGetDemo()),
                  ),
              child: Text('Get All Posts'),
            ),
          ],
        ),
      ),
    );
  }
}
