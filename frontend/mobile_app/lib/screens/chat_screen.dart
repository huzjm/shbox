import 'package:flutter/material.dart';
import 'package:mobile_app/models/message.dart';
import 'package:mobile_app/widgets/message_bubble.dart';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:mobile_app/services/message_service.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late HubConnection connection;
  final MessageService service = MessageService();
  final TextEditingController controller = TextEditingController();
  List<Message> messages = [];
  bool isConnected = false;

  @override
  void initState() {
    super.initState();

    loadMessages();

    initSignalR();
  }

  Future<void> loadMessages() async {
    final oldMessages = await service.getMessages();

    setState(() {
      messages = oldMessages;
    });
  }

  Future<void> initSignalR() async {
    connection = HubConnectionBuilder()
        .withUrl("http://192.168.1.78:5051/chatHub") // CHANGE PORT IF NEEDED
        .withAutomaticReconnect()
        .build();

    connection.on("ReceiveMessage", (arguments) {
      final data = Map<String, dynamic>.from(arguments![0] as Map);

      setState(() {
        messages.add(Message.fromJson(data));
      });
    });

    // Note: onclose callback removed due to signature mismatch with package typedef.
    // Connection state will be updated on successful start/failure and on send errors.

    try {
      await connection.start();
      setState(() {
        isConnected = true;
        messages.add(
          Message(
            sender: 'Server',
            content: 'Connected to SHBox ❤️',
            type: 'text',
            id: 0,
            timestamp: DateTime.now(),
          ),
        );
      });
    } catch (e) {
      setState(() {
        isConnected = false;
        messages.add(
          Message(
            sender: 'Server',
            content: 'Connection failed: $e',
            type: 'text',
            id: 0,
            timestamp: DateTime.now(),
          ),
        );
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
          {
            'sender': 'Mobile',
            'content': controller.text,
            'type': 'text',
            'timestamp': DateTime.now().toIso8601String(),
          },
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
                  return ListTile(
                    title: MessageBubble(
                      message: messages[index],
                      isMe: messages[index].sender == "Huzefa",
                    ),
                  );
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
