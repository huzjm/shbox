import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/message.dart';

class MessageService {
  final String baseUrl = AppConfig.resolveBaseUrl(
    AppConfig.readServerUrl(AppConfig.defaultServerUrl),
  );

  Future<List<Message>> getMessages() async {
    final response = await http.get(Uri.parse("$baseUrl/api/messages"));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((json) => Message.fromJson(json)).toList();
    }

    throw Exception("Failed loading messages");
  }
}
