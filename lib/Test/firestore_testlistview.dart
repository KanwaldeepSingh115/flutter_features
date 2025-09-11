import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TestListWidget extends StatelessWidget {
  final FirebaseFirestore db;
  final void Function(Map<String, dynamic> data) onEdit;
  final void Function(String id) onDelete;

  const TestListWidget({
    super.key,
    required this.db,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection("testData").snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Error fetching user data"));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = snapshot.data!.docs;

        if (users.isEmpty) {
          return const Center(child: Text("No user data found"));
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final data = users[index].data() as Map<String, dynamic>;
            return Card(
              elevation: 4,
              child: ListTile(
                title: Text(data['title']),
                subtitle: Text("${data['description']}\n${data['createdAt']}"),
                leading: CircleAvatar(
                  child: Text(
                    (data['title']?.isNotEmpty ?? false)
                        ? data['title'][0].toUpperCase()
                        : '?',
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.green),
                      onPressed: () => onEdit(data),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => onDelete(data['id']),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
