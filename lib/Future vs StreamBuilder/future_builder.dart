import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';

class FutureBuilderExample extends StatefulWidget {
  @override
  _FutureBuilderExampleState createState() => _FutureBuilderExampleState();
}

class _FutureBuilderExampleState extends State<FutureBuilderExample> {
  late Future<List<User>> _futureUsers;

  @override
  void initState() {
    super.initState();
    _futureUsers = fetchUsers();
  }

  // Function to fetch users from ReqRes API
  Future<List<User>> fetchUsers() async {
    final response = await http.get(
      Uri.parse("https://reqres.in/api/users?page=1"),
    );

    await Future.delayed(Duration(seconds: 2)); // simulate delay

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List users = data["data"];
      return users.map((json) => User.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load users");
    }
  }

  void _retryFetch() {
    setState(() {
      _futureUsers = fetchUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("FutureBuilder",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<User>>(
        future: _futureUsers,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Center(child: Text("No request made yet"));
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            case ConnectionState.active:
              return Center(child: Text("Fetching data..."));
            case ConnectionState.done:
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Error: ${snapshot.error}"),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: _retryFetch,
                        child: Text("Retry"),
                      ),
                    ],
                  ),
                );
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No users found"));
              } else {
                final users = snapshot.data!;
                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(user.avatar),
                      ),
                      title: Text("${user.firstName} ${user.lastName}"),
                      subtitle: Text(user.email),
                    );
                  },
                );
              }
          }
        },
      ),
    );
  }
}
