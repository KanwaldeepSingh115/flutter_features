import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudData extends StatefulWidget {
  const CrudData({super.key});

  @override
  State<CrudData> createState() => _CrudDataState();
}

class _CrudDataState extends State<CrudData> {
  final CollectionReference myUsers = FirebaseFirestore.instance.collection(
    'ModifiedUsers',
  );

  final nameController = TextEditingController();
  final postController = TextEditingController();
  final ratingController = TextEditingController();
  final statusController = TextEditingController();
  final expController = TextEditingController();

  // Future<void> addData() async {
  //   if (nameController.text.isNotEmpty || postController.text.isNotEmpty) {
  //     await myData.add({
  //       'name': nameController.text.trim(),
  //       'post': postController.text.trim(),
  //     });
  //   }
  //   showSnack('Data Added');
  // }

  void addUser() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Add User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Enter Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: postController,
                  decoration: InputDecoration(labelText: 'Enter Post'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ratingController,
                  decoration: InputDecoration(labelText: 'Enter Rating'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Enter Status'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: expController,
                  decoration: InputDecoration(labelText: 'Enter Experience'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty ||
                      postController.text.isNotEmpty ||
                      ratingController.text.isNotEmpty ||
                      statusController.text.isNotEmpty ||
                      expController.text.isNotEmpty) {
                    await myUsers.add({
                      'name': nameController.text.trim(),
                      'post': postController.text.trim(),
                      'rating': ratingController.text.trim(),
                      'status': statusController.text.trim(),
                      'experience': expController.text.trim(),
                    });
                    showSnack('User Added');
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
    );
  }

  void editUser(
    String docId,
    String currentName,
    String currentPost,
    String currentRating,
    String currrentStatus,
    String currentExp,
  ) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text('Update User'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(labelText: 'Edit Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: postController,
                  decoration: InputDecoration(labelText: 'Edit Post'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: ratingController,
                  decoration: InputDecoration(labelText: 'Edit Rating'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(labelText: 'Edit Status'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: expController,
                  decoration: InputDecoration(labelText: 'Edit Experience'),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.cancel),
                tooltip: 'Cancel',
              ),
              ElevatedButton(
                onPressed: () async {
                  await myUsers.doc(docId).update({
                    'name': nameController.text.trim(),
                    'post': postController.text.trim(),
                    'rating': ratingController.text.trim(),
                    'status': statusController.text.trim(),
                    'experience': expController.text.trim(),
                  });
                  showSnack('User Updated');
                  Navigator.of(context).pop();
                },
                child: Text('Update'),
              ),
            ],
          ),
    );
  }

  // Future<void> readData() async {
  //   final querySnapshot =
  //       await myUsers
  //           .where('name', isEqualTo: nameController.text.trim())
  //           .get();

  //   if (querySnapshot.docs.isNotEmpty) {
  //     final doc = querySnapshot.docs[0];
  //     final data = doc.data() as Map<String, dynamic>;

  //     setState(() {
  //       readName = data['name'];
  //       readPost = data['post'];
  //       currentId = doc.id;
  //     });
  //     showSnack('Data Found!');
  //   } else {
  //     readName = null;
  //     readPost = null;
  //     currentId = null;
  //     showSnack('No Data Found!');
  //   }
  // }

  // Future<void> updateData() async {
  //   if (currentId == null) {
  //     showSnack('Read data to update');
  //     return;
  //   }
  //   await myUsers.doc(currentId).update({'post': postController.text.trim()});
  //   showSnack('Data updated');
  // }

  // Future<void> deleteData() async {
  //   if (currentId == null) {
  //     showSnack('Read data to delete');
  //     return;
  //   }
  //   await myUsers.doc(currentId).delete();
  //   showSnack('Data deleted');
  //   setState(() {
  //     readName = null;
  //     readPost = null;
  //   });
  // }

  void showSnack(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Firebase Firestore'),
        backgroundColor: Colors.teal,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: StreamBuilder<QuerySnapshot>(
          stream: myUsers.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No users found'));
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final doc = snapshot.data!.docs[index];
                final data = doc.data() as Map<String, dynamic>;

                final name = data['name'] ?? '';
                final post = data['post'] ?? '';
                final rating = data['rating'] ?? '';
                final status = data['status'] ?? '';
                final exp = data['experience'] ?? '';

                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal, width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name : $name', style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 16),
                          Text('Post: $post', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 14),
                          Text(
                            'Rating: $rating',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Status: $status',
                            style: TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Experience: $exp',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed:
                                () => editUser(
                                  doc.id,
                                  name,
                                  post,
                                  rating,
                                  status,
                                  exp,
                                ),
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () async {
                              await myUsers.doc(doc.id).delete();
                              showSnack('Deleted $name');
                            },
                            icon: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        backgroundColor: Colors.deepPurpleAccent,
        tooltip: 'Add Item',
        child: Icon(Icons.add, color: Colors.black),
      ),
    );
  }
}
