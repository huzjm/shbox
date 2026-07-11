import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message.dart';

class MessageService {
  final String baseUrl = "http://192.168.1.78:5051";

  Future<List<Message>> getMessages() async {
    final response = await http.get(Uri.parse("$baseUrl/api/messages"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((json) => Message.fromJson(json)).toList();
    }

    throw Exception("Failed loading messages");
  }
}
