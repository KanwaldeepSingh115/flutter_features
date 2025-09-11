import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/Test/firestore_testlistview.dart';
import 'package:flutter_practice/Test/firestore_testmodel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class FirestoreTest extends StatefulWidget {
  const FirestoreTest({super.key});

  @override
  State<FirestoreTest> createState() => _FirestoreTestState();
}

class _FirestoreTestState extends State<FirestoreTest> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final titleController = TextEditingController();
  final descpController = TextEditingController();
  final idController = TextEditingController();

  final model = FirestoreTestModel();

  //Referenced From intl.dart package
  String today(DateTime date) => Intl.message(
    "Today's date is $date",
    name: 'today',
    args: [date],
    desc: 'Indicate the current date',
    examples: const {'date': 'June 8, 2012'},
  );

  @override
  void dispose() {
    idController.dispose();
    titleController.dispose();
    descpController.dispose();
    super.dispose();
  }

  void clearFields() {
    idController.clear();
    titleController.clear();
    descpController.clear();
  }

  Future<void> addData() async {
    String id = idController.text.trim();
    if (idController.text.isEmpty ||
        titleController.text.isEmpty ||
        descpController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter valid data');
      return;
    }

    final data = model.setUserData(
      idController.text.trim(),
      titleController.text.trim(),
      descpController.text.trim(),
    );

    try {
      await db.collection('testData').doc(id).set(data);
      Fluttertoast.showToast(msg: 'Data Added Successfully');
      clearFields();
    } catch (e) {
      print('Error Adding Data: $e');
    }
  }

  Future<void> updateData(String id) async {
    if (idController.text.isEmpty ||
        titleController.text.isEmpty ||
        descpController.text.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter valid data');
      return;
    }

    final snapshot = await db.collection('testData').doc(id).get();

    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found');
      return;
    }

    final data = model.setUserData(
      idController.text.trim(),
      titleController.text.trim(),
      descpController.text.trim(),
    );

    try {
      await db.collection('testData').doc(id).update(data);
      Fluttertoast.showToast(msg: 'Data Updated Successfully');
      clearFields();
    } catch (e) {
      print('Error Updating Data: $e');
    }
  }

  Future<void> deleteData(String id) async {
    final snapshot = await db.collection('testData').doc(id).get();

    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found');
      return;
    }

    try {
      await db.collection('testData').doc(id).delete();
      Fluttertoast.showToast(msg: 'Data Deleted Successfully');
      clearFields();
    } catch (e) {
      print('Error Deleting Data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firestore Test'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: idController,
                  decoration: const InputDecoration(hintText: 'Enter docId'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(hintText: 'Enter title'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: descpController,
                  decoration: const InputDecoration(
                    hintText: 'Enter description',
                  ),
                ),

                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (idController.text.isNotEmpty) {
                            updateData(idController.text.trim());
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Enter the ID to update',
                            );
                          }
                        },
                        child: const Text(
                          'Update',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          SizedBox(height: 10),
          Expanded(
            child: TestListWidget(
              db: db,
              onEdit: (data) {
                idController.text = data['id'];
                titleController.text = data['title'];
                descpController.text = data['description'];
              },
              onDelete: (id) => deleteData(id),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addData,
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
    );
  }
}
