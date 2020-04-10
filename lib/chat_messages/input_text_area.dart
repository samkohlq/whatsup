import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class InputTextArea extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
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
            final currentUser = await _auth.currentUser();
            // clear input area once user sends message
            textController.clear();
            // update firestore with user's new message
            await messagesReference.document().setData({
              'messageContent': text,
              'createdAt': new DateTime.now().millisecondsSinceEpoch,
              'userName': currentUser.displayName,
              'userUid': currentUser.uid,
            });
          },
        ),
      ],
    ));
  }
}
