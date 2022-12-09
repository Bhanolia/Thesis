import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Card/user_card.dart';

class readuser extends StatelessWidget {
  final String documentID;

  readuser({required this.documentID});

  @override
  Widget build(BuildContext contex) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(documentID).get(),
        builder: (contex, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Text(data['email']);
          } else {
            return Text("loading");
          }
        });
  }
}
