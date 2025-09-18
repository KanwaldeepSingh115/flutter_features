//Realtime Database

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/revision/model_dbdata.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PracticeRtDb extends StatefulWidget {
  const PracticeRtDb({super.key});
  @override
  State<PracticeRtDb> createState() => _PracticeRtDbState();
}

class _PracticeRtDbState extends State<PracticeRtDb> {
  final DatabaseReference db = FirebaseDatabase.instance.ref();
  final nameController = TextEditingController();
  final marksController = TextEditingController();
  String userData = '';
  @override
  void initState() {
    super.initState();
    readData();
  }

  Future<void> createData() async {
    int? marks = int.tryParse(marksController.text);
    if (marks != null) {
      var myData = ModelData().setUserData(nameController.text, marks);
      try {
        await db.child('practiceData').child('rtdb').set(myData);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error creating Data');
      }
    }
  }

  Future<void> readData() async {
    try {
      DatabaseEvent event = await db.child('practiceData').child('rtdb').once();
      if (event.snapshot.exists) {
        Map data = event.snapshot.value as Map;
        String name = data['name'] ?? '';
        int marks = data['marks'] ?? 0;
        setState(() {
          userData = 'Name: $name \n Marks: $marks';
        });
      } else {
        setState(() {
          userData = 'Data not Found';
        });
      }
    } catch (e) {
      throw Exception('Error reading Data');
    }
  }

  Future<void> updateData() async {
    int? marks = int.tryParse(marksController.text);
    if (marks != null) {
      var myData = ModelData().setUserData(nameController.text, marks);
      try {
        await db.child('practiceData').child('rtdb').update(myData);
      } catch (e) {
        Fluttertoast.showToast(msg: 'Error updating Data');
      }
    }
  }

  Future<void> deleteData() async {
    try {
      await db.child('practiceData').child('rtdb').remove();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error deleting Data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Practice RtDb')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: nameController,
          ),
          SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(border: OutlineInputBorder()),
            controller: marksController,
          ),
          SizedBox(height: 20),
          Wrap(
            children: [
              ElevatedButton(onPressed: createData, child: Text('Create')),
              ElevatedButton(onPressed: readData, child: Text('Read')),
              ElevatedButton(onPressed: updateData, child: Text('Update')),
              ElevatedButton(onPressed: deleteData, child: Text('Delete')),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: db.child('practiceData').child('rtdb').once(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData ||
                    !snapshot.data!.snapshot.exists) {
                  return const Center(child: Text('No data exists!'));
                } else {
                  final userData = snapshot.data!.snapshot.value as Map;
                  final name = userData['name'] ?? '';
                  final marks = userData['marks'] ?? '';
                  return Card(
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(marks.toString()),
                      leading: CircleAvatar(
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

//Cloud Firestore

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_practice/revision/model_data.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class PracticeFbFs extends StatefulWidget {
//   const PracticeFbFs({super.key});

//   @override
//   State<PracticeFbFs> createState() => _PracticeFbFsState();
// }

// class _PracticeFbFsState extends State<PracticeFbFs> {
//   final db = FirebaseFirestore.instance;
//   final nameController = TextEditingController();
//   final marksController = TextEditingController();

//   String myData = '';
//   String? selectedDocId = '';

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<void> createData() async {
//     int? marks = int.tryParse(marksController.text);

//     if (nameController.text.isEmpty || marks == null) {
//       Fluttertoast.showToast(msg: 'Please enter valid data');
//     }

//     if (marks != null) {
//       final userData = ModelData().setUserData(nameController.text, marks);

//       try {
//         await db.collection('practiceFbFs').doc().set(userData);
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Error Adding Data');
//       }
//     }
//   }

//   Future<void> updateData(String id) async {
//     int? marks = int.tryParse(marksController.text);

//     if (nameController.text.isEmpty || marks == null) {
//       Fluttertoast.showToast(msg: 'Please enter valid data');
//     }

//     if (marks != null) {
//       final userData = ModelData().setUserData(nameController.text, marks);
//       try {
//         await db.collection('practiceFbFs').doc(id).update(userData);
//       } catch (e) {
//         Fluttertoast.showToast(msg: 'Error updating Data');
//       }
//     }
//   }

//   Future<void> deleteData(String id) async {
//     await db.collection('practiceFbFs').doc(id).delete();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Practice Firebase Firestore')),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           TextField(
//             controller: nameController,
//             decoration: InputDecoration(border: OutlineInputBorder()),
//           ),
//           SizedBox(height: 20),
//           TextField(
//             controller: marksController,
//             decoration: InputDecoration(border: OutlineInputBorder()),
//           ),
//           SizedBox(height: 20),
//           Expanded(
//             child: StreamBuilder(
//               stream: db.collection('practiceFbFs').snapshots(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error Reading Data'));
//                 } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                   return Center(child: Text('Data does not exists'));
//                 } else {
//                   final docs = snapshot.data!.docs;
//                   return ListView.builder(
//                     itemCount: docs.length,
//                     itemBuilder: (context, index) {
//                       final doc = docs[index];
//                       final data = doc.data();
//                       final name = data['name'] ?? 'N/A';
//                       final marks = data['marks'].toString() ?? '0';
//                       return Card(
//                         child: ListTile(
//                           title: Text(name),
//                           subtitle: Text(marks),
//                           leading: CircleAvatar(
//                             child: Text(
//                               name.isNotEmpty ? name[0].toUpperCase() : '?',
//                             ),
//                           ),
//                           onTap:
//                               () => setState(() {
//                                 nameController.text = name;
//                                 marksController.text = marks;
//                                 selectedDocId = doc.id;
//                               }),
//                           trailing: Row(
//                             mainAxisAlignment: MainAxisAlignment.end,
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               IconButton(
//                                 onPressed: () => updateData(doc.id),
//                                 icon: Icon(Icons.edit),
//                               ),
//                               IconButton(
//                                 onPressed: () => deleteData(doc.id),
//                                 icon: Icon(Icons.delete),
//                               ),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: createData,
//         child: Icon(Icons.add),
//         backgroundColor: Colors.purpleAccent,
//       ),
//     );
//   }
// }
