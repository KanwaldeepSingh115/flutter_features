import 'dart:convert';

import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'PASTE_YOUR_API_KEY_HERE';
  final String baseUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent";

  Future<String> generateText(String prompt) async {
    final response = await http.post(
      Uri.parse("$baseUrl"),
      headers: {
        "Content-Type": "application/json",
        "X-goog-api-key": apiKey
      },
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": prompt}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["candidates"][0]["content"]["parts"][0]["text"];
    } else {
      throw Exception("Failed to generate text: ${response.body}");
    }
  }
}


