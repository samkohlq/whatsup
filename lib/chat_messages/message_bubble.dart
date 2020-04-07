import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final String messageContent;
  final int createdAt;

  MessageBubble(this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[350],
                border: Border.all(
                  color: Colors.grey[350],
                ),
                borderRadius: BorderRadius.all(const Radius.circular(5))),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(messageContent))),
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                            DateFormat('dd MMM yy HH:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(createdAt)),
                            style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300)))),
              ],
            )));
  }
}
