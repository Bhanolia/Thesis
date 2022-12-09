import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:manager/Widget/Drawer.dart';
import 'package:manager/model/User_Model.dart';
import 'package:manager/Widget/Card/user_card.dart';
import 'package:manager/pages/Auth/register.dart';
import 'package:manager/pages/Users/user_services.dart';
import 'package:manager/pages/home.dart';

class userlist extends StatefulWidget {
  @override
  _userlist createState() => _userlist();
}

class _userlist extends State<userlist> {
  List<Object> _userdata = [];

  final Stream<QuerySnapshot> _userSteam = FirebaseFirestore.instance
      .collection('users')
      .orderBy('lastlogin', descending: true)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            actions: <Widget>[],
            elevation: 0.0,
            backgroundColor: Colors.purple,
            title: Text("user"),
          ),
          backgroundColor: Colors.purple.shade400,
          drawer: DrawerUser(),
          body: StreamBuilder<QuerySnapshot>(
            stream: _userSteam,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                final fromsnapshoot =
                    snapshot.data!.docs.map((e) => user_model.fromSnapshot(e));
                _userdata = List.from(fromsnapshoot);

                // print(_userdata.length);
                if (_userdata.length == 0) {
                  return Center(
                      child: Container(
                          child: Text(
                    "Empty",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )));
                } else {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        return userCard(umodel: _userdata[index] as user_model);
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurple,
            hoverColor: Colors.black,
            focusColor: Colors.deepPurple,
            autofocus: true,
            onPressed: () {
              Navigator.of(context).push(
                  new MaterialPageRoute(builder: (context) => new Register()));
            },
            child: const Icon(Icons.add),
          ),
        ),
        onWillPop: () async {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
          return true;
        });
  }
}
