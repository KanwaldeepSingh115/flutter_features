import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserListWidget extends StatelessWidget {
  final FirebaseFirestore db;
  final void Function(Map<String, dynamic> data) onEdit;
  final void Function(String id) onDelete;

  const UserListWidget({
    super.key,
    required this.db,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection("users").snapshots(),
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
              child: ListTile(
                title: Text(data['name']),
                subtitle: Text("${data['email']} | Age: ${data['age']}"),
                leading: CircleAvatar(
                  child: Text(
                    (data['name']?.isNotEmpty ?? false)
                        ? data['name'][0].toUpperCase()
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
