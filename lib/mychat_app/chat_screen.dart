import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_practice/fcm/fcm_send.dart';

class ChatScreen extends StatefulWidget {
  final String receiverId;
  final String receiverEmail;
  const ChatScreen({
    super.key,
    required this.receiverId,
    required this.receiverEmail,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgC = TextEditingController();
  final uid = FirebaseAuth.instance.currentUser!.uid;

  void sendMessage() async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    await FirebaseFirestore.instance.collection("chatMessages").doc(id).set({
      "senderId": uid,
      "receiverId": widget.receiverId,
      "message": msgC.text,
      "messageId": id,
      "timestamp": FieldValue.serverTimestamp(),
    });

    final receiverDoc =
        await FirebaseFirestore.instance
            .collection('myChatUsers')
            .doc(widget.receiverId)
            .get();

    final receiverToken = receiverDoc['fcmToken'];

    if (receiverToken != null && receiverToken.isNotEmpty) {
      await FCMSend().sendPushNotification(
        fcmToken: receiverToken,
        title: "${FirebaseAuth.instance.currentUser!.email}",
        body: msgC.text,
      );
    }
    msgC.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat with ${widget.receiverEmail}")),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance
                      .collection("chatMessages")
                      .orderBy("timestamp")
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snapshot.data!.docs.where(
                  (doc) =>
                      (doc['senderId'] == uid &&
                          doc['receiverId'] == widget.receiverId) ||
                      (doc['senderId'] == widget.receiverId &&
                          doc['receiverId'] == uid),
                );
                return ListView(
                  children:
                      docs
                          .map(
                            (d) => Align(
                              alignment:
                                  d['senderId'] == uid
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.all(4),
                                padding: const EdgeInsets.all(8),
                                color:
                                    d['senderId'] == uid
                                        ? Colors.blue[100]
                                        : Colors.grey[300],
                                child: Text(d['message']),
                              ),
                            ),
                          )
                          .toList(),
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: msgC,
                  decoration: const InputDecoration(hintText: "Message"),
                ),
              ),
              IconButton(onPressed: sendMessage, icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }
}
