import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Baner.dart';
import 'package:manager/Widget/Card/Announcement_Card.dart';
import 'package:manager/Widget/Card/Archive_Card.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/Announcement_Model.dart';
import 'package:manager/model/Archive_Model.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/pages/Notification/Notification.dart';
import 'package:manager/pages/announcement/detail_announcement.dart';
import 'package:manager/services/auto_archive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import '';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final auth = FirebaseAuth.instance.currentUser!;
  late String email = auth.email!;
  late final String? DocIdUser;
  late String Roles = "";
  var _colorpurple400 = Colors.purple.shade400;
  String? _token;
  List<Object> _Academic_data = [];
  List<Object> _NonAcademic_data = [];
  late Stream<String> _tokenStream;
  int itemlimit = 4;
  var boxdecoration = BoxDecoration(
    border: Border(bottom: BorderSide(color: Colors.purple.shade400)),
    color: Colors.white,
  );

  void setToken(String? token) {
    // print('FCM Token: $token');

    FirebaseFirestore.instance
        .collection("Fcm_Token")
        .doc(auth.uid)
        .set({"token": token});
    setState(() {
      _token = token;
    });
  }

  @override
  void initState() {
    Lastlogin();
    FirebaseMessaging.instance
        .getToken(
            vapidKey:
                'BGN2gVHCxwYr9kkHE7ukm9ClfIPjfQT77tt1BSt7DwGZwSxfZppAD9mX2oQvUD5frl7A1wXSkyAApZikpsfveLQ')
        .then(setToken);
    _tokenStream = FirebaseMessaging.instance.onTokenRefresh;
    _tokenStream.listen(setToken);

    _NonAcademic_data = [];
    _NonAcademic_data = [];
    super.initState();
  }

  final Stream<QuerySnapshot> _announcement_academic_Stream = FirebaseFirestore
      .instance
      .collection('Announcement')
      .where('Categories', isEqualTo: "Academic")
      .orderBy('Date_Creation', descending: true)
      .snapshots();
  final Stream<QuerySnapshot> _announcement_nonacademic_Stream =
      FirebaseFirestore.instance
          .collection('Announcement')
          .where('Categories', isEqualTo: "Non-Academic")
          .orderBy('Date_Creation', descending: true)
          .snapshots();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: _colorpurple400,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        actions: <Widget>[],
        elevation: 0.0,
        title: Text("Hompage"),
      ),
      drawer: DrawerUser(),
      body:
          // Center(
          //   child:
          Container(
        margin: EdgeInsets.only(bottom: 0.0, left: 20.0, right: 20.0),
        padding: EdgeInsets.only(top: 0.0, bottom: 0.0),
        color: Colors.white,
        child: ListView(
          shrinkWrap: true,
          // padding: EdgeInsets.only(left: 20.0, right: 20.0),
          children: <Widget>[
            Container(
              height: height * 0.20,
              child: baner(),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
              // color: Colors.blue,
              margin: EdgeInsets.only(top: 0.0, bottom: 10.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    FontAwesomeIcons.bullhorn,
                    size: 15.0,
                    color: _colorpurple400,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text("Announcement",
                        style: TextStyle(
                            fontSize: 15,
                            color: _colorpurple400,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Container(
              // color: Colors.blue,
              // margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Academic",
                    style: TextStyle(
                        fontSize: 15,
                        color: _colorpurple400,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: height * 0.25,
              // color: Colors.purple.shade400,
              child: StreamBuilder<QuerySnapshot>(
                stream: _announcement_academic_Stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final fromsnapshoot = snapshot.data!.docs
                        .map((e) => Announcement_Model.fromSnapshot(e));
                    _Academic_data = List.from(fromsnapshoot);
                    // print(_Academic_data.length);
                    if (_Academic_data.length == 0) {
                      return Center(
                          child: Container(
                              child: Text(
                        "Empty",
                        style: TextStyle(
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.bold),
                      )));
                    } else {
                      final itemlength;
                      if (_Academic_data.length > itemlimit) {
                        itemlength = itemlimit;
                      } else {
                        itemlength = _Academic_data.length;
                      }

                      return Container(
                        // decoration: BoxDecoration(
                        //   border: Border.all(),
                        //   color: _colorpurple400,
                        // ),
                        child: ListView.builder(
                          itemCount: itemlength,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final parse =
                                _Academic_data[index] as Announcement_Model;
                            // var judul = Announcement_Model.fromSnapshot(parse);
                            // print("value judul ${parse.Tittle}");
                            return GestureDetector(
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(top: 2.0),
                                decoration: boxdecoration,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0, bottom: 0.0, left: 25.0),
                                  child: Center(
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        "${index + 1}. ${parse.Tittle}",
                                        style:
                                            TextStyle(color: _colorpurple400),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPageAnnouncement(
                                                announcement_model: parse)));
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: _colorpurple400,
                      ),
                    );
                  }
                  return CircularProgressIndicator(
                    color: _colorpurple400,
                  );
                },
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Container(
              // color: Colors.blue,
              // margin: EdgeInsets.only(bottom: 20.0),
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text("Non-Academic",
                    style: TextStyle(
                        fontSize: 15,
                        color: _colorpurple400,
                        fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              height: height * 0.25,
              // color: Colors.purple.shade400,
              child: StreamBuilder<QuerySnapshot>(
                stream: _announcement_nonacademic_Stream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final fromsnapshoot = snapshot.data!.docs
                        .map((e) => Announcement_Model.fromSnapshot(e));
                    _NonAcademic_data = List.from(fromsnapshoot);
                    // print(_NonAcademic_data.length);
                    if (_NonAcademic_data.length == 0) {
                      return Center(
                          child: Container(
                              // color: Colors.white,
                              child: Text(
                        "Empty",
                        style: TextStyle(
                            color: Colors.purple.shade400,
                            fontWeight: FontWeight.bold),
                      )));
                    } else {
                      final itemlength;
                      if (_NonAcademic_data.length > itemlimit) {
                        itemlength = itemlimit;
                      } else {
                        itemlength = _NonAcademic_data.length;
                      }
                      return Container(
                        child: ListView.builder(
                          itemCount: itemlength,
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemBuilder: (context, index) {
                            final parse =
                                _NonAcademic_data[index] as Announcement_Model;
                            // var judul = Announcement_Model.fromSnapshot(parse);
                            // print("value judul ${parse.Tittle}");
                            return GestureDetector(
                              child: Container(
                                height: 40,
                                margin: EdgeInsets.only(top: 0.0, bottom: 0.0),
                                decoration: boxdecoration,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: 0.0, bottom: 0.0, left: 25.0),
                                  child: Center(
                                    child: ListTile(
                                      dense: true,
                                      title: Text(
                                        "${index + 1}. ${parse.Tittle}",
                                        style:
                                            TextStyle(color: _colorpurple400),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPageAnnouncement(
                                                announcement_model: parse)));
                              },
                            );
                          },
                        ),
                      );
                    }
                  } else if (snapshot.hasError) {
                    return Text(snapshot.hasError.toString());
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: _colorpurple400,
                      ),
                    );
                  }
                  return CircularProgressIndicator(
                    color: _colorpurple400,
                  );
                },
              ),
            ),
            Divider(
              color: Colors.transparent,
            ),
            Divider(
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  Future Lastlogin() async {
    final firestore = await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .limit(1)
        .get();
    firestore.docs.forEach((element) async {
      // print(element.id);
      DocIdUser = element.id;
      setState(() {
        Roles = element.data()['role'];
      });
    });

    final UpdateLastlogin =
        await FirebaseFirestore.instance.collection("users").doc(DocIdUser);
    UpdateLastlogin.update({"lastlogin": DateTime.now(), "userId": auth.uid});
    // print("update success");

    await autoarchive(Roles);
  }
}
