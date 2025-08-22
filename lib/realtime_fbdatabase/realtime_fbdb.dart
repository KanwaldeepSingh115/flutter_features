import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/data_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RealtimeFbdb extends StatefulWidget {
  const RealtimeFbdb({super.key});

  @override
  State<RealtimeFbdb> createState() => _RealtimeFbdbState();
}

class _RealtimeFbdbState extends State<RealtimeFbdb> {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  String userData = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RealTime Firebase Database'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter your name'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(hintText: 'Enter your email'),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: ageController,
                decoration: InputDecoration(hintText: 'Enter your age'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: addUserData, child: Text('Submit')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: updateUserData, child: Text('Update')),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: removeUserData, child: Text('Delete')),
              const SizedBox(height: 20),
              Text(userData),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: readUserData,
        backgroundColor: Colors.blue,
        child: Icon(Icons.refresh),
      ),
    );
  }

  Future<void> addUserData() async {
    int? age = int.tryParse(ageController.text);
    if (age != null) {
      var userData = DataModel().setUserInfo(
        'public',
        nameController.text,
        emailController.text,
        age,
      );

      try {
        await db.child('userData').child('public').set(userData);
        Fluttertoast.showToast(msg: 'Data added successfully');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to add data: $e');
      }
    }
  }

  Future<void> readUserData() async {
    try {
      DatabaseEvent event = await db.child('userData').child('public').once();

      if (event.snapshot.exists) {
        Map data = event.snapshot.value as Map;
        String name = data['name'] ?? 'N/A';
        String email = data['email'] ?? 'N/A';
        int age = data['age'] ?? 0;

        setState(() {
          userData = 'Name: $name,\nEmail: $email, \nAge: $age';
        });
      } else {
        setState(() {
          userData = 'User Data Not Found';
        });
      }
    } catch (e) {
      setState(() {
        userData = 'Error reading data : $e';
      });
    }
  }

  Future<void> updateUserData() async {
    int? age = int.tryParse(ageController.text);
    if (age != null) {
      var userData = DataModel().setUserInfo(
        'public',
        nameController.text,
        emailController.text,
        age,
      );

      try {
        await db.child('userData').child('public').update(userData);
        Fluttertoast.showToast(msg: 'Data updated successfully');
      } catch (e) {
        Fluttertoast.showToast(msg: 'Failed to update data : $e');
      }
    }
  }

  Future<void> removeUserData() async {
    try {
      await db.child('userData').child('public').remove();
      Fluttertoast.showToast(msg: 'Data deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete data: $e');
    }
  }
}
