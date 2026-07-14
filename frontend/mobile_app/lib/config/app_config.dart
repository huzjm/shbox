import 'dart:io';

import 'package:flutter/foundation.dart';

class AppConfig {
  static const String defaultServerUrl = 'http://localhost:5051';
  static const String defaultDeviceId = 'sakina-shbox';

  static String readServerUrl(String fallback) {
    const compileTimeValue = String.fromEnvironment(
      'SHBOX_SERVER_URL',
      defaultValue: '',
    );
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }

    if (!kIsWeb) {
      final runtimeValue = Platform.environment['SHBOX_SERVER_URL'];
      if (runtimeValue != null && runtimeValue.isNotEmpty) {
        return runtimeValue;
      }
    }

    return fallback;
  }

  static String readDeviceId(String fallback) {
    const compileTimeValue = String.fromEnvironment(
      'SHBOX_DEVICE_ID',
      defaultValue: '',
    );
    if (compileTimeValue.isNotEmpty) {
      return compileTimeValue;
    }

    if (!kIsWeb) {
      final runtimeValue = Platform.environment['SHBOX_DEVICE_ID'];
      if (runtimeValue != null && runtimeValue.isNotEmpty) {
        return runtimeValue;
      }
    }

    return fallback;
  }

  static String resolveServerUrl(String? configuredValue) {
    final value = (configuredValue ?? defaultServerUrl).trim();
    if (value.isEmpty) {
      return '$defaultServerUrl/chatHub';
    }

    final normalized = value.endsWith('/')
        ? value.substring(0, value.length - 1)
        : value;
    if (normalized.endsWith('/chatHub')) {
      return normalized;
    }

    return '$normalized/chatHub';
  }

  static String resolveBaseUrl(String? configuredValue) {
    final serverUrl = resolveServerUrl(configuredValue);
    return serverUrl.replaceAll(RegExp(r'/chatHub\/?$'), '');
  }

  static String resolveStorageUrl(String? configuredValue, String fileName) {
    final baseUrl = resolveBaseUrl(configuredValue);
    return '$baseUrl/storage/photos/$fileName';
  }
}
