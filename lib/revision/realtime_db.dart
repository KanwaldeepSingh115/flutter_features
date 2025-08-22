import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RealtimeDb extends StatefulWidget {
  const RealtimeDb({super.key});

  @override
  State<RealtimeDb> createState() => _RealtimeDbState();
}

class _RealtimeDbState extends State<RealtimeDb> {
  var db = FirebaseFirestore.instance;

  final name = TextEditingController();
  final email = TextEditingController();
  final ageController = TextEditingController();

  Future<void> addUserData() async {
    int? age = int.tryParse(ageController.text);
    await db.collection('practiceUsers').doc('myDoc1').set({
      'name': name.text,
      'email': email.text,
      'age': age,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice Firestore / Database'),
        backgroundColor: Colors.tealAccent,
      ),
      body: Column(
        children: [
          TextField(controller: name),
          SizedBox(height: 10),
          TextField(controller: email),
          SizedBox(height: 10),
          TextField(controller: ageController),
          SizedBox(height: 10),
          ElevatedButton(onPressed: addUserData, child: Text('Add')),
        ],
      ),
    );
  }
}
