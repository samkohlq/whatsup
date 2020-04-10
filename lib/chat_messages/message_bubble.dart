import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final messagesReference = Firestore.instance.collection('messages');

class Message extends StatelessWidget {
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  Message(this.documentId, this.userName, this.userUid, this.messageContent,
      this.createdAt);

  @override
  Widget build(BuildContext context) {
    final currentUserFuture = _auth.currentUser();
    return FutureBuilder(
        future: currentUserFuture,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final currentUserUid = snapshot.data.uid;
            final messageType =
                (currentUserUid == this.userUid) ? "sent" : "received";
            return currentUserUid == this.userUid
                ? DismissibleWrapper(messageType, documentId, userName, userUid,
                    messageContent, createdAt)
                : MessageBubble(
                    messageType, userName, userUid, messageContent, createdAt);
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class MessageBubble extends StatelessWidget {
  final String messageType;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  MessageBubble(this.messageType, this.userName, this.userUid,
      this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    Alignment alignment;
    Color bubbleColor;
    if (messageType == "sent") {
      alignment = Alignment.topRight;
      bubbleColor = Colors.lightBlue[100];
    } else {
      alignment = Alignment.topLeft;
      bubbleColor = Colors.grey[350];
    }
    return Align(
        alignment: alignment,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.6,
            margin: const EdgeInsets.only(top: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: bubbleColor,
                border: Border.all(
                  color: bubbleColor,
                ),
                borderRadius: BorderRadius.all(const Radius.circular(5))),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(userName,
                            style: TextStyle(
                                color: Colors.black.withOpacity(0.5),
                                fontWeight: FontWeight.bold)))),
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

class DismissibleWrapper extends StatelessWidget {
  final String messageType;
  final String documentId;
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  DismissibleWrapper(this.messageType, this.documentId, this.userName,
      this.userUid, this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(documentId),
        direction: DismissDirection.endToStart,
        background: Container(
            color: Colors.red[300],
            margin: const EdgeInsets.only(top: 10),
            child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: Icon(Icons.cancel, color: Colors.white)))),
        onDismissed: (direction) {
          messagesReference.document(documentId).delete();
        },
        child: MessageBubble(
            messageType, userName, userUid, messageContent, createdAt));
  }
}
