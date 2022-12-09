import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Card/Archive_Card.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Archive_Model.dart';
import 'package:manager/pages/archive/upload_archive.dart';

class archive extends StatefulWidget {
  @override
  _archive createState() => _archive();
}

class _archive extends State<archive> {
  List<Object> _Archive_data = [];
  late List<File> files;
  late String role;
  bool _isVisible = false;

  @override
  void initState() {
    getRole();
    super.initState();
  }

  final Stream<QuerySnapshot> _archiveStream = FirebaseFirestore.instance
      .collection('Archive')
      .orderBy('Date_Creation', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("Archive"),
        backgroundColor: Colors.purple,
      ),
      drawer: DrawerUser(),
      backgroundColor: Colors.purple.shade400,
      body: StreamBuilder<QuerySnapshot>(
        stream: _archiveStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final fromsnapshoot =
                snapshot.data!.docs.map((e) => Archive_Model.fromSnapshot(e));
            _Archive_data = List.from(fromsnapshoot);
            // print("Archive lengt ${_Archive_data.length}");

            if (_Archive_data.length == 0) {
              return Center(
                  child: Container(
                      child: Text(
                "Empty",
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              )));
            } else {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return archive_card(
                        archive_Model: _Archive_data[index] as Archive_Model);
                    return Text("$index");
                  });
            }
          } else if (snapshot.hasError) {
            return Text(snapshot.hasError.toString());
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return CircularProgressIndicator();
        },
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          hoverColor: Colors.black,
          focusColor: Colors.deepPurple,
          autofocus: true,
          onPressed: () {
            Navigator.of(context).push(new MaterialPageRoute(
                builder: (context) => new UploadArchive()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  Future getRole() async {
    String DocIdUser;
    final auth = await FirebaseAuth.instance.currentUser?.uid;
    final Firestore = await FirebaseFirestore.instance
        .collection("users")
        .where("userId", isEqualTo: auth)
        .limit(1)
        .get();

    Firestore.docs.forEach((element) async {
      // print(element.id);
      role = element.data()['role'];
      // print(role);
    });

    if (role == "Admin") {
      setState(() {
        _isVisible = true;
      });
    }
  }
}
