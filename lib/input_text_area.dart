import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class InputTextArea extends StatelessWidget {
  final messagesReference = Firestore.instance.collection('messages');

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Container(
        child: Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: TextField(
                  controller: textController,
                  decoration: InputDecoration(
                      hintText: "Type a message",
                      contentPadding: EdgeInsets.all(10),
                      border: OutlineInputBorder()))),
        ),
        MaterialButton(
          child: Icon(Icons.send),
          onPressed: () async {
            final text = textController.text;
            textController.clear();
            await messagesReference.document().setData({
              'messageContent': text,
              'createdAt': new DateTime.now(),
            });
          },
        ),
      ],
    ));
  }
}
