import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/models/data_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataRetrieve extends StatefulWidget {
  const DataRetrieve({super.key});

  @override
  State<DataRetrieve> createState() => _DataRetrieveState();
}

class _DataRetrieveState extends State<DataRetrieve> {
  final DatabaseReference db = FirebaseDatabase.instance.ref();

  final idController = TextEditingController();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final ageController = TextEditingController();

  List<Map<String, dynamic>> allUsers = [];
  final model = DataModel();

  @override
  void initState() {
    super.initState();
    listenUserData();
  }

  void listenUserData() {
    db.child('userData').onValue.listen((event) {
      setState(() {
        if (event.snapshot.exists) {
          final data = event.snapshot.value as Map;
          allUsers =
              data.values.map((e) {
                return model.setUserInfo(
                  e['id'] ?? '',
                  e['name'] ?? '',
                  e['email'] ?? '',
                  e['age'] ?? 0,
                );
              }).toList();
        } else {
          allUsers = [];
        }
      });
    });
  }

  Future<void> deleteUser(String id) async {
    final snapshot = await db.child('userData').child(id).get();
    if (!snapshot.exists) {
      Fluttertoast.showToast(msg: 'No record found to delete');
      return;
    }

    try {
      await db.child('userData').child(id).remove();
      Fluttertoast.showToast(msg: 'Data deleted successfully');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Failed to delete data: $e');
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
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => deleteUser(user['id']),
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
