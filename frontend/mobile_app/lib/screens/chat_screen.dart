import 'package:flutter/material.dart';

import '../models/message.dart';
import '../services/message_service.dart';
import '../services/signalr_service.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  bool connected = false;
  final SignalRService signalR = SignalRService();
  final MessageService api = MessageService();
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();
  List<Message> messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages();
    setupSignalR();
  }

  Future<void> loadMessages() async {
    final result = await api.getMessages();
    if (!mounted) return;
    setState(() {
      messages = result;
    });
  }

  Future<void> setupSignalR() async {
    signalR.messages.listen((message) {
      if (!mounted) return;
      setState(() {
        messages.add(message);
      });

      Future.delayed(const Duration(milliseconds: 100), () {
        if (!scrollController.hasClients) return;
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    });

    await signalR.connect();
    if (!mounted) return;
    setState(() {
      connected = true;
    });
  }

  void send() {
    if (controller.text.isEmpty) return;

    signalR.sendMessage(controller.text);
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SHBox ❤️"),
            Text(
              connected ? "Online" : "Connecting...",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(
                  message: messages[index],
                  isMe: messages[index].sender == "Huzefa",
                );
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(hintText: "Message..."),
                ),
              ),
              IconButton(icon: const Icon(Icons.send), onPressed: send),
            ],
          ),
        ],
      ),
    );
  }
}
