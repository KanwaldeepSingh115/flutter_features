import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_practice/Chatbot-Gemini/gemini_service.dart';
import 'package:lottie/lottie.dart';

class Chatbot extends StatefulWidget {
  const Chatbot({super.key});

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  final senderKey = 'sender';
  final receiverKey = 'receiver';
  final List<Map<String, dynamic>> messages = [];
  final chatController = TextEditingController();
  final geminiService = GeminiService();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gemini Chatbot Api'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                final isMe = message['sender'] == senderKey;

                return Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.teal[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: MarkdownBody(
                      data: message['text']!,
                      styleSheet: MarkdownStyleSheet.fromTheme(
                        Theme.of(context),
                      ).copyWith(p: const TextStyle(fontSize: 16)),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            Align(
              alignment: Alignment.centerLeft,
              child: Lottie.asset(
                "assets/loader.json",
                height: 120,
                width: 120,
              ),
            ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: chatController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    if (chatController.text.isEmpty) return;

    setState(() {
      messages.add({'sender': senderKey, 'text': chatController.text.trim()});
      _isLoading = true;
    });

    _generateResponse(chatController.text.trim());

    chatController.clear();
  }

  Future<void> _generateResponse(String text) async {
    final result = await geminiService.generateText(text);

    setState(() {
      _isLoading = false;
      messages.add({'sender': receiverKey, 'text': result});
    });
  }
}
