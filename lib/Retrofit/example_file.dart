import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_practice/Retrofit/output_screen.dart';
import 'api_service.dart';
import 'user.dart';

class RetrofitExample extends StatefulWidget {
  const RetrofitExample({super.key});

  @override
  State<RetrofitExample> createState() => _RetrofitExampleState();
}

class _RetrofitExampleState extends State<RetrofitExample> {
  late Future<DemoApiModel> futureUsers;
  final ApiService apiService = ApiService(Dio()
    ..interceptors.add(LogInterceptor(requestBody: true, responseBody: true)));

  @override
  void initState() {
    super.initState();
    futureUsers = apiService.getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Retrofit - ReqRes Users'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DemoApiModel>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data exists!'));
          } else {
            final users = snapshot.data!.data;

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];

                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
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
                      'First Name: ${user.firstName}\nLast Name: ${user.lastName}',
                    ),
                    subtitle: Text('Email: ${user.email}'),
                    trailing: const Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.grey),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserDetailScreen(user: user),
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