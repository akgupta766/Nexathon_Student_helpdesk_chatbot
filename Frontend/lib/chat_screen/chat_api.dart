import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatAPI {
  // Update this to your Flask server URL
  static const String _baseUrl = 'http://10.0.2.2:5000/api';
  
  final String userId;
  
  ChatAPI({required this.userId});
  
  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'user_id': userId,
          'message': message,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['response'] ?? 'I received your message but have no response.';
      } else {
        return 'Sorry, I\'m having trouble connecting to the server. Please try again later.';
      }
    } catch (e) {
      return 'Network error: ${e.toString()}';
    }
  }
  
  Future<List<dynamic>> getConversationHistory() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/conversations/$userId'),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return responseData['conversations'] ?? [];
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}