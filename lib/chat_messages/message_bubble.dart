import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String messageContent;
  // final int createdAt;
  // MessageBubble(this.messageContent, this.createdAt);
  MessageBubble(this.messageContent);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.7,
          margin: const EdgeInsets.only(top: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
              color: Colors.grey[350],
              border: Border.all(
                color: Colors.grey[350],
              ),
              borderRadius: BorderRadius.all(const Radius.circular(5))),
          child: Text(messageContent),
        ));
  }
}
