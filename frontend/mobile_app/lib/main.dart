import 'package:flutter/material.dart';
import 'package:mobile_app/screens/chat_screen.dart';

void main() {
  runApp(const SHBoxApp());
}

class SHBoxApp extends StatelessWidget {
  const SHBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SHBox',
      theme: ThemeData.dark(),
      home: const ChatPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
