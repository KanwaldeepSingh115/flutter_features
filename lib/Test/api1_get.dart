import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_practice/Test/api1_getModel.dart';
import 'package:flutter_practice/Test/api1_otp.dart';
import 'package:flutter_practice/Test/api2_get.dart';
import 'package:flutter_practice/Test/api_3_post.dart';
import 'package:http/http.dart' as http;

class Api1Get extends StatefulWidget {
  const Api1Get({super.key});

  @override
  State<Api1Get> createState() => _Api1GetState();
}

class _Api1GetState extends State<Api1Get> {
  late Future<DemoApimodel1> futurePosts;

  Future<DemoApimodel1> fetchPosts() async {
    final response = await http.get(
      Uri.parse('https://reqres.in/api/users?page=2'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      return DemoApimodel1.fromJson(json);
    } else {
      throw Exception('Failed to load Posts');
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
      appBar: AppBar(
        title: Text('Api 1 Test'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.looks_two),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Api2Get()),
              );
            },
            tooltip: 'Go To Api2 Get',
          ),
          IconButton(
            icon: Icon(Icons.looks_3),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Api3Post()),
              );
            },
            tooltip: 'Go To Api3 Post',
          ),
        ],
      ),
      body: FutureBuilder(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data exists!'));
          } else {
            final users = snapshot.data!.dataModel;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.avatar),
                    ),
                    title: Text(
                      'First Name: ${user.first_name} \nLast Name: ${user.last_name}',
                    ),
                    subtitle: Text('Email" ${user.email}'),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => Api1Otp(
                                id: user.id,
                                first_name: user.first_name,
                                last_name: user.last_name,
                                email: user.email,
                                avatar: user.avatar,
                              ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
