import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class MessageBubble extends StatelessWidget {
  final String userName;
  final String userUid;
  final String messageContent;
  final int createdAt;

  MessageBubble(
      this.userName, this.userUid, this.messageContent, this.createdAt);

  @override
  Widget build(BuildContext context) {
    final currentUserFuture = _auth.currentUser();
    return FutureBuilder(
      future: currentUserFuture,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          final currentUserUid = snapshot.data.uid;
          Alignment messageBubbleAlignment = (currentUserUid == this.userUid)
              ? Alignment.topRight
              : Alignment.topLeft;
          return Align(
              alignment: messageBubbleAlignment,
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
                                      DateTime.fromMillisecondsSinceEpoch(
                                          createdAt)),
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      fontWeight: FontWeight.w300)))),
                    ],
                  )));
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
