import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/config/app_config.dart';

void main() {
  group('AppConfig', () {
    test('normalizes server URLs to a SignalR hub URL', () {
      expect(AppConfig.resolveServerUrl('http://192.168.1.78:5051'),
          'http://192.168.1.78:5051/chatHub');
      expect(AppConfig.resolveServerUrl('http://192.168.1.78:5051/chatHub'),
          'http://192.168.1.78:5051/chatHub');
      expect(AppConfig.resolveServerUrl('http://192.168.1.78:5051/'),
          'http://192.168.1.78:5051/chatHub');
      expect(AppConfig.resolveServerUrl('https://example.com/api'),
          'https://example.com/api/chatHub');
    });

    test('builds storage URLs from the configured base address', () {
      expect(AppConfig.resolveStorageUrl('http://host:5051', 'photo.jpg'),
          'http://host:5051/storage/photos/photo.jpg');
      expect(AppConfig.resolveStorageUrl('http://host:5051/chatHub', 'photo.jpg'),
          'http://host:5051/storage/photos/photo.jpg');
    });
  });
}
