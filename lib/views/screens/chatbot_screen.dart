// New file for AI chatbot using Gemini (placeholder)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/utils/constants.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  Future<void> _sendMessage(String message) async {
    const apiKey = 'YOUR_GEMINI_API_KEY'; // Replace with real API key
    final url = Uri.parse(
      'https://api.gemini.google.com/v1/chat?apiKey=$apiKey',
    ); // Placeholder endpoint

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _messages.add('User: $message');
          _messages.add('AI: ${data['response']}'); // Parse AI response
        });
      }
    } catch (e) {
      setState(() {
        _messages.add('Lỗi: Không thể kết nối AI');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tư Vấn Dinh Dưỡng AI'),
        backgroundColor: primaryColor,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) =>
                  ListTile(title: Text(_messages[index])),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(defaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Hỏi về dinh dưỡng...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final message = _controller.text;
                    if (message.isNotEmpty) {
                      _sendMessage(message);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
