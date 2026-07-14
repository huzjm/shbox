import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/photo.dart';

class PhotoService {
  final String baseUrl = AppConfig.resolveBaseUrl(
    AppConfig.readServerUrl(AppConfig.defaultServerUrl),
  );

  Future<List<Photo>> getPhotos() async {
    final response = await http
        .get(Uri.parse("$baseUrl/api/photos"))
        .timeout(const Duration(seconds: 10));

    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);

      return data.map((x) => Photo.fromJson(x)).toList();
    }

    throw Exception("Failed loading photos");
  }
}
