import 'package:flutter/material.dart';
import '../models/message.dart';


class MessageBubble extends StatelessWidget {

  final Message message;
  final bool isMe;


  const MessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });


  @override
  Widget build(BuildContext context) {

    return Align(

      alignment:
      isMe
          ? Alignment.centerRight
          : Alignment.centerLeft,


      child: Container(

        constraints:
        const BoxConstraints(
          maxWidth: 300,
        ),


        margin:
        const EdgeInsets.symmetric(
          vertical: 6,
          horizontal: 12,
        ),


        padding:
        const EdgeInsets.all(14),


        decoration:

        BoxDecoration(

          borderRadius:
          BorderRadius.circular(18),

        ),



        child:

        Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,


          children:[


            Text(

              message.sender,

              style:
              const TextStyle(
                fontSize:12,
              ),

            ),



            const SizedBox(
              height:5,
            ),



            Text(

              message.content,

              style:
              const TextStyle(
                fontSize:18,
              ),

            ),



            const SizedBox(
              height:5,
            ),



            Text(

              formatTime(
                message.timestamp
              ),

              style:
              const TextStyle(
                fontSize:11,
              ),

            ),


          ],

        ),

      ),

    );

  }



  String formatTime(DateTime time){

    return
    "${time.hour}:${time.minute.toString().padLeft(2,'0')}";

  }

}