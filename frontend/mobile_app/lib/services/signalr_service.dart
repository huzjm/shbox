import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';
import '../config/app_config.dart';
import '../models/message.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  factory SignalRService() => _instance;
  SignalRService._internal();

  HubConnection? _connection;
  Future<void>? _connectFuture;

  final String serverUrl = AppConfig.resolveServerUrl(
    AppConfig.readServerUrl(AppConfig.defaultServerUrl),
  );

  final String deviceId = AppConfig.readDeviceId(AppConfig.defaultDeviceId);

  String get connectionUrl {
    if (serverUrl.contains('?')) {
      return '$serverUrl&deviceId=$deviceId';
    }

    return '$serverUrl?deviceId=$deviceId';
  }

  final StreamController<Message> _messageController =
      StreamController<Message>.broadcast();
  final StreamController<Map<String, dynamic>> _commandController =
      StreamController<Map<String, dynamic>>.broadcast();
  final StreamController<void> _photoController =
      StreamController<void>.broadcast();

  Stream<Message> get messages => _messageController.stream;
  Stream<Map<String, dynamic>> get commands => _commandController.stream;
  Stream<void> get photos => _photoController.stream;

  bool get isConnected => _connection?.state == HubConnectionState.Connected;

  Future<void> connect() {
    if (_connection != null && isConnected) {
      return Future.value();
    }
    if (_connectFuture != null) {
      return _connectFuture!;
    }

    _connectFuture = _initializeConnection();
    return _connectFuture!;
  }

  Future<void> _initializeConnection() async {
    _connection = HubConnectionBuilder()
        .withUrl(connectionUrl)
        .withAutomaticReconnect()
        .build();

    _connection!.on("ReceiveMessage", (arguments) {
      final data = arguments![0] as Map<String, dynamic>;
      _messageController.add(Message.fromJson(data));
    });

    _connection!.on("ReceiveCommand", (arguments) {
      final command = Map<String, dynamic>.from(arguments![0] as Map);
      _commandController.add(command);
    });

    _connection!.on("NewPhoto", (arguments) {
      _photoController.add(null);
    });

    await _connection!.start();
  }

  Future<void> sendMessage(String text) async {
    await connect();
    await _connection!.invoke(
      "SendMessage",
      args: [
        {
          "sender": "Huzefa",
          "content": text,
          "type": "text",
          "timestamp": DateTime.now().toIso8601String(),
        },
      ],
    );
  }

  Future<void> sendCommand(String type) async {
    await connect();
    await _connection!.invoke(
      "SendCommand",
      args: [
        {
          "type": type,
          "sender": "Huzefa",
          "data": "",
          "deviceId": deviceId,
          "status": "queued",
        },
      ],
    );
  }

  Future<void> disconnect() async {
    await _connection?.stop();
    _connection = null;
    _connectFuture = null;
  }

  Future<void> dispose() async {
    await disconnect();
    await _messageController.close();
    await _commandController.close();
    await _photoController.close();
  }
}
