import 'package:flutter/material.dart';
import 'package:signalr_netcore/signalr_client.dart';

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

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late HubConnection connection;
  final TextEditingController controller = TextEditingController();
  List<String> messages = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    initSignalR();
  }

  Future<void> initSignalR() async {
    connection = HubConnectionBuilder()
        .withUrl("http://192.168.1.78:5051/chatHub") // CHANGE PORT IF NEEDED
        .withAutomaticReconnect()
        .build();

    connection.on("ReceiveMessage", (arguments) {
      final msg = arguments![0].toString();
      setState(() {
        messages.add(msg);
      });
    });

    // Note: onclose callback removed due to signature mismatch with package typedef.
    // Connection state will be updated on successful start/failure and on send errors.

    try {
      await connection.start();
      setState(() {
        isConnected = true;
        messages.add("Connected to SHBox ❤️");
      });
    } catch (e) {
      setState(() {
        isConnected = false;
        messages.add("Connection failed: $e");
      });
    }
  }

  void sendMessage() async {
    if (controller.text.isEmpty) return;

    if (!isConnected) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Not connected to server')));
      return;
    }

    try {
      await connection.invoke(
        "SendMessage",
        args: [
          {'Sender': 'Mobile', 'Content': controller.text, 'Type': 'text'},
        ],
      );
      controller.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Send failed: $e')));
    }
  }

  @override
  void dispose() {
    connection.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SHBox Chat"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Center(
              child: Text(
                isConnected ? 'Online' : 'Offline',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  return ListTile(title: Text(messages[index]));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(
                        hintText: "Type message...",
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: isConnected ? sendMessage : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
