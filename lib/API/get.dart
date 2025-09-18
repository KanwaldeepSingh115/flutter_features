import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice/API/get_model.dart';
import 'package:http/http.dart' as http;

class ReqResGetDemo extends StatefulWidget {
  const ReqResGetDemo({super.key});

  @override
  State<ReqResGetDemo> createState() => _ReqResGetDemoState();
}

class _ReqResGetDemoState extends State<ReqResGetDemo> {
  late Future<DemoApiModel2> futurePosts;

  Future<DemoApiModel2> fetchPosts() async {
    final response = await http.get(Uri.parse('https://reqres.in/api/users/2'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return DemoApiModel2.fromJson(json);
    } else {
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ReqResGet Api Example')),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data exists!'));
          } else {
            final user = snapshot.data!.mydata;
            final support = snapshot.data!.support;

            return Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Name: ${user.first_name} ${user.last_name}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Email: ${user.email}',
                      style: const TextStyle(fontSize: 16, color: Colors.green),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Support: ${support.text}',
                      style: TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Visit: ${support.url}',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
