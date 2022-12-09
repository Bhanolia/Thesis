import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Card/Announcement_Card.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/pages/announcement/upload_announcement.dart';

class Announcement extends StatefulWidget {
  @override
  _Announcement createState() => _Announcement();
}

class _Announcement extends State<Announcement> {
  List<Object> _Announ_data = [];
  late List<File> files;
  late String role;
  bool _isVisible = false;

  @override
  void initState() {
    // getAnnouncementdata();
    getRole();
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   getAnnouncementdata();
  //   super.didChangeDependencies();
  //
  // }
  final Stream<QuerySnapshot> _announcementStream = FirebaseFirestore.instance
      .collection('Announcement')
      // .where('Categories', isEqualTo: "Academic")
      .orderBy('Date_Creation', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("Announcement"),
        backgroundColor: Colors.purple,
      ),
      drawer: DrawerUser(),
      backgroundColor: Colors.purple.shade400,
      body: StreamBuilder<QuerySnapshot>(
        stream: _announcementStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            final fromsnapshoot = snapshot.data!.docs
                .map((e) => Announcement_Model.fromSnapshot(e));
            _Announ_data = List.from(fromsnapshoot);
            // print(_Announ_data.length);
            if (_Announ_data.length == 0) {
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
                    return announcement_card(
                        announcement_model:
                            _Announ_data[index] as Announcement_Model);
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
                builder: (context) => new UploadAnnouncement()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // Future getAnnouncementdata() async {
  //   var firestore = await FirebaseFirestore.instance
  //       .collection("Announcement")
  //       .orderBy('Date_Creation', descending: true)
  //       .get();
  //   // setState(() {
  //   _Announ_data = List.from(
  //       firestore.docs.map((data) => Announcement_Model.fromSnapshot(data)));
  //   // });
  // }
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
