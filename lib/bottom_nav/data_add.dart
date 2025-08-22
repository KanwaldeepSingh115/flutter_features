import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/data_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataAdd extends StatefulWidget {
  const DataAdd({super.key});

  @override
  State<DataAdd> createState() => _DataAddState();
}

class _DataAddState extends State<DataAdd> {

  final DatabaseReference db = FirebaseDatabase.instance.ref();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  List<Map<String, dynamic>> allUsers = [];
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
          .child('userData')
          .child(id)
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

  void clearFields() {
    idController.clear();
    nameController.clear();
    emailController.clear();
    ageController.clear();
  }

  Future<void> updateUser(String id) async {
    int? age = int.tryParse(ageController.text);
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        age == null) {
      Fluttertoast.showToast(msg: 'Enter details in fields to update');
      return;
    }

    final snapshot = await db.child('userData').child(id).get();
    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found with this ID');
      return;
    }

    try {
      await db
          .child('userData')
          .child(id)
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Realtime Firebase CRUD'),
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
                  decoration: const InputDecoration(
                    hintText: 'Enter ID (child name under userData)',
                  ),
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
            child:
                allUsers.isEmpty
                    ? const Center(child: Text('No user data found'))
                    : ListView.builder(
                      itemCount: allUsers.length,
                      itemBuilder: (context, index) {
                        final user = allUsers[index];
                        return Card(
                          child: ListTile(
                            title: Text(user['name']),
                            subtitle: Text(
                              '${user['email']} | Age: ${user['age']}',
                            ),
                            leading: CircleAvatar(
                              child: Text(
                                (user['id']?.isNotEmpty ?? false)
                                    ? user['id'][0].toUpperCase()
                                    : '?',
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                  onPressed: () {
                                    idController.text = user['id'];
                                    nameController.text = user['name'];
                                    emailController.text = user['email'];
                                    ageController.text = user['age'].toString();
                                  },
                                ),
                                
                              ],
                            ),
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}