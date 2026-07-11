import 'package:flutter/material.dart';
import '../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;
  final bool isMe;

  const MessageBubble({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),

        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(message.content, style: const TextStyle(fontSize: 18)),

            const SizedBox(height: 5),

            Text(
              "${message.timestamp.hour}:${message.timestamp.minute}",
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
