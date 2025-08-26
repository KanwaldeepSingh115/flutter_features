import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/listview/mylist.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_practice/models/data_model.dart';

class MyFirestoreCrud extends StatefulWidget {
  const MyFirestoreCrud({super.key});

  @override
  State<MyFirestoreCrud> createState() => _MyFirestoreCrudState();
}

class _MyFirestoreCrudState extends State<MyFirestoreCrud> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  final model = DataModel();

  Future<void> addUserData() async {
    int? age = int.tryParse(ageController.text);
    String id = idController.text.trim();

    if (id.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        age == null) {
      Fluttertoast.showToast(msg: 'Please enter valid data');
      return;
    }

    try {
      await db
          .collection("users")
          .doc(id)
          .set(
            model.setUserInfo(
              id,
              nameController.text.trim(),
              emailController.text.trim(),
              age,
            ),
          );
      Fluttertoast.showToast(msg: 'Data added successfully');
      clearFields();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to add data: $e');
    }
  }

  Future<void> updateUser(String id) async {
    int? age = int.tryParse(ageController.text);
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        age == null) {
      Fluttertoast.showToast(msg: 'Enter details in fields to update');
      return;
    }

    final snapshot = await db.collection("users").doc(id).get();
    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found with this ID');
      return;
    }

    try {
      await db
          .collection("users")
          .doc(id)
          .update(
            model.setUserInfo(
              id,
              nameController.text.trim(),
              emailController.text.trim(),
              age,
            ),
          );
      Fluttertoast.showToast(msg: 'Data updated successfully');
      clearFields();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to update data: $e');
    }
  }

  Future<void> deleteUser(String id) async {
    final snapshot = await db.collection("users").doc(id).get();
    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found to delete');
      return;
    }

    try {
      await db.collection("users").doc(id).delete();
      Fluttertoast.showToast(msg: 'Data deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete data: $e');
    }
  }

  void clearFields() {
    idController.clear();
    nameController.clear();
    emailController.clear();
    ageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firestore CRUD'),
        backgroundColor: Colors.deepPurple,
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
                  controller: nameController,
                  decoration: const InputDecoration(hintText: 'Enter name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(hintText: 'Enter email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ageController,
                  decoration: const InputDecoration(hintText: 'Enter age'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: addUserData,
                        child: const Text('Add'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (idController.text.isNotEmpty) {
                            updateUser(idController.text.trim());
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Enter the ID to update',
                            );
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: UserListWidget(
              db: db,
              onEdit: (data) {
                idController.text = data['id'];
                nameController.text = data['name'];
                emailController.text = data['email'];
                ageController.text = data['age'].toString();
              },
              onDelete: (id) => deleteUser(id),
            ),
          ),
        ],
      ),
    );
  }
}
